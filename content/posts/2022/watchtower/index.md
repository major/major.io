---
author: Major Hayden
date: '2023-01-04'
summary: Watchtower keeps an eye on your running containers and updates them when new containers appear upstream. 📦 
tags:
  - containers
  - coreos
  - docker
  - fedora
  - linux
  - security
title: Automatic container updates with watchtower
---

Keeping things updated quickly becomes a monotonous task.
I'm surrounded by devices that demand updates on different frequencies.
Phones, computers, tables, cloud instances, containers, and even my car need constant attention for updates that improve security or fix bugs.
_(Sometimes the updates cause bugs, but let's forget about those for now)_ 😉

My container infrastructure runs on [Fedora CoreOS](https://getfedora.org/en/coreos) and it updates itself.
It has an immutable layer underneath my containers that updates using [ostree](https://ostreedev.github.io/ostree/).

However, keeping containers updated is a constant battle.
Updating the containers themselves is fairly easy with a `podman pull` or `docker pull` followed by a stop and start.
It's a bit easier with `docker-compose`, but it's still a nuisance to remember to update.

# Enter watchtower

[Watchtower](https://containrrr.dev/watchtower/) is incredibly handy and surprisingly simple to operate.
At a high level, it reads the container tags from each running container and watches the upstream repositories for updates.
When an updated container appears, watchtower springs into action, pulls the new container, and replaces the old container with the new one.

It accepts [arguments](https://containrrr.dev/watchtower/arguments/) to configure all kinds of aspects of updating containers.
You can exclude certain containers from updates, choose your update interval, and send notifications when updates occur.

Also, if manually updating containers is something you find fascinating, watchtower can notify you about updates.
Then you get that great feeling of running lots of commands on your own.
_(Wait, surely nobody likes that!)_

# Deploy

There are plenty of configuration snippets in watchtower's documentation, but you can start off with something as simple with this in your `docker-compose.yaml`:

```yaml
services:
  watchtower:
    image: ghcr.io/containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
    privileged: true
```

My configuration on my [mastodon deployment](/p/self-hosted-mastodon-second-try/) looks something like this:

```yaml
services:
  watchtower:
    container_name: watchtower
    image: ghcr.io/containrrr/watchtower
    hostname: watchtower.tootchute.com
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_POLL_INTERVAL=86400
      - WATCHTOWER_NOTIFICATIONS=shoutrrr
      - WATCHTOWER_NOTIFICATION_URL=discord://DISCORD_WEBHOOK_KEY@DISCORD_CHANNEL_ID
    restart: always
    privileged: true
```

This configuration sends me notifications via my Discord server whenever watchtower starts or when a container is updated.

The `docker.sock` volume mount allows watchtower to interact with the container daemon underneath watchtower.
This could easily be done with `docker`, `moby-engine`, or `podman`.

I'd like to remove the `privileged` setting at some point soon but I haven't figured out a way to allow watchtower to talk to the `docker.sock` without it. 🤔

# Further considerations

If you don't trust the upstream where you download your containers, be careful using watchtower.
A malicious container could be uploaded to a particular container image repository and your system might update itself to the malicious container before the malicious container is found.
_Then again, if you don't trust the upstream where you download your containers, you should be building these containers yourself._ 😉

For more complex services that might need some extra care around updates, such as database services, you may want to exclude them from automatic updates.
You can run [multiple instances](https://containrrr.dev/watchtower/running-multiple-instances/) of watchtower with customized configurations for different sets of containers.
