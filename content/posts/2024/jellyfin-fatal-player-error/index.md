---
author: Major Hayden
date: '2024-07-02'
summary: |
  Jellyfin is a great replacement for Plex, but I ran into non-stop problems with the
  Android app with a fatal player error. 🍿
tags: 
  - container
  - docker
  - docker-compose
  - jellyfin
  - synology
title: Jellyfin fatal player error
coverAlt: Painting of a countryside
coverCaption: |
  [Birmingham Museums Trust](https://unsplash.com/photos/photography-of-open-field-during-daytime-SAQl58G-RYs) via Unsplash
---

Plex has been a mainstay for serving up media at home but it seems to have changed lately towards a more and more commercial offering.
A friend recommended [Jellyfin](https://jellyfin.org/) and I deployed it on my Synology NAS in a Docker container.

I did a few quick tests in a web browser and everything looked good.
But then my Jellyfin android app told me:

> Playback failed due to a fatal player error

Everything looked fine in the browser, so it was time to dig in.

## Checking the logs

I opened up an ssh connection on the Synology to check the logs and found something unhelpful:

```plain
Jellyfin.Api.Helpers.TranscodingJobHelper: FFmpeg exited with code 1
```

Running a few searches led me down rabbit holes to plenty of GitHub issues.
None of them fixed the issue.

## Checking the browser again

I went through a few different videos from the Synology and played each.
They all looked fine in Firefox until I reached one that seemed to stutter.
The frame rate looked as if at least half of the frames were bring dropped.

That particular video was in 4K with a high bit rate.
Back on the synology, the CPU usage was through the roof.

I configured graphics acceleration when I deployed Jellyfin.
Perhaps it wasn't working?

## Jellyfin deployment

I deployed Jellyfin using the upstream guides with docker-compose:

```yaml
jellyfin:
  image: docker.io/jellyfin/jellyfin:latest
  container_name: jellyfin
  user: 1026:100
  network_mode: "host"
  devices:
    - /dev/dri
  volumes:
    # removed
  restart: "unless-stopped"
```

One of the GitHub issues I stumbled upon suggested being specific about the video devices that are mounted inside the container.

```console
$ ls -al /dev/dri
total 0
drwxr-xr-x  2 root root              80 Jun 10 20:23 .
drwxr-xr-x 12 root root           14140 Jun 10 20:24 ..
crw-------  1 root root        226,   0 Jun 10 20:24 card0
crw-rw----  1 root videodriver 226, 128 Jun 10 20:24 renderD128
```

I adjusted the deployment in `docker-compose.yaml` and tried again:

```yaml
jellyfin:
  image: docker.io/jellyfin/jellyfin:latest
  container_name: jellyfin
  user: 1026:100
  network_mode: "host"
  devices:
    - /dev/dri/renderD128:/dev/dri/renderD128
    - /dev/dri/card0:/dev/dri/card0
  volumes:
    # removed
  restart: "unless-stopped"
```

I redeployed jellyfin:

```console
$ docker-compose up -d jellyfin
```

The Android app still had the fatal player error.

## Users and groups

Most of my Synology containers use the uid/gid pair of `1026:100` so allow them to read and write to my storage volume.
The `/dev/dri/renderD128` is owned by the `videodriver` group:

```console
$ grep videodriver /etc/group
videodriver::937:PlexMediaServer
```

This likely came from a time when I installed Plex on Synology via one of the Synology applications rather than from a container.
*(I'm not sure, but that's my guess.)*

I added that group to the container:

```yaml
jellyfin:
  image: docker.io/jellyfin/jellyfin:latest
  container_name: jellyfin
  user: 1026:100
  network_mode: "host"
  group_add:
    - "937"
  devices:
    - /dev/dri/renderD128:/dev/dri/renderD128
    - /dev/dri/card0:/dev/dri/card0
  volumes:
    # removed
  restart: "unless-stopped"
```

After redeploying the container, the Android app worked just fine!
Also, the video stuttering disappeared when viewing the 4K video from the browser. 🎉