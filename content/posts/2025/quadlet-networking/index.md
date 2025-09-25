---
author: Major Hayden
date: '2025-09-25'
summary: >
  Networking between podman quadlets isn't automatic as it is with docker-compose, but the setup only takes a few extra steps.
tags:
  - fedora
  - linux
  - podman
  - quadlet
title: Getting podman quadlets talking to each other
coverAlt: Motion blurred photo of a car driving down a forested road
coverCaption: |
  Photo by <a href="https://unsplash.com/@micahandsammiechaffin?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Micah & Sammie Chaffin</a> on <a href="https://unsplash.com/photos/driving-down-a-forest-road-surrounded-by-trees-FDljwldfRN0?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
---

Quadlets are a handy way to manage containers using systemd unit files.
Containers running via quadlets have access to the external network by default, but they don't automatically communicate with each other like they do in a `docker-compose` setup.
Adding networking only requires a few extra steps.

## Setting up some quadlets

I often need a postgres server laying around on my local machine for quick tasks or testing something I'm working on.
Lately, I've been focused on RAG databases and that usually involves [pgvector](https://github.com/pgvector/pgvector).

The pgvector extension adds vector data types and functions to PostgreSQL, which is great for storing embeddings from machine learning models.
You can search via all of the usual SQL queries that you're used to, but pgvector adds new capabilities for searching rows based on vector similarity.

Here's the quadlet for pgvector in `~/.config/containers/systemd/pgvector.container`:

```ini
[Unit]
Description=pgvector container
After=network-online.target

[Container]
Image=docker.io/pgvector/pgvector:pg17
Volume=pgvector:/var/lib/postgresql/data
Environment=POSTGRES_USER=postgres
Environment=POSTGRES_PASSWORD=secrete
Environment=POSTGRES_DB=postgres
PublishPort=5432:5432

[Service]
Restart=unless-stopped
```

This gets a postgres server with pgvector up and running with a persistent volume.
It's listening on the default port 5432.

Sometimes I'm in a hurry and [pgadmin4](https://www.pgadmin.org/) is a quick way to poke around the database.
It's also a good example here since it needs to talk to the pgvector container.
Here's the quadlet for pgadmin4 in `~/.config/containers/systemd/pgadmin4.container`:

```ini
[Unit]
Description=pgAdmin4 container
After=network-online.target

[Container]
Image=docker.io/dpage/pgadmin4:latest
Volume=pgadmin4:/var/lib/pgadmin
Environment=PGADMIN_DEFAULT_EMAIL=major@mhtx.net
Environment=PGADMIN_DEFAULT_PASSWORD=secrete
Environment=PGADMIN_CONFIG_SERVER_MODE=False
Environment=PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False
PublishPort=8080:80

[Service]
Restart=unless-stopped
```

Awesome! Let's reload the systemd configuration for my user account and start these containers:

```bash
systemctl --user daemon-reload
systemctl --user start pgvector
systemctl --user start pgadmin4
```

We can check the running containers:

```
> podman ps --format "table {{.ID}}\t{{.Names}}"
CONTAINER ID  NAMES
b099fdaa6b18  valkey
f8ab764c299c  systemd-pgadmin4
052c160fb45b  systemd-pgvector
```

## Testing communication

Let's hop into the pgadmin4 container and see if we can connect to the pgvector database:

```
> podman exec -it systemd-pgadmin4 ping pgvector -c 4
ping: bad address 'pgvector'
> podman exec -it systemd-pgadmin4 ping systemd-pgvector -c 4
ping: bad address 'systemd-pgvector'
```

This isn't great.
There are two problems here:

1. The containers aren't on the same network
2. I want to refer to the pgvector container as `pgvector`, not `systemd-pgvector`

Let's fix that.

## Fixing communication

Open up the `~/.config/containers/systemd/pgvector.container` file and make the two changes noted below with comments:

```ini
[Unit]
Description=pgvector container
After=network-online.target

[Container]
# Use a consistent name 👇
ContainerName=pgvector
Image=docker.io/pgvector/pgvector:pg17
Volume=pgvector:/var/lib/postgresql/data
Environment=POSTGRES_USER=postgres
Environment=POSTGRES_PASSWORD=secrete
Environment=POSTGRES_DB=postgres
# Add the container to a network 👇
Network=db-network
PublishPort=5432:5432

[Service]
Restart=unless-stopped
```

Also open the `~/.config/containers/systemd/pgadmin4.container` file and make the same network change:

```ini
[Unit]
Description=pgAdmin4 container
After=network-online.target

[Container]
Image=docker.io/dpage/pgadmin4:latest
Volume=pgadmin4:/var/lib/pgadmin
Environment=PGADMIN_DEFAULT_EMAIL=major@mhtx.net
Environment=PGADMIN_DEFAULT_PASSWORD=secrete
Environment=PGADMIN_CONFIG_SERVER_MODE=False
Environment=PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False
# Add the container to a network 👇
Network=db-network
PublishPort=8080:80

[Service]
Restart=unless-stopped
```

Create the network:

```bash
podman network create db-network
```

Now, reload the systemd configuration and restart the containers:

```bash
systemctl --user daemon-reload
systemctl --user restart pgvector
systemctl --user restart pgadmin4
```

## Testing communication again

Now, let's hop into the pgadmin4 container and see if we can connect to the pgvector database:

```
> podman exec -it systemd-pgadmin4 ping pgvector -c 4
PING pgvector (10.89.5.6): 56 data bytes
64 bytes from 10.89.5.6: seq=0 ttl=42 time=0.026 ms
64 bytes from 10.89.5.6: seq=1 ttl=42 time=0.036 ms
64 bytes from 10.89.5.6: seq=2 ttl=42 time=0.034 ms
64 bytes from 10.89.5.6: seq=3 ttl=42 time=0.088 ms

--- pgvector ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.026/0.046/0.088 ms
```

**Perfect!** 🎉 🎉 🎉

## Extra credit

If you want to deploy your system with automation and avoid the manual network creation, you can add one extra file to your `~/.config/containers/systemd/` directory:

```ini
[Network]
Label=app=db-network
```
