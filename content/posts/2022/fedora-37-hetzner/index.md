---
author: Major Hayden
date: '2022-12-08'
summary: Avoid cloud provider modifications and deploy a genuine release version of Fedora 37 on Hetzner Cloud. ⛅
tags:
  - cloud
  - fedora
  - hetzner
  - linux
title: Deploy Fedora 37 on Hetzner Cloud 🇩🇪
---

Hetzner Cloud provides high performance cloud instances with excellent network connectivity at a reasonable price.
They have two US regions (Virginia and Oregon) that give me good latency numbers here in Texas.

However, they modify some of the Linux images they offer.
This ensures every image looks similar when it boots, but it means that Fedora in one cloud doesn't behave like Fedora in another cloud.
_(They're not the only cloud that makes these changes.)_

The modifications frustrate me for two reasons:

1. I automate nearly everything and I expect images to match in different clouds.
2. I want to use the unaltered image that went through Fedora's QA process.

Fortunately for us, Hetzner offers all the tools we need to deploy our own genuine image.
Let's get started! 🔧

# Preparing for a snapshot

We need a small instance to make our initial snapshot.
Our first step is to make a cloud-init configuration.
Here's mine (be sure to change usernames and keys for yours):

```yaml
#cloud-config
users:
  - name: major
    primary_group: major
    groups:
      - sudo
      - wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIcfW3YMH2Z6NpRnmy+hPnYVkOcxNWLdn9VmrIEq3H0Ei0qWA8RL6Bw6kBfuxW+UGYn1rrDBjz2BoOunWPP0VRM= major@amdbox 
```

We could create the instance using the web console, but I prefer to use [hcloud](https://github.com/hetznercloud/cli).
Fedora users can simply run `dnf install hcloud` to get the CLI installed quickly.

Let's use the CLI to start our instance:

```text
$ hcloud image list | grep fedora
69726282   system     fedora-36            Fedora 36            -            5 GB        Wed May 11 00:50:00 CDT 2022   -
$ cat cloud-init.cfg | hcloud server create \
    --location ash \
    --image 69726282 \
    --name snapshotter \ 
    --type cpx11 \
    --user-data-from-file -
```

Once the instance finishes building, make a note of the server number in the output.

Let's put the server into rescue mode so we can have full access to the disk:

```text
$ hcloud server enable-rescue 26341155
1.2s [===================================] 100.00%
Rescue enabled for server 26341155 with root password: *****
```

Connect to the server via ssh using the root password from the rescue output.
Once we're connected, look for the root disk.
Then we download the image and extract it to the root disk directly:

```text
# fdisk -l
Disk /dev/sda: 38.15 GiB, 40961572864 bytes, 80003072 sectors
Disk model: QEMU HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 170D9ADF-A82F-4F14-975A-CA9603329ABA

Device      Start      End  Sectors  Size Type
/dev/sda1  135168 80003038 79867871 38.1G Linux filesystem
/dev/sda14   2048   133119   131072   64M EFI System
/dev/sda15 133120   135167     2048    1M BIOS boot
# export IMAGE_URL=https://mirrors.kernel.org/fedora/releases/37/Cloud/x86_64/images/Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
# curl -s $IMAGE_URL | xz -d - | dd of=/dev/sda status=progress
5343543808 bytes (5.3 GB, 5.0 GiB) copied, 172 s, 31.1 MB/s
10485760+0 records in
10485760+0 records out
5368709120 bytes (5.4 GB, 5.0 GiB) copied, 172.625 s, 31.1 MB/s
```

At this point, the root disk of the instance now holds the genuine Fedora 37 cloud image from the GA release.
We don't want to boot it before we capture it, so let's disconnect the ssh session and then power off the instance:

```text
$ hcloud server poweroff 26341155                                                                                                                                                                               
4.9s [===================================] 100.00%
Server 26341155 stopped
```

# Make the snapshot

Take a snapshot of the root disk that contains the Fedora cloud image:

```text
$ hcloud server create-image \
    --description "Fedora 37 GA image" \
    --type snapshot 26341155                                                                                                                        
51s [====================================] 100.00%
Image 91884132 created from server 26341155
```

Let's get all of the available data about our snapshot:

```text
$ hcloud image describe 91884132                                                                                                                                                                                
ID:		    91884132
Type:		snapshot
Status:		available
Name:		-
Created:	Thu Dec  8 14:20:10 CST 2022 (1 minute ago)
Description:	Fedora 37 GA image
Image size:	0.41 GB
Disk size:	40 GB
OS flavor:	fedora
OS version:	-
Rapid deploy:	no
Protection:
  Delete:	no
Labels:
  No labels
```

Now you can build instances from the snapshot!
In my case, I would adjust my original server create command to use image `91884132`:

```text
$ cat cloud-init.cfg | hcloud server create \
    --location ash \
    --image 91884132 \
    --name snapshotter \ 
    --type cpx11 \
    --user-data-from-file -
```

# 🧹 Clean up before you go!

Nothing is worse than getting a surprise bill at the end of the month for cloud infrastructure that you forgot you had!
In this case, a _CPX11_ instance should cost you less than $5 per month.
It could be worse. 🤭

Clean it up easily with one command:

```text
$ hcloud server delete 26341155                                                                                                                                                                                 
Server 26341155 deleted
```
