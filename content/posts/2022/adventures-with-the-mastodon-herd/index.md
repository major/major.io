---
author: Major Hayden
date: '2022-11-11'
summary: >-
  Ongoing changes at Twitter led me to take a second look at mastodon,
  including running my own mastodon instance. 🐘
cover: cover.jpg
tags:
  - containers
  - docker
  - mastodon
  - postgres
  - redis
  - twitter
title: Adventures with the mastodon herd
---

All of the recent changes at Twitter inspired me to take a second look at [mastodon].
In short, mastodon is a federated social network that feels a bit like someone took Twitter and split it up into a vast network of independent servers.

[Mastodon]: https://en.wikipedia.org/wiki/Mastodon_(software)

# Why mastodon?

It feels a lot like Twitter, but better.

You can search for people, follow them, and publish messages (called _toots_).
They can also follow you and see the messages you publish.

The big difference is that you don't join a central server with mastodon.
There's a massive network of servers to choose from and you can create accounts on one or more of those servers to get started.
You can even run your own!

Mastodon reminds me of email for many reasons:

1. There's no central server. You join a server (from the [massive, growing list]) and
   start publishing messages.
2. Everything is on an eventual consistency model. If a mastodon server goes offline for
   a bit or has network issues, messages and other data will synchronize when it's back
   online.
3. You can follow people on your server or on other servers. You choose who to mute or
   block and you can create lists that help you group certain contacts.

After joining the [fosstodon.org] server, I noticed that it was really easy to begin following people and get messages.
I reconnected with people that I had not heard from in a very long time!

[massive, growing list]: https://joinmastodon.org/servers
[fosstodon.org]: https://fosstodon.org/

# Migrating from Twitter

One of my first questions after joining mastodon was: "How do I find the people I follow on Twitter?"

Many Twitter users are adding their mastodon accounts to their bio to make them easier to find on mastodon.
For example, I added my mastodon account, [@major@fosstodon.org], to my [twitter bio]:

{{< figure src="twitter_bio.png" alt="Major's twitter bio" default="true" >}}

Adding this to your bio makes it easier for people to find you via some helpful tools.
I used [debirdify] to look through my Twitter account for mastodon handles of the people I follow.
Within seconds, it provided links to about 15 mastodon accounts and offered me a CSV that I could directly import into my mastodon server. 🎉
_(Mastodon servers have some awesome import and export capabilities.)_

I've also heard good things about [Fedifinder] and [Twitodon] for helping you find Twitter friends on mastodon.
There's a [helpful article on Wired] with more suggestions.

[@major@fosstodon.org]: https://fosstodon.org/@major
[debirdify]: https://pruvisto.org/debirdify/
[twitter bio]: https://twitter.com/majorhayden
[Fedifinder]: https://fedifinder.glitch.me/
[Twitodon]: https://twitodon.com/
[helpful article on Wired]: https://www.wired.com/story/how-to-find-twitter-friends-on-mastodon/

# Apps

