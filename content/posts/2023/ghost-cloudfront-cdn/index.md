---
author: Major Hayden
date: '2023-07-03'
summary: |
  Adding an AWS CloudFront CDN distribution to a Ghost blog improves response times
  on an already fast blogging platform and increases security along the way. ⚡
tags:
  - aws
  - cdn
  - cloudfront
  - ghost
  - ssl
title: Add CloudFront CDN to a Ghost blog
coverAlt: Blue neon lights along a dark hallway
coverCaption: |
  Photo by <a href="https://unsplash.com/@bappie?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Bappie</a>
  on <a href="https://unsplash.com/wallpapers/colors/neon?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
---

After I launched my new [stock market blog](https://thetanerd.com/) on a self-hosted [Ghost](https://ghost.org/), I wrote up the [deployment process](/p/deploy-ghost/) in containers last week.
Then I had a shower thought: _How do I put a CDN in front of that?_

This blog is back on an [S3 + CloudFront deployment](/p/cloudfront-migration/) at AWS and I figured CloudFront could work well for a self-hosted Ghost blog, too.

There are **tons** of blog posts out there that have outdated processes or only show you how to do one piece of the CDN deployment for Ghost.
I read most of them and cobbled together a working deployment.
Read on to learn how to do this yourself!

# Why add a CDN?

Content Delivery Networks (CDN) enhance websites by doing a combination of different things:

1. **High throughput content delivery.**
   CDNs have extremely well connected systems with plenty of bandwidth available.
   When your web traffic goes overboard or a popular person links to your site, CDNs allow you to continue serving content at very high rates.
2. **Cached content.**
   CDNs will pull content from your origin server (the one running your application) and cache that content for you.
   This means fewer requests to your origin server and less bandwidth consumed there.
3. **Content closer to consumers.**
   You might host your site in the eastern USA, but a CDN can cache your content around the world for faster access.
   Your website might normally be slow for someone in Tokyo, but a local CDN endpoint in Japan could serve that content immediately there.
4. **Improved security.**
   Many CDNs offer a web application firewall (WAF) that allows you to limit access to certain functions on your site.
   This could prevent or slow down certain types of attacks that could take your site offline.

CDNs have trade-offs, though.
**They're complicated.**

They often require lots of DNS changes.
TLS certificates remain a challenge.
Caching solves lots of problems but can create headaches in a flash.
A misconfiguration at the CDN level can take down your site or prevent it from operating properly for longer periods of time.

Careful planning helps a lot! _Measure twice, cut once._

# AWS terminology

The names of various AWS services often confuse me, but here's what we need for this project:

* **AWS Certificate Manager:** handles TLS certificate issuance and renewal for the CDN distribution
* **AWS CloudFront:** the actual CDN itself

CloudFront has a concept of _distributions_, which is a single configuration of the CDN for a particular site.
We will get to that in the CloudFront section. 😉

# Certificates

First off, we need a certificate for TLS connections.
Run over to the [AWS Certificate Manager (ACM) console](https://us-east-1.console.aws.amazon.com/acm/home?region=us-east-1#/certificates/list) for your preferred region and follow these steps:

1. Click the orange **Request** button at the top right.
2. Request a public certificate on the next page and click **Next**.
3. Type in the domain for your certificate that your users will type to access your site.
   For example, `example.com` or `blog.example.com`.
4. Click **Request**

You should be back to your certificate list.
Refresh the page by clicking on the circle with the arrow at the top right.
Click on the certificate for the domain name you just added.

In the second detail block labeled **Details**, look for the CNAME name and value at the far right.
You need to set both of these wherever you host your DNS records.
If you use AWS Route 53 for DNS, there's a button you can click there to do it immediately.
If you use another DNS provider, create a CNAME record with the exact text shown there.

Once you create those DNS records, go back to the page with your certificate and wait for it to change from _Pending validation_ to _Issued_.
This normally takes 2-3 minutes for most DNS providers I use.

{{< alert >}}
Wait for this to turn green and say _Issued_ before proceeding to the next step!
{{< /alert >}}

Now that you have a certificate, it's time to configure our CDN distribution.

# CloudFront

Now comes the fun, but complicated part.
You have two DNS records to think about here:

* The CDN DNS record that users will type to access your site, such as `example.com`.
* The origin DNS record that the CDN will use to access your backend Ghost blog, such as `origin.example.com`.

The _origin_ record will be hidden away behind the CDN when we're done.

## Create the distribution

Go to the [CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-2#/distributions) in your preferred region and follow these steps:

1. Click **Create Distribution** at the top right.
2. Put your origin (hidden) domain in _Origin domain_, such as `origin.example.com`.
3. Skip down to **Name** for the distribution such as _"My Ghost Blog"_.
   _(This is for your internal use only.)_
4. **Compress objects automatically:** `Yes`
5. **Viewer protocol policy:** `Redirect HTTP to HTTPS`
6. **Allowed HTTP methods:** `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`
7. **Cache policy:** `CachingOptimized`
8. **Origin request policy:** `AllViewerExceptHostHeader`
9. **WAF**: `Do not enable security protections`
   _(This costs extra and you can tweak this configuration later if needed.)_
10. **Alternate domain name (CNAME):** Use the DNS name that your users will access, such as `example.com`
11. **Custom SSL certificate:** Choose the certificate we created in the previous section
11. Click **Create distribution**

This can take up to 10 minutes to deploy once you're finished.
At this point, we have an aggressive caching policy that will cause problems when members attempt to sign in or manage their membership.
It will also break the Ghost administrative area.

Let's fix that next.

## Adjust caching

Find the CloudFront distribution we just created and click the **Behaviors** tab.
We are going to make three different sets of behavior configurations to handle the dynamic pages.

Click **Create Behavior** and do the following:

1. Enter `/ghost*` as the path pattern.
2. Choose the origin from the drop down that you specified when creating the distribution.
3. **Compress objects automatically:** `Yes`
4. **Viewer protocol policy:** `Redirect HTTP to HTTPS`
5. **Allowed HTTP methods:** `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`
6. **Cache policy:** `CachingDisabled`
7. **Origin request policy:** `AllViewer`
8. Click **Save changes**

That takes care of the administrative interface.
Now let's fix the caching on the members page:

1. Enter `/members*` as the path pattern.
2. Choose the origin from the drop down that you specified when creating the distribution.
3. **Compress objects automatically:** `Yes`
4. **Viewer protocol policy:** `Redirect HTTP to HTTPS`
5. **Allowed HTTP methods:** `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`
6. **Cache policy:** `CachingDisabled`
7. **Origin request policy:** `AllViewer`
8. Click **Save changes**

With this configuration, we have caching for all content except for the administrative and member interfaces.

# Testing

There are a few different ways to test at this point, but I prefer to go with an old tried and true method: the `/etc/hosts` file. 😜

CloudFront offers a domain name on `*.cloudfront.net` that you can use, but it's not quite the same.
Cookies for the admin/member interface don't always work since they cross domains and sometimes you're redirected back to the original domain name which bypasses the CDN altogether.

Go back to the list of distributions in your [CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-2#/distributions) in your preferred region.
Click on the distribution you created earlier.
At the top left, you'll see **Distribution domain name** with a domain underneath that contains `random_text.cloudfront.net`.

Take that domain name and get an IPv4 address:

```console
$ dig +short A d2xznlk9a1h8zn.cloudfront.net 
18.161.156.2
18.161.156.18
18.161.156.61
18.161.156.9
```

Open `/etc/hosts` in your favorite editor (root access required) and use one of the IP addresses that correspond to your CDN endpoint.
Add a line like this one (using your CDN domain and IPv4 address from the last step):

```plain
18.161.156.2     example.com
```

Access your site in a browser and verify that everything works.
Be sure that you can access the administrative console under `example.com/ghost` and any member settings.

️Remove the line in `/etc/hosts` now that we're finished with testing.

# Production

Our first step is to set up the origin.

## Origin configuration

Ensure your origin server has a proper DNS record so that CloudFront can access it on the backend.
For example, `origin.example.com` must have a DNS record that points to your backend server running Ghost.

{{< alert >}}
Verify that the DNS record for your origin works before proceeding. 💣
{{< /alert >}}

If you followed my [guide for deploying Ghost](/p/deploy-ghost/), then you need to adjust your caddy configuration to answer requests to your origin URL.
I updated my Caddyfile to contain both the origin and CDN hostnames:

```caddy
{
    email major@mhtx.net
}
thetanerd.com, origin.thetanerd.com {
    reverse_proxy ghost:2368
    log {
        output stderr
        format console
    }
}

www.thetanerd.com {
    redir https://thetanerd.com{uri}
}
```

Restart caddy with `sudo docker-compose restart caddy`.

{{< alert >}}
Verify that caddy responds to requests **to the origin hostname** before going any further.
It must respond properly with a valid SSL/TLS certificate! 💣
{{< /alert >}}

## Big switch

Now that our origin server is happy and responding, it's time to make the big switch.
We're going to remove the record for the main CDN domain, such as `example.com` and replace it with a CNAME or ALIAS record to the CDN name in CloudFront.
This is the name that ends in `cloudfront.net` that we used for testing earlier.

The use of a CNAME or ALIAS record depends on your DNS host and the type of domain name you're using for the CDN.

* If you're using apex domain name (no subdomain) such as `example.com`, you will likely need to use an `ALIAS` record
* For domain names with a subdomain, such as `blog.example.com`, you will likely need to use a `CNAME` record

{{< alert >}}
Read your DNS host's documentation if you are unsure about ALIAS vs CNAME records! 💣
{{< /alert >}}

Go your DNS registrar and follow these steps:

* Screenshot your existing DNS records or export them if possible (in case you need to revert).
* Remove the existing A/AAAA/CNAME/ALIAS record(s) for your main domain name, such as `example.com`.
* Immediately add a CNAME/ALIAS record from `example.com` to `random_text.cloudfront.net` that corresponds to your CloudFront distribution.

Once that's done, I usually run `curl` in a terminal to watch for the changeover with `watch curl -si https://example.com`.
When CloudFront is handling your traffic you'll see headers like these:

```plain
HTTP/2 200 
content-type: text/html; charset=utf-8
cache-control: public, max-age=0
date: Mon, 03 Jul 2023 19:44:55 GMT
server: Caddy
x-powered-by: Express
etag: W/"19e7b-q5fZSjf8acC7o9lhdO5R+jOASfM"
vary: Accept-Encoding
x-cache: Miss from cloudfront
via: 1.1 b2ba542a917451d9d85e07dba0cfd9a4.cloudfront.net (CloudFront)
x-amz-cf-pop: DFW57-P2
x-amz-cf-id: Tpcjk886L0xAZzOjuUP-js_7-twE7ZGDZKlkmGHNTjW8hEs7oOWaLg==
```

If it seems like it's taking a very long time to change over, use a tool like [DNS Checker](https://dnschecker.org/) to see how various DNS servers see your recent DNS change.

## Revert (if needed)

If something went horribly wrong, **DON'T PANIC**. 😱

{{< alert >}}
**DNS is like IT quicksand.**
Once you get stuck in a problem with DNS, any level of fighting just makes you more stuck.
Take a deep breath first. 🫁
{{< /alert >}}

Go back to your DNS provide and remove the ALIAS/CNAME record for your CDN domain name, such as `example.com`.
Add back in the original A/AAAA/ALIAS/CNAME records that were there previously.
Be patient for traffic to shift back to your origin server.

Review the changes you made and look for any errors.

# Configuring Ghost

Ghost is fairly easy to put behind a CDN, but it does have some additional caching configuration that you can change if needed.
It provides hints to the CDN about what should and should not be cached and for how long.
Refer to the [Ghost docs](https://ghost.org/docs/config/#caching) for details.

I decided to cache requests to the Content API and to the frontend for 60 seconds as a test.
My `docker-compose.yml` now looks like this:

```yaml
  ghost:
    image: docker.io/library/ghost:5
    container_name: ghost
    restart: always
    depends_on:
      - ghostdb
    environment:
      url: https://thetanerd.com
      caching__contentAPI__maxAge: 60
      caching__frontend__maxAge: 60
      database__client: mysql
      database__connection__host: ghostdb
      database__connection__user: ghost
      database__connection__password: ...
      database__connection__database: ghostdb
    volumes:
      - ghost:/var/lib/ghost/content
```

Now if I access the main page of the site, I see cache hits in the headers:

```plain
HTTP/2 200 
content-type: text/html; charset=utf-8
cache-control: public, max-age=600
date: Mon, 03 Jul 2023 19:54:39 GMT
etag: W/"19e7b-5MKnFrme/sGk5DT2yvMkbgDsl+4"
server: Caddy
x-powered-by: Express
vary: Accept-Encoding
x-cache: Hit from cloudfront
via: 1.1 308bae6dc9384ec8e0a82ba2d96014bc.cloudfront.net (CloudFront)
x-amz-cf-pop: DFW57-P2
x-amz-cf-id: 0Dvoc_ST8-FK_TD4lEMQg6-uiDqhaUbYAqbylkiUP61eGcQsZSFEGg==
age: 7
```

The `x-cache` header shows a hit and the `age` header says it's been cached for 7 seconds.

Enjoy your new CDN-accelerated Ghost blog! 🐇