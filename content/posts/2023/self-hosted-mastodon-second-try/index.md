---
author: Major Hayden
date: '2023-01-02'
summary: >
  Although my first attempt at self-hosting Mastodon was a failure, I went
  back for a second attempt with docker-compose. 🧗‍♂️
tags:
  - containers
  - mastodon
  - selfhosted
title: Second try at self-hosting Mastodon
coverAlt: Coffee spilled on the floor
coverCaption: |
  Photo by <a href="https://unsplash.com/@jankolar?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Jan Antonin Kolar</a> on <a href="https://unsplash.com/photos/QQNQjrKEl6w?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
---

[Mastodon](https://joinmastodon.org/) caught my attention at the end of 2022 in the wake of all the Twitter shenanigans.
At a high level, Mastodon is an implementation of [ActivityPub](https://en.wikipedia.org/wiki/ActivityPub) and you can use it for "micro-blogging" much like you would use Twitter.
_(This is a really quick, high-level explanation and I skipped over plenty of detail.)_ 😉

This post covers my journey on Mastodon that led me to self-host my own Mastodon instance in a fairly reliable way.

# Early start

My early Mastodon adventure started out much like the story of [Goldilocks](https://en.wikipedia.org/wiki/Goldilocks_and_the_Three_Bears):

* I started out on [mastodon.social](https://mastodon.social/explore), but it was _too big_.
  There were so many people on the server that the federated timeline was flying by.
  Rules seemed to be enforced well, but it was a bit like Twitter all over again.
* I deployed my own, but it was _too small_ (the federated timeline was empty).
  Finding new people to talk to or following new topics was difficult.
* Finally, I discovered [Fosstodon](https://fosstodon.org/) after several friends in the open source community joined.
  It felt _just right_.

The admins of the Fosstodon instance are fantastic.
Sure, there was downtime as the usage levels increased, but the admin team was quick to communicate the issues at hand along with future plans.
My interactions with the community were almost all positive and it was fun to reconnect with some open source contributors that I had not spoken to in ages.

As time went on, I read various toots[^still_toots] about Mastodon servers changing owners, suddenly going offline, or altering rules abruptly.
Someone talked about taking control of your online identity and that Mastodon should be included in that.

This aligned with my existing approach to hosting blogs on my own domains.
Also, after the Twitter fiasco, I'd like people to find me via the systems where I have full control, such as my blog.

# Self-hosted adventure

So far, there are three main deployment methods for Mastodon that I've found:

* The [official guide](https://docs.joinmastodon.org/user/run-your-own/) uses a custom Ruby, lots of steps, and systemd
* Using [docker-compose](https://github.com/mastodon/mastodon/blob/main/docker-compose.yml)
* Deploying in kubernetes using [Mastodon's charts](https://github.com/mastodon/chart) or the [ones from Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/mastodon)

## Official guide

Although the official guide looks fairly straightforward, it has a lot of steps.
I struggled to get the right Ruby version compiled on Fedora 37 and I found spots where I needed to tweak the guide to make things work.
Also, I wasn't sure if I could get the steps done the same way again if I needed to migrate the instance or recover from a failure.

## docker-compose

Next up was docker-compose.
I use docker-compose [quite often](https://major.io/tags/docker/) and I know my way around many of the rough edges.
However, I couldn't get the upstream compose file to work properly.
Sometimes the database migrations would not run.
Sometimes certain pieces of the Mastodon infrastructure couldn't find each other.
As soon as I tried to set passwords for postgres and redis, I couldn't get Mastodon's rails app to work again.

In addition, the docker-compose file from upstream builds containers on your local machine rather than pulling the official containers that were built and tested upstream.
That's a quick fix in the compose file, but I still had issues during the deployment.

## kubernetes

Finally, I looked at kubernetes.
Surely you can just add kubernetes to something and make it better, right? 😆

The Bitnami charts made it much further along than the charts from upstream, but I still had errors flowing about database migrations cut off during their run and occasionally unreachable postgres servers.

There must be a better way.

# Deployment

For this Mastodon deployment to work well, I needed a few things:

* The deployment should be _mostly_ hands off. Said another way, moving it to another server or re-deploying should be a `docker-compose up -d` plus one or two commands **maximum**.
* It should be relatively easy to back up and restore.
* The big file of secret environment variables should be generated ahead of time and not at deploy time.

After plenty of trial and error, I came up with this plan:

1. Start with an empty secrets environment file. Deploy all of the containers and run the `rake db:setup` to generate the environment file.
2. Copy the environment file to `.env.production` so that it can be used along with upstream's docker-compose file.
3. Delete the entire deployment. Remove all existing volumes and containers.
4. Add [Caddy](https://caddyserver.com/) to the deployment to handle TLS and serving cached content.
5. Deploy again with `docker-compose up -d` and run `rake db:setup` to prepare the database with the environment file.

Without further ado, let's get to the guide!

## Generate the environment file

Here's my initial docker-compose file:

```yaml
version: '3'
services:
  postgres:
    restart: always
    container_name: postgres
    image: docker.io/library/postgres:14
    networks:
      - internal_network
    healthcheck:
      test: ['CMD', 'pg_isready', '-U', 'postgres']
    volumes:
      - postgres:/var/lib/postgresql/data
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
      - POSTGRES_PASSWORD=my-super-secret-postgres-password
      - POSTGRES_USER=postgres

  redis:
    restart: always
    container_name: redis
    image: redis:7
    networks:
      - internal_network
    healthcheck:
      test: ['CMD', 'redis-cli', 'ping']
    volumes:
      - redis:/data

  web:
    image: tootsuite/mastodon
    container_name: web
    restart: always
    env_file: .env.production
    command: bash -c "rm -f /mastodon/tmp/pids/server.pid; bundle exec rails s -p 3000"
    networks:
      - external_network
      - internal_network
    healthcheck:
      test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:3000/health || exit 1']
    ports:
      - '127.0.0.1:3000:3000'
    depends_on:
      - postgres
      - redis
      # - es
    volumes:
      - mastodon-public:/mastodon/public/system

  streaming:
    image: tootsuite/mastodon
    container_name: streaming
    restart: always
    env_file: .env.production
    command: node ./streaming
    networks:
      - external_network
      - internal_network
    healthcheck:
      test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:4000/api/v1/streaming/health || exit 1']
    ports:
      - '127.0.0.1:4000:4000'
    depends_on:
      - postgres
      - redis

  sidekiq:
    image: tootsuite/mastodon
    container_name: sidekiq
    restart: always
    env_file: .env.production
    command: bundle exec sidekiq -c 1
    depends_on:
      - postgres
      - redis
    networks:
      - external_network
      - internal_network
    volumes:
      - mastodon-public:/mastodon/public/system
    healthcheck:
      test: ['CMD-SHELL', "ps aux | grep '[s]idekiq\ 6' || false"]

networks:
  external_network:
  internal_network:
    internal: true

volumes:
  mastodon-public: {}
  postgres: {}
  redis: {}
```

I've made a few alterations to the upstream compose file:

* I'm using the upstream containers from docker hub rather than building them on startup
* My containers use docker volumes instead of mounting local directories
* The sidekiq container only uses one worker (keeping resource usage low)

At this point, I can run `docker-compose up -d` and all of the containers are running.
Now we can use Mastodon's interactive configuration tool to generate our environments file:

```console
docker-compose run --rm web bundle exec rake db:setup
```

Go through the interactive configuration and answer all of the questions there.

For SMTP, I used [Mailgun](https://www.mailgun.com/) since it's very inexpensive for my Mastodon use case.
Once you set up your account there, look for the SMTP credentials under your domain in Mailgun's control panel.
The Mastodon setup process will ask for those credentials.

Also, I keep all of my assets in [Backblaze B2](https://www.backblaze.com/b2/cloud-storage.html) to avoid clogging up all of the storage on my VM that runs Mastodon.
Create a public bucket in Backblaze and create some access keys.
When Mastodon asks for your S3 endpoint, use `https://s3.us-west-001.backblazeb2.com`.
If it asks for a hostname, you can use `s3.us-west-001.backblazeb2.com`.

Once the setup completes, take the environments file that prints to the screen and store that as `.env.production`.

## Delete the deployment (for real)

This is going to sound weird, but we need to throw everything away at this point.
I like this step because it allows me to start fresh with a fully generated environments file.
It's a good simulation of how things might look in a brand new deployment or during a migration from one server to another.

{{< alert >}}
💣 **WARNING!**
   This assumes that Mastodon's containers are the only ones running on your system.
   If you are running other containers for other services, **don't run these commands**.
   You must go through each container, remove it, and remove the associated volume carefully.
{{< /alert >}}


```shell
# Stop all of the current containers and delete them (see warning above!)
$ docker-compose rm -sfv

# Destroy all of the container volumes (see warning above!)
$ docker system prune --volumes
```

# Add Caddy

For most container deployments, I'd use [traefik](https://traefik.io/) here.
Its configuration discovery abilities, especially when paired with docker-compose, are top-notch.
There's almost no little one-off configuration issues when you use traefik.

However, Mastodon has tons of static assets, such as images, stylesheets, and other media.
Serving those through Mastodon's rails web server is possible, but it's horribly inefficient.
It chews up much more CPU time and it's slower to respond.

That's where Caddy comes in.
Caddy has automatic TLS capabilities with LetsEncrypt and it can also serve static content.
This takes the load off of Mastodon's rails web server.

Start by adding a new service to your compose file:

```yaml
  caddy:
    image: caddy:2-alpine
    restart: unless-stopped
    container_name: caddy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./caddy/etc-caddy:/etc/caddy:Z
      - ./caddy/logs:/logs:Z
      - mastodon-public:/srv/mastodon/public:ro
    hostname: "tootchute.com"
    networks:
      - internal_network
      - external_network
```

Change the `hostname` to fit your server.
The `mastodon-public` volume is the one that Mastodon uses for its public content and mounting it inside the Caddy container allows Caddy to serve those assets.

In my case, I created a `caddy` directory in my home directory to hold the configuration and log files:

```console
$ mkdir caddy/{etc-caddy,logs}
```

🤓 **NERD ALERT.**
The `:Z` on the volumes for configuration and logs ensures that these directories have the right SELinux contexts so that the container can access the files in these directories.
If your system does not use SELinux, you can omit the `:Z`.

I wrote a caddy configuration in `./caddy/etc-caddy/Caddyfile` that is a slight tweak of [Robert Riemann's version](https://blog.riemann.cc/digitalisation/2022/02/09/mastodon-setup-with-docker-and-caddy/):

```text
{
        # Global options block. Entirely optional, https is on by default
        # Optional email key for lets encrypt
        email major@mhtx.net
        # Optional staging lets encrypt for testing. Comment out for production.
        # acme_ca https://acme-staging-v02.api.letsencrypt.org/directory

        # admin off
}

tootchute.com {
        log {
                # format single_field common_log
                output file /logs/access.log
        }

        root * /srv/mastodon/public

        encode gzip

        @static file

        handle @static {
                file_server
        }

        handle /api/v1/streaming* {
                reverse_proxy streaming:4000
        }

        handle {
                reverse_proxy web:3000
        }

        #header {
        #        Strict-Transport-Security "max-age=31536000;"
        #}

        header /sw.js  Cache-Control "public, max-age=0";
        header /emoji* Cache-Control "public, max-age=31536000, immutable"
        header /packs* Cache-Control "public, max-age=31536000, immutable"
        header /system/accounts/avatars* Cache-Control "public, max-age=31536000, immutable"
        header /system/media_attachments/files* Cache-Control "public, max-age=31536000, immutable"

        handle_errors {
                @5xx expression `{http.error.status_code} >= 500 && {http.error.status_code} < 600`
                rewrite @5xx /500.html
                file_server
        }
}
```

Be sure to change `tootchute.com` to your Mastodon server's domain as well as `email` to your email.
In addition, you may want to uncomment the `acme_ca` option shown there to avoid hitting LetsEncrypt's production API limits while you are testing your deployment.
*(Comment out the staging server later to ensure you get a valid, trusted certificate.)*

Let's bring up our new Caddy container!

```console
$ docker-compose up -d
```

## Initialize Mastodon

At this point, we have Caddy serving content and all of our Mastodon containers are running.
However, the Mastodon database isn't populated at all.
Let's do that now:

```console
docker-compose run --rm web bundle exec rake db:setup
```

This step uses your environments file to run all of Mastodon's database migrations and perform some initial setup steps.
It might take about 30 seconds to run.

Create our first user once the setup process finishes:

```console
$ docker-compose run --rm web bin/tootctl accounts create USERNAME --email YOUR_EMAIL --confirmed --role Owner
```

This command creates a new administrative user, sets the email address for that user, and confirms the account.
The confirmation part allows you to skip the email confirmation process for that first account.
Your initial password prints out as soon as the command finishes.

You should be able to access your Mastodon deployment on the domain you chose (mine is [tootchute.com](https://tootchute.com) and log in as the user you just created.
If something doesn't look right, examine the container logs to see if it's something obvious:

```console
$ docker-compose logs -f --since 5m
```

If a container is in a restart loop, you should catch it fairly quickly in the logs.

# Next steps

First, turn off new registrations if you plan to run a single user instance like I do.
Click the preferences gear/cog on the main page, click **Administration**, **Server Settings*, and **Registrations**.

Next, enable two-factor authentication for your account.
Click the preferences gear/cog on the main page, click **Account**, and then **Two-factor Auth**.

Finally, back up your environments file (`.env.production`) and your `docker-compose.yaml`.
This will make it much easier to recover from a failure or migrate to a new server.

If you're using remote assets in S3 or Backblaze, you don't need to back up that content.
Focus on backing up postgres and redis on a regular basis:

```console
# Dump postgres data
$ docker-compose exec postgres pg_dump -d mastodon -U postgres --no-owner > backups/pgdump-$(date +%F_%H-%M-%S).sql

# Copy redis data
$ docker-compose cp redis:/data/dump.rdb backups/
```

[Let me know](https://tootchute.com/@major) if you run into problems with the steps described in this post.
I assembled them from my shell history and some notes I took along the way.
There's always a chance I missed something.


[^still_toots]: Posts on Mastodon were called "toots" for ages since that's the supposed sound that an elephant trunk makes. 
  Many people want to switch that to "posts" and the latest version of Mastodon changed the "toot" button to "publish."
  I'll call them toots forever.
  Heck, I'm the owner of [tootchute.com](https://tootchute.com). 😉
