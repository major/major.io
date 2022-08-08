---
author: Major Hayden
date: '2022-03-24'
summary: >-
  Host your own personal URL shortener with GitHub Actions and Cloudflare Workers.
  No web or database servers required! 🥰
tags:
  - cloudflare
  - github
  - javascript
  - serverless
title: Build a URL shortener with Cloudflare Workers
---

{{< figure
    src="cover.jpg"
    alt="Street sign showing different destinations in Germany"
    caption="Photo credit: [Robin Glauser](https://unsplash.com/photos/DFqxXsj56Sk)"
    >}}


Shortened URLs make it easier to quickly reference complicated URLs and share them with
other people. For example, https://url.major.io/reviews is definitely an easier method
for sharing my [Fedora package review] list with other people instead of the full Bugzilla
URL:

```
https://bugzilla.redhat.com/buglist.cgi?bug_status=__open__&component=Package%20Review&email1=mhayden%40redhat.com&emailreporter1=1&emailtype1=substring&list_id=12512813&product=Fedora&query_format=advanced
```

It also avoids those situations where you share a URL only to find that a chat system
gobbled up special characters and your URL arrives broken on the other end.

However, most URL shorteners depend on a web server and possibly a database server to
serve up shortened URLs. This is a really quick setup that nearly any system
administrator has done a hundred times or more, but what about the ongoing maintenance
and updates? What about redundancy? How much will it cost?

That's simply too much work. I went on the hunt for an alternative.

[Fedora package review]: https://docs.fedoraproject.org/en-US/package-maintainers/Package_Review_Process/

## Shortening only with GitHub

My first stop was nelsontky's [gh-pages-url-shortener]. It uses GitHub issues to manage
URLs, but the author mentions that the solution is a bit hacky. I need something more
reliable.

[gh-pages-url-shortener]: https://github.com/nelsontky/gh-pages-url-shortener

## Shortening with Cloudflare Pages' redirects

Cloudflare offers [redirects] via a simple text file on its [Pages] service. _(This blog
is hosted via Cloudflare pages and it's been extremely reliable and fast.)_

The only downside is the limits applied to the redirects:

> A project is limited to 100 total redirects. Each redirect declaration has a
> 1000-character limit. Malformed definitions are ignored. If there are multiple
> redirects for the same source path, the topmost redirect is applied.

If you think you'll need less than 100 redirects and your destination URLs are under
1,000 characters, this might work for you. Head on over to [Deploying your site] and get
going!

What if you want (nearly) limitless redirects?

[Redirects]: https://developers.cloudflare.com/pages/platform/redirects/
[Pages]: https://developers.cloudflare.com/pages/
[Deploying your site]: https://developers.cloudflare.com/pages/framework-guides/deploy-anything/

## Nearly limitless redirects with Cloudflare Workers

More Googling led to a blog post titled [World's Simplest URL Shortener using Cloudflare
Workers]. In the post, [Patrick Reader] lays out a simple javascript handler that takes
the URI provided, compares it to a list of JSON keys, and then returns the destination
URL.

His instructions in the post get you up and running quickly. He also offers up a link to
his own [GitHub repo] so you can fork it and get done quickly. The `urls.json` file
expects the keys to be short URIs and the values to be the long URLs, like this:

```json
{
  "": "https://example.com/myblog",
  "recipes": "https://example.com/long/url/to/my/favorite/recipe",
  "twitter": "https://twitter.com/myusername"
}
```

I decided to build out [my repository] with [wrangler]'s `generate` command and then
brought over Patrick's script. Your `wrangler.toml` will need a few adjustments to get
going:

1. Set `type` to `webpack`.
2. `account_id`: Find your account ID by going to the [Cloudflare
   dashboard] and clicking on **Workers** on the left side.
   (Look for **Account ID** on the right side.)
3. Set `workers_dev` to `false` if you want to use your own domain.
4. Set `route` to the URL matcher you want to apply to the Worker. I use `url.major.io`
   as my domain for my URL shortener, so my `route` is `url.major.io/*`.
5. Your `zone_id` is also in the [Cloudflare dashboard]. Click **Websites** on the left
   side, click your domain name, and look for **Zone ID** on the right side.

Manual work is not my thing, so I wanted to get GitHub Actions to do the work for me
when I changed my list of short URLs. For that, I first needed an API key from
Cloudflare. For that, go to your [API Tokens] page at Cloudflare and do these steps:

* Click **Create Token**.
* Click **Use template** to the right of **Edit Cloudflare Workers**.
* Under **Zone Resources**, choose the domain name where you want to use the URL
  shortener.
* Select your account under **Account Resources**.
* Click **Continue to summary** and copy your API key.
* Run over to your repo in GitHub, click **Settings**, **Secrets**, then **Actions**.
* Click **New repository secret**.
* Use `CF_API_TOKEN` as the **Name** and fill in your API key as the **Value**.
* Click **Add secret**.

All that's left is to drop in a GitHub Actions workflow to make it all automated. You
can copy the [workflow file] from [my repository]:

```yaml
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    name: Deploy
    steps:
      - uses: actions/checkout@v3
      - name: Publish
        uses: cloudflare/wrangler-action@1.3.0
        with:
          apiToken: ${{ secrets.CF_API_TOKEN }}
```

Each time you change a URL in `urls.json`, GitHub Actions assembles your application for
Cloudflare Workers and ships it to Cloudflare. You can edit your URLs right in the
GitHub web editor, save them, and they'll be active in a minute or two!

Enjoy! 🎉

[World's Simplest URL Shortener using Cloudflare Workers]: https://www.pxeger.com/2020-08-06-world%27s-simplest-url-shortener-using-cloudflare-workers/
[Patrick Reader]: https://www.pxeger.com/
[GitHub repo]: https://github.com/pxeger/url-shortener
[my repository]: https://github.com/major/cloudshort
[wrangler]: https://github.com/cloudflare/wrangler
[Cloudflare dashboard]: https://dash.cloudflare.com
[API Tokens]: https://dash.cloudflare.com/profile/api-tokens
[workflow file]: https://github.com/major/cloudshort/blob/main/.github/workflows/deploy.yml
