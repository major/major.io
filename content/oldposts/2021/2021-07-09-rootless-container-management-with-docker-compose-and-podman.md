---
author: Major Hayden
date: '2021-07-09'
summary: >-
    Run rootless Linux containers without any daemons using docker-compose and
    podman on Fedora! 📦
images:
- images/2021-07-09-hallway-arches.jpg
slug: Rootless-container-management-with-docker-compose-and-podman
tags:
- containers
- fedora
- linux
- podman
title: Rootless container management with docker-compose and podman
---

{{< figure src="/images/2021-07-09-hallway-arches.jpg" alt="Long stone hallway with arches and light pouring in from one side" position="center" >}}

Everyone has an opinion for the best way to manage containers, and there are
many contenders depending on how much complexity you can handle and how much
automation you require. One of my favorite ways to manage containers is
[docker-compose].

[docker-compose]: https://docs.docker.com/compose/

## Overview of docker-compose

docker-compose uses a simple YAML syntax to explain what your desired end state
should look like. The [compose specification] covers all of the relevant
configurations for containers, volumes, networks, and more. After each change,
docker-compose compares your configuration to the running containers and makes
all of the required changes.

This provides some advantages over using `docker run ...` or `podman run ...`
since you can put the YAML into version control and track your configuration
changes all in one place. I was tracking the configuration in shell scripts that
ran `docker` with lots of parameters and that became difficult to manage.

[compose specification]: https://github.com/compose-spec/compose-spec/blob/master/spec.md

## What about Podman?

[Podman] is a tool for managing containers, much like Docker, but it has some
distinct advantages:

* No daemons are needed
* You can run containers as your user, or as root
* The commands and arguments are *nearly* identical to `docker` _(no swarm
  support)_
* Podman 3 added a [complete Docker-compatible API]

This last part, the Docker-compatible API is quite interesting and this allows
docker-compose to work with podman as well as it does with docker.

Let's try it out!

[Podman]: https://podman.io/
[complete Docker-compatible API]: https://docs.podman.io/en/latest/_static/api.html

## Getting everything ready

Start with a working Fedora 34 system and install some packages:

> 💣 **HEADS UP:** The `podman-docker` package brings in podman, an alias for the
`docker` command that actually runs `podman`, and the docker-compatible API via
a socket. If you want to run podman and docker side by side on the same machine,
install `podman` instead of `podman-docker` here. If you had docker installed
already, you may need to remove it with `dnf remove docker-ce docker-ce-cli`.

```console
dnf install docker-compose podman-docker
```

We're going to do something different here. Intead of starting the podman socket
or docker daemon as root, we're going to start the podman socket as a regular
user. Switch to a regular user and start the socket:

```console
$ systemctl enable --now --user podman.socket
Created symlink /home/major/.config/systemd/user/sockets.target.wants/podman.socket → /usr/lib/systemd/user/podman.socket.
```

But wait, where's the socket?

```console
$ ls -al $XDG_RUNTIME_DIR/podman/podman.sock
srw-rw----. 1 major major 0 Jul  9 16:49 /run/user/1000/podman/podman.sock
```

That's a podman socket running as my user and exposing a docker-compatible API.
🎉

## Time for docker-compose

Now it's time to use docker-compose with podman as a regular user and run a
container as our regular user.

We can use [librespeed] for this example, and the [LinuxServer librespeed
container] is a great way to deploy it. It's a self-hosted speed test
application that works well with desktops and mobile devices.

First, we begin with the suggested docker-compose configuration:

```yaml
---
version: "2.1"
services:
  librespeed:
    image: ghcr.io/linuxserver/librespeed
    container_name: librespeed
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - librespeed:/config
    ports:
      - 8080:80
    restart: unless-stopped

volumes:
  librespeed: {}
```

Save that as `docker-compose.yml` in your current directory.

Keep in mind that docker-compose is expecting to find our docker socket in
`/var/run/docker.sock`, but we're running the podman socket as our regular user.
Let's export the `DOCKER_HOST` variable and run docker-compose to bring up our
new container:

```console
$ export DOCKER_HOST="unix:$XDG_RUNTIME_DIR/podman/podman.sock"
$ docker-compose up -d
Pulling librespeed (ghcr.io/linuxserver/librespeed:)...
10f45b17b9ab: Download complete
f23b92877416: Download complete
a5bf9c523af4: Download complete
00fe9b963179: Download complete
bfafa0ba1dc9: Download complete
c583b34264f1: Download complete
9d26cce56b8d: Download complete
70de87880afd: Download complete
0ad6c2578069: Download complete
a8792749de3b: Download complete
2d31530d2d8b: Download complete
Creating librespeed ... done
$ docker-compose ps
   Name      Command   State       Ports
--------------------------------------------
librespeed   /init     Up ()   :8080->80/tcp
```

The container is up and running as our user. Let's check the `nginx` process
inside the container to be sure:

```console
$ ps -xu |grep "nginx: master"
major       3805  0.0  0.4   5860  4692 ?        Ss   16:53   0:00 nginx: master process /usr/sbin/nginx -c /config/nginx/nginx.conf
```

Sweet! 🥳

## Time for a speed test

If we've come this far, we might as well test our internet speed to ensure the
container works!

{{< figure src="/images/2021-07-09-speedtest-prior.png" alt="Librespeed speed test interface before testing" position="center" >}}

Remember that we used port 8080 as a replacement for 80 in our docker-compose
file to avoid issues with regular users being denied access to create a listener
on ports under 1024.

Let's see how fast my connection is today:

{{< figure src="/images/2021-07-09-speedtest-after.png" alt="Librespeed speed test interface after testing" position="center" >}}

[librespeed]: https://github.com/librespeed/speedtest
[LinuxServer librespeed container]: https://docs.linuxserver.io/images/docker-librespeed

*Photo credit: [Michael D Beckwith on Unsplash](https://unsplash.com/photos/gXN8cfWlYCo)*