I'm neck-deep in the Android ecosystem, so most of my suggestions here are for Android devices.
I tried the [main mastodon app] first.
It looks great, updates quickly, and is very easy to use.
However, inserting GIFs into toots became really frustrating (although I hear that's being fixed).

I moved to [Tusky] and it's my go-to mastodon app.
You can add multiple accounts, posting media is incredibly easy, and it has tons of configuration knobs everywhere.

There are various desktop applications for mastodon, but the web interface is good enough for me!
The default web interface looks a lot like Twitter with a big timeline running down the middle and section links on the right.

However, I use Tweetdeck with Twitter and I wanted something similar on mastodon.
Go into the settings for the web application, and choose *Appearance*.
Click _Enable advanced web interface_, save the changes, and click _Back to Mastodon_.
Enjoy your Tweetdeck-like multi-column interface! ✨

[main mastodon app]: https://play.google.com/store/apps/details?id=org.joinmastodon.android&gl=US
[Tusky]: https://tusky.app/

# Run your own instance

The federated nature of mastodon means you can run your own single user instance if you want!
Buy a domain you like (or use a subdomain off an existing domain) and deploy!

The upstream repository has a [helm chart] which works well with kubernetes.
Also, there's a [docker-compose] file which works well for smaller deployments.

I went the docker-compose route on a small cloud instance at Hetzner, but I modified the upstream `docker-compose.yml`:

```yaml
version: '3'
volumes:
  certs:
  postgres:
  redis:
  mastodon:
services:
  traefik:
    image: docker.io/library/traefik:latest
    container_name: traefik
    restart: unless-stopped
    command:
      # Tell Traefik to discover containers using the Docker API
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      # Enable the Trafik dashboard
      - --api.dashboard=true
      # Set up LetsEncrypt
      #- --certificatesresolvers.letsencrypt.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory
      - --certificatesresolvers.letsencrypt.acme.dnschallenge=true
      - --certificatesresolvers.letsencrypt.acme.dnschallenge.provider=porkbun
      - --certificatesresolvers.letsencrypt.acme.email=major@mhtx.net
      - --certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json
      # Set up an insecure listener that redirects all traffic to TLS
      - --entrypoints.web.address=:80
      - --entrypoints.web.http.redirections.entrypoint.to=websecure
      - --entrypoints.web.http.redirections.entrypoint.scheme=https
      - --entrypoints.websecure.address=:443
      # Set up the TLS configuration for our websecure listener
      - --entrypoints.websecure.http.tls=true
      - --entrypoints.websecure.http.tls.certResolver=letsencrypt
      - --entrypoints.websecure.http.tls.domains[0].main=toots.cloud
      - --entrypoints.websecure.http.tls.domains[0].sans=*.toots.cloud
    environment:
      - PORKBUN_SECRET_API_KEY=*****
      - PORKBUN_API_KEY=*****
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - certs:/letsencrypt
    labels:
      - "traefik.enable=true"
      - 'traefik.http.routers.traefik.rule=Host(`traefik.toots.cloud`)'
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
      - "traefik.http.routers.traefik.service=api@internal"
      - 'traefik.http.routers.traefik.middlewares=strip'
      - 'traefik.http.middlewares.strip.stripprefix.prefixes=/traefik'

  postgres:
    container_name: postgres
    restart: always
    image: docker.io/library/postgres:14-alpine
    shm_size: 256mb
    env_file: .env.production
    healthcheck:
      test: ['CMD', 'pg_isready', '-U', 'postgres']
    volumes:
      - postgres:/var/lib/postgresql/data
      - ./postgres-setup.sh:/docker-entrypoint-initdb.d/init-user-db.sh:Z
    environment:
      - 'POSTGRES_HOST_AUTH_METHOD=trust'

  redis:
    container_name: redis
    restart: always
    image: docker.io/library/redis:7-alpine
    healthcheck:
      test: ['CMD', 'redis-cli', 'ping']
    volumes:
      - redis:/data

  web:
    container_name: web
    image: docker.io/tootsuite/mastodon:v3.5.3
    restart: always
    env_file: .env.production
    command: bash -c "rm -f /mastodon/tmp/pids/server.pid; bundle exec rails s -p 3000"
    healthcheck:
      # prettier-ignore
      test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:3000/health || exit 1']
    ports:
      - '3000'
    depends_on:
      - postgres
      - redis
    volumes:
      - mastodon:/mastodon/public/system
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.web.rule=Host(`toots.cloud`)"
      - "traefik.http.routers.web.entrypoints=websecure"
      - "traefik.http.routers.web.tls.certresolver=letsencrypt"

  streaming:
    container_name: streaming
    image: docker.io/tootsuite/mastodon:v3.5.3
    restart: always
    env_file: .env.production
    command: node ./streaming
    healthcheck:
      # prettier-ignore
      test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:4000/api/v1/streaming/health || exit 1']
    ports:
      - '4000'
    depends_on:
      - postgres
      - redis

  sidekiq:
    container_name: sidekiq
    image: docker.io/tootsuite/mastodon:v3.5.3
    restart: always
    env_file: .env.production
    command: bundle exec sidekiq
    depends_on:
      - postgres
      - redis
    volumes:
      - mastodon:/mastodon/public/system
    healthcheck:
      test: ['CMD-SHELL', "ps aux | grep '[s]idekiq\ 6' || false"]
```

Here are the main changes I made:

* Specified the exact URL/tag for each container
* Added traefik to handle TLS
* Used named volumes instead of filesystem directories (made SELinux much happier)
* Added a provisioning script for postgres

The provisioning script for postgres allows me to bring up postgres without needing to run any extra commands:

```bash
#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
	CREATE USER mastodon WITH PASSWORD 'super-secret-password' CREATEDB;
EOSQL
```

Once you have all of this in place, run the usual `docker-compose up -d` and wait for everything to start.
Then you can run through the initial mastodon setup:

```console
$ docker-compose run --rm web bundle exec rake mastodon:setup
```

You will need to answer lots of questions, including your domain name, postgres/redis details, email configuration, and object storage configuration.
I use [Mailgun] for mastodon's email since it makes the setup much easier and has a very low cost.
For object storage, I went with a public [Backblaze B2] bucket since it's Amazon S3 compatible but very inexpensive[^b2config].

When the setup finishes, it will dump an environments file to the screen.
**Be sure to save that file.**
This will allow you to start up all of the containers again with the same configuration later.
A copy of the environments file will be kept inside the container storage as well.

[helm chart]: https://github.com/mastodon/mastodon/tree/main/chart
[docker-compose]: https://github.com/mastodon/mastodon/blob/main/docker-compose.yml
[Mailgun]: https://www.mailgun.com/
[Backblaze B2]: https://www.backblaze.com/b2/cloud-storage.html

[^b2config]:
    Be sure to note the endpoint for your Backblaze bucket when you create it.
    You will need to specify that endpoint when you set up mastodon.
    As an example, my endpoint is `https://s3.us-west-001.backblazeb2.com` and my region is `us-west-001`.

# Self-hosted instance takeaways

I've been running my own mastodon instance for a few days and I'm not sure if I will keep it.
Sure, I love having an instance on a hilarious domain like _toots.cloud_ and having full control over my mastodon experience.

But it's one more thing to manage, patch, and back up.

The fosstodon.org community has been excellent so far and I'm contributing to their costs each month via their [Patreon page].
Every mastodon instance is going through growing pains recently due to really high demand.

The last count from the [Mastodon Users bot] shows massive interest:

{{< figure src="mastodon_users.png" alt="Mastodon user count bot" default="true" >}}

If you're on a server that isn't performing well: **be patient**.

Ask for ways that you can help technically or financially.
One of the biggest reminders that I get from mastodon is that every server is a _community_.
The community must come together to make each server successful as a part of the big fediverse.

[Patreon page]: https://www.patreon.com/fosstodon/posts
[Mastodon Users bot]: https://bitcoinhackers.org/@mastodonusercount