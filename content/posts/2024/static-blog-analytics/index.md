---
author: Major Hayden
date: '2024-04-04'
summary: |
  Static blogs are easy to serve, but so many of the free options have no analytics whatsoever.
  This post talks about how to serve your own blog from a container with live updating analytics
tags: 
  - amd
  - fedora
  - laptop
  - linux
  - sway
  - thinkpad
title: Roll your own static blog analytics
coverAlt: A small brown deer-like animal hiding in vegetation
coverCaption: |
  [visualsofdana](https://unsplash.com/photos/a-small-deer-is-standing-in-the-grass-exEfgnSaX6A)
  via Unsplash
---

Static blogs come with tons of advantages.
They're cheap to serve.
You store all your changes in git.
People with spotty internet connections can clone your blog and run it locally.

**However, one of the challenges that I've run into over the years is around analytics.**

I could quickly add Google Analytics to the site and call it a day, but is that a good idea?
Many browsers have ad blocking these days and the analytics wouldn't even run.
For those that don't have an ad blocker, do I want to send more data about them to Google? 🙃

How about running my own self-hosted analytics platform?
That's pretty easy with containers, but most ad blockers know about those, too.

This post talks about how to host a static blog in a container behind a [Caddy](https://caddyserver.com/) web server.
We will use [goaccess](https://goaccess.io/) to analyze the log files on the server itself to avoid dragging in an analytics platform.

## Why do you need analytics?

Yes, yes, I know this comes from the guy who wrote a post about [writing for yourself](/p/how-i-write-blog-posts/), but sometimes I like to know which posts are popular with other people.
I also like to know if something's misconfigured and visitors are seeing 404 errors for pages which should be working.

It can also be handy to know when someone else is [writing about you](/p/puppy-linux-icanhazip-and-tin-foil-hats/), especially when those things are incorrect. 😉

So my goals here are these:

* Get some basic data on what's resonating with people and what isn't
* Find configuration errors that are leading visitors to error pages
* Learn more about who is linking to the site
* Do all this without impacting user privacy through heavy javascript trackers

## What are the ingredients?

There are three main pieces:

1. Caddy, a small web server that runs really well in containers
2. This blog, which is written with [Hugo](https://gohugo.io/) and [stored in GitHub](https://github.com/major/major.io)
3. Goaccess, a log analyzer with a capability to do live updates via websockets

Caddy will write logs to a location that goaccess can read.
In turn, goaccess will write log analysis to an HTML file that caddy can serve.
The HTML file served by caddy will open a websocket to goaccess for live analytics.

## A static blog in a container?

We can pack a static blog into a very thin container with an extremely lightweight web server.
After all, caddy can handle automatic TLS certificate installation, logging, and caching.
That just means we need the most basic webserver in the container itself.

I was considering a second caddy container with the blog content in it until I stumbled upon a great post by Florin Lipan about [The smallest Docker image to serve static websites](https://lipanski.com/posts/smallest-docker-image-static-website).
He went down a rabbit hole to make the smallest possible web server container with busybox.

His first stop led to a 1.25MB container, and that's tiny enough for me.[^keptgoing] 🤏

[^keptgoing]: Florin went all the way down to 154KB and I was extremely impressed.
  However, I'm not too worried about an extra megabyte here. 😉

I built a [container workflow](https://github.com/major/major.io/blob/main/.github/workflows/container.yml) in GitHub Actions that builds a container, puts the blog in it, and [stores that container as a package](https://github.com/major/major.io/pkgs/container/major.io) in the GitHub repository. It all starts with a brief Dockerfile:

```Dockerfile
FROM docker.io/library/busybox:1.36.1
RUN adduser -D static
USER static
WORKDIR /home/static
COPY ./public/ /home/static
CMD ["busybox", "httpd", "-f", "-p", "3000"]
```

We start with busybox, add a user, put the website content into the user's home directory, and start busybox's `httpd` server.
The container starts up and serves the static content on port 3000.

## Caddy logs

Caddy writes its logs in a JSON format and goaccess already knows how to parse caddy logs.
Our first step is to get caddy writing some logs.
In my case, I have a directory called `caddy/logs/` in my home directory where those logs are written.

I'll mount the log storage into the caddy container and mount one extra directory to hold the HTML file that goaccess will write.
Here's my `docker-compose.yaml` excerpt:

```yaml
  caddy:
    image: ghcr.io/major/caddy:main
    container_name: caddy
    ports:
      - "80:80/tcp"
      - "443:443/tcp"
      - "443:443/udp"
    restart: unless-stopped
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile:Z
      - caddy_data:/data
      - caddy_config:/config
      # Caddy writes logs here 👇
      - ./caddy/logs:/logs:z
      # This is for goaccess to write its HTML file 👇
      - ./storage/goaccess_major_io:/var/www/goaccess_major_io:z
```

Now we need to update the `Caddyfile` to tell caddy where to place the logs and add a `reverse_proxy` configuration for our new container that serves the blog:

```Caddyfile
major.io {
    # We will set up this container in a moment 👇
    reverse_proxy major_io:3000 {
        lb_try_duration 30s
    }

    # Tell Caddy to write logs to `/logs` which
    # is `storage/logs` on the host:
    log {
        output file /logs/major.io-access.log {
            roll_size 1024mb
            roll_keep 20
            roll_keep_for 720h
        }
    }
}
```

Great!
We now have the configuration in place for caddy to write the logs and the caddy container can mount the log and analytics storage.

## Enabling analytics

We're heading back to the `docker-compose.yml` file once more, this time to set up a goaccess container:

```yaml
  goaccess_major_io:
    image: docker.io/allinurl/goaccess:latest
    container_name: goaccess_major_io
    restart: always
    volumes:
      # Mount caddy's log files 👇
      - "./caddy/logs:/var/log/caddy:z"
      # Mount the directory where goaccess writes the analytics HTML 👇
      - "./storage/goaccess_major_io:/var/www/goaccess:rw"
    command: "/var/log/caddy/major.io-access.log --log-format=CADDY -o /var/www/goaccess/index.html --real-time-html --ws-url=wss://stats.major.io:443/ws --port=7890 --anonymize-ip --ignore-crawlers --real-os"
```

This gets us a goaccess container to parse the logs from caddy.
We need to update the caddy configuration so that we can reach the goaccess websocket for live updates:

```Caddyfile
stats.major.io {
    root * /var/www/goaccess_major_io
    file_server
    reverse_proxy /ws goaccess_major_io:7890
}
```

At this point, we have caddy writing logs in the right place, goaccess can read them, and the analytics output is written to a place where caddy can serve it.
We've also exposed the websocket from goaccess for live updates.

## Serving the blog

We've reached the most important part!

We added the caddy configuration to reach the blog container earlier, but now it's time to deploy the container itself.
As a reminder, this is the container with busybox and the blog content that comes from GitHub Actions.

The `docker-compose.yml` configuration here is _very basic_:

```yaml
  major_io:
    image: ghcr.io/major/major.io:main
    container_name: major_io
    restart: always
```

Caddy will connect to this container on port 3000 to serve the blog.
(We set port 3000 in the original `Dockerfile`).

At this point, everything should be set to go.
Make it live with:

```console
docker-compose up -d
```

This should bring up the goaccess and blog containers while also restarting caddy.
The website should be visible now at [major.io](https://major.io/) (and that's how you're reading this today).

## What about new posts?

I'm glad you asked!
That was something I wondered about as well.
**How do we get the new blog content down to the container when a new post is written?** 🤔

As I've [written in the past](/p/watchtower/), I like using [watchtower](https://containrrr.dev/watchtower/) to keep containers updated.
Watchtower offers an HTTP API interface for webhooks to initiate container updates.
We can trigger that update via a simple curl request from GitHub Actions when our container pipeline runs.

My [container workflow](https://github.com/major/major.io/blob/main/.github/workflows/container.yml) has a brief bit at the end that does this:

```yaml
  - name: Update the blog container
    if: github.event_name != 'pull_request'
    run: |
        curl -s -H "Authorization: Bearer ${WATCHTOWER_TOKEN}" \
            https://watchtower.thetanerd.com/v1/update
    env:
        WATCHTOWER_TOKEN: ${{ secrets.WATCHTOWER_TOKEN }}
```

You can enable this in watchtower with a few new environment variables in your `docker-compose.yml`:

```YAML
  watchtower:
    # New environment variables 👇
    environment:
      - WATCHTOWER_HTTP_API_UPDATE=true
      - WATCHTOWER_HTTP_API_TOKEN=SUPER-SECRET-TOKEN-PASSWORD
      - WATCHTOWER_HTTP_API_PERIODIC_POLLS=true
```

`WATCHTOWER_HTTP_API_UPDATE` enables the updating via API and `WATCHTOWER_HTTP_API_TOKEN` sets the token required when making the API request.
If you set `WATCHTOWER_HTTP_API_PERIODIC_POLLS` to `true`, watchtower will still periodically look for updates to containers even if an API request never appeared. By default, watchtower will stop doing periodic updates if you enable the API.

This is working on my site right now and you can view my public blog stats on [stats.major.io](https://stats.major.io). 🎉