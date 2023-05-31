---
title: "Launch a watchtower container via podman quadlets"
summary: |
    Podman's new quadlet feature lets you specify container launch configuration via
    simple systemd-like unit files. 📦
date: 2023-05-31
tags:
  - containers
  - coreos
  - fedora
  - podman
  - quadlet
  - security
  - watchtower
coverAlt: Super cute raccoon standing in front of green foliage
coverCaption: |
    Photo by [Toan Chu](https://unsplash.com/photos/VEzDhGMlyb8)
    on [Unsplash](https://unsplash.com/)
---

Most of my container workloads run on independent CoreOS cloud instances that I [treat like pets](/p/coreos-as-pet/).
Keeping containers update remains a constant battle, but it's still easier than running kubernetes.

I wrote about [using watchtower](/p/watchtower/) in the past to keep containers updated.
It's a simple container that does a few important things:

* It monitors (via docker/podman socket) the running containers on the host
* It tracks the versions/tags of each container image
* It looks for updated versions of the container image in their upstream repositories
* Based on a configurable schedule, it pulls a new container image and restarts the container for updates

I encourage you to [read more about watchtower on GitHub](https://github.com/containrrr/watchtower).
There's plenty you can configure, including update intervals, how updates are handled, and how you can get notifications when an update happens.

My new deployments always need watchtower running.
Luckily, we can combine Fedora CoreOS' initial provisioning system, called [ignition](https://coreos.github.io/ignition/), with podman's new [quadlet](https://www.redhat.com/sysadmin/quadlet-podman) feature and launch watchtower automatically on the first boot.

# Quadlets

So what's a quadlet?

The [blog post](https://www.redhat.com/sysadmin/quadlet-podman) explains it well by making containers more declarative via a familiar systemd syntax.
Here's an example `.container` file from the post:

```ini
[Unit]
Description=The sleep container
After=local-fs.target

[Container]
Image=registry.access.redhat.com/ubi9-minimal:latest
Exec=sleep 1000

[Install]
# Start by default on boot
WantedBy=multi-user.target default.target
```

You can toss this into `$HOME/.config/containers/systemd/mysleep.container` for rootless user containers or in `/etc/containers/systemd/mysleep.container` for a container running as root.

# Configure a quadlet on boot

As I mentioned earlier, I want a watchtower container running on my CoreOS nodes at first boot.
Let's start with a fairly basic [butane](https://coreos.github.io/butane/) file:

```yaml
variant: fcos
version: 1.4.0
passwd:
  users:
    - name: major
      groups:
        - wheel
        - sudo
      ssh_authorized_keys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyoH6gU4lgEiSiwihyD0Rxk/o5xYIfA3stVDgOGM9N0
storage:
  files:
    - path: /etc/containers/systemd/watchtower.container
      contents:
        inline: |
          [Unit]
          Description=Watchtower container updater
          Wants=network-online.target
          After=network-online.target

          [Container]
          ContainerName=watchtower
          Image=ghcr.io/containrrr/watchtower:1.5.3@sha256:a924a9aaef50016b7e69c7f618c7eb81ba02f06711558af57da0f494a76e7aca
          Environment=WATCHTOWER_CLEANUP=true
          Environment=WATCHTOWER_POLL_INTERVAL=3600
          Volume=/var/run/docker.sock:/var/run/docker.sock
          SecurityLabelDisable=true

          [Install]
          WantedBy=multi-user.target default.target
```

Let's break this file down:

1. I start by adding a user named `major` that has administrative privileges an an ssh key
   _(this is optional, but I like using my own username rather than `core`)_
2. The quadlet unit file lands in `/etc/containers/systemd/watchtower.container` and starts at boot time

The quadlet file has some important configurations:

1. I added environment variables to clean up outdated container images and check for updates once an hour
2. The podman socket is mounted inside the watchtower container
3. Security labels are disabled to allow for communication with the podman socket

{{< alert >}}
**Mounting the podman socket and disabling security labels is not an ideal security approach.**
However, I've found that watchtower's configuration and automation fits my needs really well and I retreive the image from a trusted source.
If this won't work for you, you can use [podman's built-in auto-update](https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html) feature instead.
{{< /alert >}}

From here, we convert the butane configuration into an ignition configuration.
I'm launching this CoreOS node on [VULTR](https://www.vultr.com/?ref=6941438), so I've named my files accordingly:

```console
$ butane vultr-coreos.butane > vultr-coreos.ign
```

# Let's go 🚀

I'm using VULTR's CLI here in Fedora, but you can do the same steps via VULTR's portal if needed.
Just paste in the ignition configuration into the large text box before launch.

```shell
# Install vultr-cli in Fedora
sudo dnf install vultr-cli

# Launch the instance
vultr-cli instance create --region dfw --plan vhp-2c-2gb-amd \
  --os 391 --label coreos-dfw-1 --host coreos-dfw-1 \
  --userdata "$(cat vultr-coreos.ign)"
```

Let's see how the container is doing:

```console
$ ssh major@COREOS_HOST

Fedora CoreOS 38.20230430.3.1
Tracker: https://github.com/coreos/fedora-coreos-tracker
Discuss: https://discussion.fedoraproject.org/tag/coreos

[major@coreos-dfw-1 ~]$ sudo podman ps
CONTAINER ID  IMAGE                                                                                                  COMMAND     CREATED             STATUS             PORTS       NAMES
a0024712c95d  ghcr.io/containrrr/watchtower@sha256:a924a9aaef50016b7e69c7f618c7eb81ba02f06711558af57da0f494a76e7aca              About a minute ago  Up About a minute              watchtower

[major@coreos-dfw-1 ~]$ sudo podman logs watchtower
time="2023-05-31T14:01:12Z" level=info msg="Watchtower 1.5.3"
time="2023-05-31T14:01:12Z" level=info msg="Using no notifications"
time="2023-05-31T14:01:12Z" level=info msg="Checking all containers (except explicitly disabled with label)"
time="2023-05-31T14:01:12Z" level=info msg="Scheduling first run: 2023-05-31 15:01:12 +0000 UTC"
time="2023-05-31T14:01:12Z" level=info msg="Note that the first check will be performed in 59 minutes, 59 seconds"
```

**Awesome!** 🥳

My system rebooted for an ostree update shortly after provisioning and the container came up automatically both times.