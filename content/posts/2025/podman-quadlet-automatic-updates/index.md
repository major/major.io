---
author: Major Hayden
date: '2025-09-19'
summary: |
  Podman's quadlet system combined with systemd timers makes container updates easy and automatic.
tags:
  - containers
  - podman
  - fedora
  - linux
  - systemd
title: Automatic container updates with Podman quadlets
coverAlt: Leopard staring into the distance
coverCaption: |
  Photo by <a href="https://unsplash.com/@fabbel78?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Fabien BELLANGER</a> on <a href="https://unsplash.com/photos/a-cheetah-cub-looks-attentively-into-the-distance-45xy4ugmnsM?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
---

Running containers at home or in production often means juggling updates across multiple services.
While orchestration platforms like Kubernetes handle this automatically, what about those simple deployments on a single host?

Podman's quadlet system integrates containers directly with systemd, and when combined with automatic updates, you get a robust solution that keeps your containers fresh without manual intervention.

Let's explore how to set up automatic container updates using Podman quadlets on Fedora, turning container management into a hands-off operation that just works.

## Setting up a basic quadlet

First, let's create a simple quadlet for running a Valkey database service under a user account.
Quadlet files for user services live in `~/.config/containers/systemd/`.

Create the directory if it doesn't exist:

```bash
mkdir -p ~/.config/containers/systemd/
```

Then create your quadlet file:

```ini
# ~/.config/containers/systemd/valkey.container
[Container]
ContainerName=valkey
Image=docker.io/valkey/valkey:latest
Label=io.containers.autoupdate=registry
PublishPort=16379:6379
Volume=valkey_data:/data

[Service]
Restart=always

[Install]
WantedBy=default.target
```

The magic happens with the `Label=io.containers.autoupdate=registry` line.
This label tells Podman that this container should be automatically updated when a newer image is available in the registry.

After creating the file, reload systemd and start your container:

```bash
systemctl --user daemon-reload
systemctl --user start valkey.service
```

Your container is now running as a user systemd service!
Check its status with:

```bash
systemctl --user status valkey.service
podman ps
```

## Enabling automatic updates

Podman ships with a systemd timer that checks for container updates.
The `podman-auto-update.timer` runs daily by default, but you need to enable it for your user:

```bash
systemctl --user enable --now podman-auto-update.timer
```

You can check when the next update will run:

```bash
systemctl --user list-timers podman-auto-update.timer
```

When the timer triggers, it runs `podman auto-update`, which:
1. Checks all containers with the `io.containers.autoupdate` label
2. Pulls newer images if available
3. Restarts containers with the new image
4. Keeps the old image in case you need to roll back

## Customizing update behavior

The `io.containers.autoupdate` label supports different values for various update strategies:

```ini
# Always pull the latest image from the registry
Label=io.containers.autoupdate=registry

# Only update if the local image changes (useful for locally built images)
Label=io.containers.autoupdate=local
```

You can also customize when updates occur by creating a timer override:

```bash
systemctl --user edit podman-auto-update.timer
```

Add these lines to run updates every 6 hours instead of daily:

```ini
[Timer]
OnCalendar=
OnCalendar=*-*-* 00,06,12,18:00:00
```

## Monitoring updates

Track what's happening with your automatic updates using journalctl:

```bash
# View recent auto-update logs
journalctl --user -u podman-auto-update.service -n 50

# Follow updates in real-time
journalctl --user -u podman-auto-update.service -f

# Check a specific container's restart history
journalctl --user -u valkey.service | grep Started
```

## Further reading

* [Podman documentation on auto-updates](https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html) - Official documentation for the auto-update feature
* [Systemd Quadlet documentation](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) - Complete reference for quadlet unit files
* [Red Hat's guide to Podman quadlets](https://www.redhat.com/sysadmin/quadlet-podman) - Excellent introduction with more examples
