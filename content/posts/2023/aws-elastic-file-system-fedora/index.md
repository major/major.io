---
author: Major Hayden
date: '2023-09-13'
summary: >
    Fedora now has the AWS Elastic File Store (EFS) mount helper available for Fedora 38
    and newer releases! It chooses optimized NFS mount options for you and makes
    mounting and unmounting a breeze.
tags:
    - aws
    - cloud
    - fedora
    - linux
    - python
title: Mounting the AWS Elastic File Store on Fedora
coverAlt: Toyota 4runner in the snow on a mountain
coverCaption: |
    Photo by [Maxime Agnelli](https://unsplash.com/photos/t8zeFR65vNg) on
    [Unsplash](https://unsplash.com)
------

I package a few things here and there in [Fedora](https://fedoraproject.org/) and one of my latest packages is [efs-utils](https://src.fedoraproject.org/rpms/efs-utils).
AWS offers a mount helper for their [Elastic File System (EFS)](https://aws.amazon.com/efs/) product on [GitHub](https://github.com/aws/efs-utils).

In this post, I'll explain how to:

1. Launch a Fedora instance on AWS EC2
1. Install _efs-utils_ and launch the watchdog service
1. Create an EFS volume in the AWS console
3. Mount the EFS volume inside the Fedora instance

{{< alert "skull-crossbones" >}}
**Always check the pricing for any cloud service before you use it!**
[EFS pricing](https://aws.amazon.com/efs/pricing/) is based on how much you store and how often you access it.
Backups are also enabled by default and they add to the monthly charges.
{{< /alert >}}

Let's go! 🚀

# Wait, what is EFS?

When you launch a cloud instance (virtual machine) on most clouds, you have different storage options available to you:

* **Block storage:**
  You can add partitions to this storage, create filesystems, or even use LVM.
  It looks like someone plugged in a disk to your instance.
  You get full control over every single storage block on the volume.
  An example of this is [Elastic Block Storage (EBS)](https://aws.amazon.com/ebs/) on AWS.

* **Object storage:**
  Although you can't mount object storage (typically) within your instance, you can read/write objects to this storage via an API.
  You can upload nearly any type of file you can imagine as an object and then download it later.
  Objects can also have little bits of metadata attached to them and some of the metadata include _prefixes_ which give a folder-like experience.
  AWS [S3](https://aws.amazon.com/s3/) is a good example of this.

* **Shared filesystems:**
  This storage shows up in the instance exactly as it sounds: you get a shared filesystem.
  If you're familiar with NFS or Samba (SMB), then you've used shared filesystems already.
  They give you much better performance than object storage but offer less freedom than block storage.
  They're also great for sharing the same data between multiple instances.

Using EFS is almost like having someone else host a network accessible storage (NAS) device within your cloud deployment.

# Launching Fedora

Every image in AWS has an AMI ID attached to it and you need to know the ID for the image you want in your region.
You can find these quickly for Fedora by visiting the [Fedora Cloud download page](https://fedoraproject.org/cloud/download/).
Look for _AWS_ in the list, click the button on that row, and you'll see a list of Fedora AMI IDs.
Click the rocket (🚀) for your preferred region and you're linked directly to launch that instance in AWS!

I'm clicking the [launch link for us-east-2 (Ohio)](https://console.aws.amazon.com/ec2/home?region=us-east-2#launchAmi=ami-00ef4597fd9806efc)[^ohio].
To finish quickly, I'm choosing all of the default options and using a spot instance (look inside _Advanced details_ at the bottom of the page).

Wait for the instance to finish intializing and access it via ssh:

```console
$ ssh fedora@EXTERNAL_IP
[fedora@ip-172-31-2-38 ~]$ cat /etc/fedora-release 
Fedora release 38 (Thirty Eight)
```

Success! 🎉

# Prepare your security group

Before leaving the EC2 console, you need to make a note of the security group that you used for this instance.
That's because EFS uses security groups to guard access to volumes.
Follow these steps to find it:

1. Click _Instances_ on the left side of the EC2 console.
2. Click on the row showing the instance we just created.
3. In the bottom half of the screen, click the _Security_ tab.
4. Look for _Security groups_ in the security details and copy the security group ID for later.

It should be in the format `sg-[a-f0-9]*`.

If you click the security group name (after saving it), you'll see the inbound rules associated with that security group.
By default, items in the same security group can't talk to each other.
We need to allow that so our EFS mount will work later.

Click _Edit inbound rules_ and do the following:

1. Click _Add rule_.
2. Choose _All traffic_ in the _Type_ column. _(You can narrow this down further later.)_
3. In the source box, look for the security group you just created along with your EC2 instance.
   If you took the default during the EC2 launch process, it might be named `launch-wizard-[0-9]+`.
4. Click _Save rules_.

# Installing efs-utils

Let's start by getting the _efs-utils_ package onto our new Fedora system:

```console
$ sudo dnf -qy install efs-utils
Installed:
  efs-utils-1.35.0-2.fc38.noarch
```

The package includes some configuration, a watchdog, and a mount helper:

```console
$ rpm -ql efs-utils
/etc/amazon
/etc/amazon/efs
/etc/amazon/efs/efs-utils.conf
/etc/amazon/efs/efs-utils.crt
/usr/bin/amazon-efs-mount-watchdog
/usr/lib/systemd/system/amazon-efs-mount-watchdog.service
/usr/sbin/mount.efs
/usr/share/doc/efs-utils
/usr/share/doc/efs-utils/CONTRIBUTING.md
/usr/share/doc/efs-utils/README.md
/usr/share/licenses/efs-utils
/usr/share/licenses/efs-utils/LICENSE
/usr/share/man/man8/mount.efs.8.gz
/var/log/amazon/efs
```

Let's get the watchdog running so we have that ready later.
The watchdog helps to build and tear down the encrypted connection when you mount and unmount an EFS volume:

```console
$ sudo systemctl enable --now amazon-efs-mount-watchdog.service
Created symlink /etc/systemd/system/multi-user.target.wants/amazon-efs-mount-watchdog.service → /usr/lib/systemd/system/amazon-efs-mount-watchdog.service.
$ systemctl status amazon-efs-mount-watchdog.service
● amazon-efs-mount-watchdog.service - amazon-efs-mount-watchdog
     Loaded: loaded (/usr/lib/systemd/system/amazon-efs-mount-watchdog.service; enabled; preset: disabled)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf
     Active: active (running) since Wed 2023-09-13 18:43:46 UTC; 5s ago
   Main PID: 1258 (amazon-efs-moun)
      Tasks: 1 (limit: 4385)
     Memory: 13.3M
        CPU: 76ms
     CGroup: /system.slice/amazon-efs-mount-watchdog.service
             └─1258 /usr/bin/python3 /usr/bin/amazon-efs-mount-watchdog

Sep 13 18:43:46 ip-172-31-2-38.us-east-2.compute.internal systemd[1]: Started amazon-efs-mount-watchdog.service - amazon-efs-mount-watchdog.
```

# Setting up an EFS volume

Start by going over to the [EFS console](https://us-east-2.console.aws.amazon.com/efs/home?region=us-east-2#) and do the following:

1. Click _File systems_ in the left navigation bar
1. Click the orange _Create file system_ button at the top right

    A modal appears with a box for the volume name and a VPC selection.
    Select an easy to remember name (I'm using _testing-efs-for-blog-post_) and select a VPC.
    If you're not sure what a VPC is or which one to use, use the default VPC since that's likely where your instance landed as well.

1. Click _Create_.

There's a delay while the filesystem initializes and you should see the filesystem show _Available_ with a green check mark after about 30 seconds.
Click on the filesystem you just created from the list and you'll see the details page for the filesystem.

# Security setup

EFS volumes come online with the default security group attached and that's not helpful.
From the EFS filesystem details page, click the _Network_ tab and then click _Manage_.

For each availability zone, go to the _Security groups_ column and add the security group that your instance came up with in the first step.
In my case, I accepted the defaults from EC2 and ended up with a _launch-wizard-1_ security group.
Remove the _default_ security group from each.
Click _Save_.

# Mounting time

You should still be on the filesystem details page from the previous step.
Click _Attach_ at the top right and a modal will appear with mount instructions.
The first option should use the EFS mount helper!

For me, it looks like `sudo mount -t efs -o tls fs-0baabc62763375bb1:/ efs`

Go back to your Fedora instance, create a mount point, and create the volume:

```console
$ sudo mkdir /mnt/efs
$ sudo mount -t efs -o tls fs-0baabc62763375bb1:/ /mnt/efs
$ df -hT | grep efs
127.0.0.1:/    nfs4      8.0E     0  8.0E   0% /mnt/efs
```

We did it! 🎉

We see `127.0.0.1` here because efs-utils uses stunnel to handle the encryption between your instance and the EFS storage system.

The disk was mounted by root, so we can add a `-o user=fedora` to give our Fedora user permissions to write files:

```console
$ umount /mnt/efs
$ sudo mount -t efs -o user=fedora,tls fs-0baabc62763375bb1:/ /mnt/efs
$ touch /mnt/efs/test2.txt
$ stat /mnt/efs/test2.txt
  File: /mnt/efs/test2.txt
  Size: 0         	Blocks: 8          IO Block: 1048576 regular empty file
Device: 0,54	Inode: 17657675890899444015  Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/  fedora)   Gid: ( 1000/  fedora)
Context: system_u:object_r:nfs_t:s0
Access: 2023-09-13 19:14:23.308000000 +0000
Modify: 2023-09-13 19:14:23.308000000 +0000
Change: 2023-09-13 19:14:23.308000000 +0000
 Birth: -
```

Also, _efs-utils_ uses encrypted communication by default, which is great.
There may be some situations where you don't need encrypted communications or you don't want the overhead.
In that case, drop the `-o tls` option from the mount command and you'll mount the volume unencrypted.

```console
$ sudo umount /mnt/efs
$ sudo mount -t efs -o user=fedora fs-0baabc62763375bb1:/ /mnt/efs
$ df -hT | grep efs
fs-0baabc62763375bb1.efs.us-east-2.amazonaws.com:/ nfs4      8.0E     0  8.0E   0% /mnt/efs
```

# Extra credit

You can get fancy with [access points](https://docs.aws.amazon.com/efs/latest/ug/create-access-point.html) that allow you to carve up your EFS storage and only let certain instances mount certain parts of the filesystem.
So instance A might only be able to mount `/files/hr` while instance B can only mount `/documents`.

It would also be a good idea to take an inventory of your security groups and ensure the least amount of instances can reach your EFS volume as possible.
Much of the work I did in this post was just for testing.
A good plan might be to make a security group for your EFS volume and only allow inbound traffic from security groups which should access it.
That would allow you to gather up all of your instances into different security groups and limit access.

Also, be aware of the [EFS pricing](https://aws.amazon.com/efs/pricing/)! 💸

You are billed not only for how much storage you use, but also on requests.
Different requests are priced differently depending on access frequency.
Backups are also **enabled by default** at $0.05/GB-month!

[^ohio]:
    Why Ohio?
    I'm mainly doing it to irritate [Corey Quinn](https://www.lastweekinaws.com/). 🤭
    Any region you prefer should be fine.