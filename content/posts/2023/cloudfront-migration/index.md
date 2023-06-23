---
author: Major Hayden
date: '2023-02-17'
summary: |
  New experiences bring joy! After working with fun AWS CloudFront hacks at work this week,
  I decided to migrate this blog to AWS S3 and CloudFront. ⛅
tags:
  - aws
  - blog
  - cloud
  - hugo
  - iam
  - s3
  - security
title: Migrating to AWS CloudFront
coverAlt: View of a beach by the ocean from the air
coverCaption: |
  [Simon Barber](https://unsplash.com/photos/JJspmVquopU)_
---

This blog moved from Wordpress to Hugo back in 2020 and that was a great decision.
Static blog generators free you from the vast majority of blog hosting security risks (but some still exist) and they give you the freedom to host your blog almost anywhere.

I've tried a few hosting methods for the blog so far:

1. On a VPS or on cloud instances
2. With a third party static hosting specialist, such as Netlify
3. In GitHub or GitLab Pages
4. Using CloudFlare Pages
5. Object storage with a CDN (Backblaze/CloudFlare)

All of them have their advantages and disadvantages.

For example, running on a VPS with a web server like nginx gives you a ton of control over every aspect of the site, but then there's a server to manage.
GitHub pages provides a fast and free option for hosting a static blog from a git repository, but you give up lots of control and access to metrics.

I've been a bit leery of free offerings in the past because they can easily be taken away or they may suddenly begin charging for the service.
Often times the free services turn *me* into the product.

After hacking with [AWS CloudFront](https://aws.amazon.com/cloudfront/) this week at work, I set off on an expedition to see if I could host this blog with it.[^spoiler]

# Architecture

As with most cloud-related deployments, we stitch together a few different cloud services to make the magic happen.
Here's the goal at a high level:

1. GitHub Actions should build the blog content using Hugo and ship that content to a bucket in AWS S3.
2. AWS CloudFront serves the content from the S3 bucket to visitors around the world.
3. Logs from website visitors are placed in a different S3 bucket.

How much does all of this cost?
The first step for any AWS deployment involves a quick look at the [AWS Free Tier](https://aws.amazon.com/free/) list:

* IAM roles and policies are already free. 🎉
* AWS S3 gives you 5GB free for the first 12 months and then it's $0.023/GB/month after that.[^s3extras]
* AWS CloudFront allows 1TB of data transfer and 10M requests per month.
* We're building our static content in GitHub Actions and that's free already.

My blog uses about 218MB of storage and transfers less than 1TB per month.
My bill should easily come in under $1.

Let's get started.

# Configure the storage

Our first stop on the blog hosting train is [AWS S3](https://s3.console.aws.amazon.com/s3/buckets).
The S3 bucket holds the static files that make up the site. 🪣

We need two buckets:

1. One bucket for our static blog content
2. Another bucket for our CloudFront access logs

Let's start with the bucket for our **static blog content**:

1. [Create a bucket](https://s3.console.aws.amazon.com/s3/bucket/create) to hold your website content and choose your preferred region.
2. Scroll down to the **Block Public Access settings for this bucket** section and uncheck the **Block all public access** box.
3. Acknowledge that you want this content to be public by checking the box.
4. Add any tags (optional) and click **Create bucket**.
5. Go back to the [bucket listing](https://s3.console.aws.amazon.com/s3/buckets) and click the bucket you just made.
6. Click the **Properties** tab and scroll to the bottom.
7. Find the **Static website hosting** section and click **Edit** on the right.
8. Click **Save changes**. _(The defaults fit almost everybody.)_

Let's go back and make the logs bucket:

1. [Create a second bucket](https://s3.console.aws.amazon.com/s3/bucket/create) to hold the CloudFront logs.
2. Use the defaults this time and click **Create bucket**.

Our storage is ready to go!

# Getting certificates

AWS provides a domain validated certificates for free via AWS Certificate Manager (ACM).
Once you make a certificate request, ACM provides you with a DNS record that must appear when ACM queries your domain name.

Let's request a certificate:

1. Go to the [Request certificate](https://us-east-1.console.aws.amazon.com/acm/home#/certificates/request) page.
2. Ensure **Request a public certificate** is active and click **Next**.
3. Provide the fully qualified domain name for your blog.
   That's `major.io` for this blog.
   Do not include any `http://` or `https://` there.
5. Click **Request certificate**.

Now you should see your requested certificate in the list along with the **Pending validation** status.
Click the certificate ID and take a look at the **Domains** section on the next page.
You should see a **CNAME name** and **CNAME value** on the far right.

Go to your DNS provider and create a DNS record that matches.
ACM will query your domain using the **CNAME name** and it expects to see the **CNAME value** returned.
Once the DNS record is in place, wait a minute or two for ACM to check the DNS record and flip the status to a green **Issued** status.

Go on to the next step once you see that green status on the certificate.

# Provision the CDN

This is where we begin connecting some dots.
CloudFront will serve content from the S3 bucket via a worldwide CDN and it uses the certificate we created in the last step.

Start by clicking **Create Distrbution** at the top right of the main [CloudFront page](https://us-east-1.console.aws.amazon.com/cloudfront/v3/home#/distributions):

1. For **Origin domain**, choose the S3 bucket you created for your **static blog content**.
2. CloudFront will immediately suggest using the website endpoint instead, so click **Use website endpoint**.
3. Choose a memorable name in case you host multiple sites on CloudFront.
4. Scroll down to **Viewer** and change **Viewer Protocol Policy** to **Redirect HTTP to HTTPS**.
5. Scroll down to **Alternate domain name (CNAME)** and use the same domain name that you used for your certificate.
6. Just below that line, choose your certificate from the list under **Custom SSL certificate**.
7. Enable HTTP/3 if you want to be fancy. 😉
8. For **Default root object**, type `index.html` so that it will be served when a user requests a bare directory, like `https://example.com/tags/`.
9. Enable **Standard logging** and choose your **logs bucket** (not the blog static content bucket).
10. The page might ask you enable ACLs on your bucket so CloudFront can drop off logs. Click to accept that option.
11. Click **Create distribution**.

CloudFront distributions take some time to deploy the first time and after modifications.
Be patient!

At this point, we have a storage bucket ready to hold our content and a TLS-enabled CDN ready to serve the content.
Now we need to build the content and ship it to S3.

# GitHub Actions + OpenID

Most people will generate static authentication credentials, add them as GitHub secrets, and call it a day.
That's not for me.
I prefer to use OpenID authentication and I avoid putting any credentials into GitHub.

How does this process work?

1. GitHub asks AWS if it can assume a specific role that has permissions to do things at AWS.
2. AWS will verify that it's really GitHub making the request and that the request came from a valid source at GitHub.
3. AWS then provides temporary credentials to GitHub to assume the AWS role and make changes in AWS services.

GitHub has some [great documentation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) on this process, but I'll cover it briefly here as well.

We start by making an identity provider at AWS that allows us to trust GitHub as an identity source:

1. Go to the [IAM Identity Providers](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/identity_providers) page and click **Add Provider**.
2. Click **OpenID Connect**.
3. Use `https://token.actions.githubusercontent.com` for the provider URL.
4. Click **Get thumbprint** to hash GitHub's OpenID certificate.
5. Enter `sts.amazonaws.com` in the **Audience** box.
6. Click **Add provider**.

Now we need a policy that tells AWS what our GitHub Actions workflow is allowed to do.
We use the principle of least privileges to limit access as much as possible:

1. Go to the [IAM Policies](https://us-east-1.console.aws.amazon.com/iamv2/home#/policies) page.
2. Click **Create policy**.
3. Click the JSON tab and delete everything in the big text box
4. Paste in my template:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutBucketPolicy",
                "s3:ListBucket",
                "cloudfront:CreateInvalidation",
                "s3:GetBucketPolicy"
            ],
            "Resource": [
                "arn:aws:cloudfront::AWS_ACCOUNT_ID:distribution/CLOUDFRONT_DISTRIBUTION",
                "arn:aws:s3:::STATIC_CONTENT_BUCKET/*",
                "arn:aws:s3:::STATIC_CONTENT_BUCKET"
            ]
        }
    ]
}
```

Replace a few things in this template:

* `STATIC_CONTENT_BUCKET` is the name of your static content S3 bucket that you created first.
* `AWS_ACCOUNT_ID` is your numeric account ID for your AWS account _(click your name at the top right of the AWS console to get the ID)_
* Go back to your CloudFront distribution and use the ID for `CLOUDFRONT_DISTRIBUTION` _(should be all capital letters and numbers)_

Click **Next**, give the policy a friendly name, and finish creating the policy.

Finally, we need a role that glues these two things together.
We tie the role to the identity provider (to allow GitHub to authenticate) and then tie the policy to the role (to allow GitHub Actions to do things in AWS).

1. On the [IAM Roles page](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles), click **Create role**
2. Choose **Web identity** at the top.
3. Find `token.actions.githubusercontent.com` in the **Identity provider** drop down and click it.
4. Choose `sts.amazonaws.com` as the **Audience**.
5. Click **Next**.
6. Find the policy you just created in the previous step and check the box next to it.
7. Give your role a friendly name and click **Create role**.

🚨 **WE ARE NOT DONE YET! You must restrict this role to your repository to prevent other repos from assuming your role.** 🚨

Go back to the role you just created and click the **Trust relationships** tab.
You must add a `StringLike` condition that limits access to only your GitHub repository!
Click **Edit trust policy** and add a `StringLike` condition like my example below:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "ARN_FOR_GITHUB"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:major/major.io:*"
                }
            }
        }
    ]
}
```

The `StringLike` condition shown above will limit access to the role to only my blog repository, `major/major.io`, and deny access to any other repositories.
Be sure to change the username and repository name to match your GitHub user/organization and repository name.
Save the policy when you're finished.

Now we can create a workflow to build our blog and ship it to S3!

# GitHub workflow

My blog [has a workflow](https://github.com/major/major.io/blob/main/.github/workflows/cloudfront.yml) that might work for you as a starting point.
Just in case it disappears, here's an excerpt:

```yaml
name: Deploy to AWS S3/CloudFront

on:
  push:
    branches:
      - "main"
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

concurrency:
  group: "cloudfront"
  cancel-in-progress: true

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Checkout
        uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1.7.0
        with:
          role-to-assume: arn:aws:iam::911986281031:role/github-actions-major.io-blog
          role-duration-seconds: 900
          aws-region: us-east-1

      - name: Build with Hugo
        env:
          HUGO_ENVIRONMENT: production
          HUGO_ENV: production
        run: hugo --minify

      - name: Deploy to S3
        run: hugo deploy --force --maxDeletes -1 --invalidateCDN
```

Reading from top to bottom:

1. We give permissions to write the id token that we get back from AWS and read-only contents to the repo itself.
2. Concurrent runs are not allowed (we don't want two updates shipping at the same time).
3. The hugo setup and repo checkout are standard for nearly any hugo blog.
4. Next we assume the role at AWS using the ARN of our role that we created in IAM.
   _(Go back to your role in IAM and look for **ARN** at the top right to get your ARN.)_
5. Hugo builds the static content as it normally would.
6. Finally, we deploy new content to the S3 bucket, delete anything that doesn't belong, and we invalidate the CDN cache[^cache_invalidate].

Now we need to tell hugo *how to deploy* our blog.
Open up your blog's configuration file (usually `config.toml`) and add some configuration:

```toml
# Deployment configuration for S3/CloudFront
[deployment]

[[deployment.targets]]
name = "BLOG_DOMAIN_NAME"
URL = "s3://STATIC_CONTENT_S3_BUCKET?region=AWS_REGION"
cloudFrontDistributionID =	"CLOUDFRONT_DISTRIBUTION"

[[deployment.matchers]]
pattern = "^.+\\.(js|css|png|jpg|gif|svg|ttf)$"
cacheControl = "max-age=2592000, no-transform, public"
gzip = true

[[deployment.matchers]]
pattern = "^.+\\.(html|xml|json)$"
gzip = true
```

Replace `YOUR_BLOG_DOMAIN_NAME` with your blog's domain name, such as `major.io`.
On the `URL` line, provide your static content S3 bucket (the first one you created) and the region where you created it.
Paste your CloudFront distribution ID to replace `CLOUDFRONT_DISTRIBUTION`.

Commit all of the changes and push them!
Make sure that the GitHub action runs well and can authenticate to AWS properly.

Only one step remains...

# DNS

Sending visitors to your new site in CloudFront is one DNS record away!

Go back to the list of CloudFront distributions in your AWS console and click on the one you created earlier.
Look for the **Distribution domain name** at the top left and you should see a domain that looks like `********.cloudfront.net`.
You will need an `ALIAS` or `CNAME` record that points to this domain name in your DNS records.

I tend to use `ALIAS` records if I am using an apex domain with no subdomain, such as `major.io`.
If your blog is on a subdomain, such as `blog.example.com`, you may want to use a `CNAME` instead.

Either way, point your `ALIAS` or `CNAME` records to the distribution domain name shown on your CloudFront distribution page.
DNS records take a while to propagate through various caches scattered over the globe, so it may take some time before everyone see your updated DNS records.

# Summary

In this *lengthy* post, we did plenty of things:

* 🪣  Configured S3 buckets to hold our static blog content and CDN logs
* 🚀  Deployed a CloudFront distribution to serve our content quickly to visitors around the world
* 🔑  Built IAM roles and policies to avoid placing any sensitive credentials in our GitHub repository
* 🔧  Re-configured hugo to deploy content directly to S3 and flush the CDN cache
* 🚚  Assembled a GitHub workflow to build the static content and ship it to S3

I love learning new things and this is one of many that I've enjoyed.
Hopefully you enjoyed it, too! 💕

[^spoiler]:
    **Spoiler alert!**
    This blog is already on AWS S3 and CloudFront as of today. 😉

[^s3extras]:
    Yes, there are some charges for requests, but these charges are so small, you're likely not to notice.
    Putting a CDN out front greatly reduces those requests even further since origin requests to S3 will only happen for cache misses.
    1M requests to S3 comes out to about $5 per month and that's orders of magnitude more than I can use.

[^cache_invalidate]:
    Invalidating the cache is not required, but it does help with getting new content served by the CDN as soon after a deployment as possible.