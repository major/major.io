---
author: Major Hayden
date: '2024-05-08'
summary: |
  The amazon-ec2-utils package in Fedora makes it a bit easier to find devices in an
  AWS EC2 instance. ️🌤️
tags: 
  - aws
  - cloud
  - fedora
  - linux
title: amazon-ec2-utils in Fedora
coverAlt: Lights hanging in a tree
coverCaption: |
  [Jack McCracken](https://unsplash.com/photos/a-lizard-is-sitting-on-a-tree-branch-fYAfyBS7fpI) via Unsplash
---

We've all been in that situation where we see a device in Linux and wonder which physical device it corresponds to.
I remember when I built my first NAS and received an alert that a drive had failed.
It took me a while to figure out which physical drive actually needed to be replaced.

This happens with network devices, too, and I [wrote a post](/p/understanding-systemds-predictable-network-device-names/) about systemd's predictable network device names back in 2015.

Cloud instances often make it even more confusing because storage devices are fully virtualized and show up differently depending on the cloud provider.
I recently packaged [amazon-ec2-utils](https://github.com/amazonlinux/amazon-ec2-utils) in Fedora to make this a little easier on AWS.

## The problem

I just built a test instance of Fedora 40 in AWS and the AWS API shows the block device mappings like this:

```console
$ aws ec2 describe-instances \
    --instance-ids i-0687448a184ab0a9e | \
    jq '.Reservations[0].Instances[0].BlockDeviceMappings'
[
  {
    "DeviceName": "/dev/sda1",
    "Ebs": {
      "AttachTime": "2024-05-08T15:24:03+00:00",
      "DeleteOnTermination": true,
      "Status": "attached",
      "VolumeId": "vol-0832569729b6c5ea6"
    }
  }
]
```

However, if I check these devices inside the instance itself, I get something totally different:

```console
[fedora@f40 ~]$ sudo fdisk -l
Disk /dev/nvme0n1: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Amazon Elastic Block Store              
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 9FB58ED7-7581-4469-BEB7-64F069151EAF

Device           Start      End  Sectors  Size Type
/dev/nvme0n1p1    2048   206847   204800  100M EFI System
/dev/nvme0n1p2  206848  2254847  2048000 1000M Linux extended boot
/dev/nvme0n1p3 2254848 20971484 18716637  8.9G Linux root (ARM-64)


Disk /dev/zram0: 1.78 GiB, 1909456896 bytes, 466176 sectors
Units: sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

[fedora@f40 ~]$ ls -al /dev/sd*
ls: cannot access '/dev/sd*': No such file or directory
```

One disk isn't so bad, but what if we add more storage?
The API tells me one thing:

```console
> aws ec2 describe-instances --instance-ids i-0687448a184ab0a9e | jq '.Reservations[0].Instances[0].BlockDeviceMappings'
[
  {
    "DeviceName": "/dev/sda1",
    "Ebs": {
      "AttachTime": "2024-05-08T15:24:03+00:00",
      "DeleteOnTermination": true,
      "Status": "attached",
      "VolumeId": "vol-0832569729b6c5ea6"
    }
  },
  {
    "DeviceName": "/dev/sde",
    "Ebs": {
      "AttachTime": "2024-05-08T15:38:29.754000+00:00",
      "DeleteOnTermination": false,
      "Status": "attached",
      "VolumeId": "vol-0a7ba05c5270d7aa3",
      "VolumeOwnerId": "xxx"
    }
  }
]
```

But then the instance tells me something else entirely:

```console
[fedora@f40 ~]$ sudo fdisk -l
Disk /dev/nvme0n1: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Amazon Elastic Block Store              
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 9FB58ED7-7581-4469-BEB7-64F069151EAF

Device           Start      End  Sectors  Size Type
/dev/nvme0n1p1    2048   206847   204800  100M EFI System
/dev/nvme0n1p2  206848  2254847  2048000 1000M Linux extended boot
/dev/nvme0n1p3 2254848 20971484 18716637  8.9G Linux root (ARM-64)


Disk /dev/zram0: 1.78 GiB, 1909456896 bytes, 466176 sectors
Units: sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/nvme1n1: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Amazon Elastic Block Store              
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
```

## udev rules to the rescue

The amazon-ec2-utils package provides some helpful udev rules and scripts to make it easier to identify these devices.
This package is on the way to Fedora as I write this post, but it hasn't reached the stable repos yet.
Once it does, you should be able to install it:

```console
$ sudo dnf install amazon-ec2-utils
```

In the meantime, you can download the latest build and install it on your instance:

```console
$ sudo dnf install /usr/bin/koji
$ koji download-build amazon-ec2-utils-2.2.0-2.fc40 
Downloading [1/2]: amazon-ec2-utils-2.2.0-2.fc40.src.rpm
[====================================] 100% 24.01 KiB / 24.01 KiB
Downloading [2/2]: amazon-ec2-utils-2.2.0-2.fc40.noarch.rpm
[====================================] 100% 20.53 KiB / 20.53 KiB
$ sudo dnf install amazon-ec2-utils-2.2.0-2.fc40.noarch.rpm
```

The cleanest method to get these new udev rules working is to reboot, but if you're in a hurry, there's an option to reload these rules without a reboot:

```console
$ sudo udevadm control --reload-rules
$ sudo udevadm trigger
```

What do we have in `/dev/` now?

```console
[fedora@f40 ~]$ ls -al /dev/sd*
lrwxrwxrwx. 1 root root 7 May  8 15:44 /dev/sda1 -> nvme0n1
lrwxrwxrwx. 1 root root 9 May  8 15:44 /dev/sda11 -> nvme0n1p1
lrwxrwxrwx. 1 root root 9 May  8 15:44 /dev/sda12 -> nvme0n1p2
lrwxrwxrwx. 1 root root 9 May  8 15:44 /dev/sda13 -> nvme0n1p3
lrwxrwxrwx. 1 root root 7 May  8 15:44 /dev/sde -> nvme1n1
```

We can put a filesystem down on the new device using the same name as the API presents:

```console
$ sudo dnf install /usr/sbin/mkfs.btrfs
$ sudo mkfs.btrfs /dev/sde
btrfs-progs v6.8.1
See https://btrfs.readthedocs.io for more information.

Performing full device TRIM /dev/sde (10.00GiB) ...
NOTE: several default settings have changed in version 5.15, please make sure
      this does not affect your deployments:
      - DUP for metadata (-m dup)
      - enabled no-holes (-O no-holes)
      - enabled free-space-tree (-R free-space-tree)

Label:              (null)
UUID:               c2fb9e33-3bf6-4b5b-aa80-44e315f499de
Node size:          16384
Sector size:        4096	(CPU page size: 4096)
Filesystem size:    10.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP             256.00MiB
  System:           DUP               8.00MiB
SSD detected:       yes
Zoned device:       no
Features:           extref, skinny-metadata, no-holes, free-space-tree
Checksum:           crc32c
Number of devices:  1
Devices:
   ID        SIZE  PATH    
    1    10.00GiB  /dev/sde
```

Being able to know these device names during the instance launch or during storage operations makes it much easier to write automation for these devices.
There's no guess work required to translate the device that an instance shows you to what you see via the API.