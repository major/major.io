---
author: Major Hayden
categories:
- Blog Posts
date: '2019-08-07'
summary: Fedora 30 is a great Linux distribution for cloud platforms, but it needs
  a little work to perform well on Google Compute Engine.
images:
- images/2019-08-07-google-hq.jpg
slug: fedora-30-on-google-compute-engine
tags:
- cloud
- fedora
- google
- linux
title: Fedora 30 on Google Compute Engine
type: post
---

![Google building]

Fedora 30 is my primary operating system for desktops and servers, so I
usually try to take it everywhere I go. I was recently doing some
benchmarking for kernel compiles on different cloud plaforms and I noticed
that Fedora isn't included in Google Compute Engine's default list of
operating system images.

*(Note: Fedora does include links to quick start an Amazon EC2 instance with
their [pre-built AMI's]. They are superb!)*

## First try

Fedora does offer cloud images in raw and qcow2 formats, so I decided to give
that a try. Start by downloading the image, decompressing it, and then
repackaging the image into a tarball.

```shell
$ wget http://mirrors.kernel.org/fedora/releases/30/Cloud/x86_64/images/Fedora-Cloud-Base-30-1.2.x86_64.raw.xz
$ xz -d Fedora-Cloud-Base-30-1.2.x86_64.raw.xz
$ mv Fedora-Cloud-Base-30-1.2.x86_64.raw disk.raw
$ tar cvzf fedora-30-google-cloud.tar.gz disk.raw
```

Once that's done, create a bucket on Google storage and upload the tarball.

```shell
$ gsutil mb gs://fedora-cloud-base-30-image
$ gsutil cp fedora-30-google-cloud.tar.gz gs://fedora-cloud-image-30/
```

Uploading 300MB on my 10mbit/sec uplink was a slow process. When that's done,
tell Google Compute Engine that we want a new image made from this raw
disk we uploaded:

```shell
$ gcloud compute images create --source-uri \
    gs://fedora-cloud-image-30/fedora-30-google-cloud.tar.gz \
    fedora-30-google-cloud
```

After a few minutes, a new custom image called `fedora-30-google-cloud` will
appear in the list of images in Google Compute Engine.

```shell
$ gcloud compute images list | grep -i fedora
fedora-30-google-cloud   major-hayden-20150520    PENDING
$ gcloud compute images list | grep -i fedora
fedora-30-google-cloud   major-hayden-20150520    PENDING
$ gcloud compute images list | grep -i fedora
fedora-30-google-cloud   major-hayden-20150520    READY
```

I opened a browser, ventured to the [Google Compute Engine console], and
built a new VM with my image.

## Problems abound

However, there are problems when the instance starts up. The serial console
has plenty of errors:

```
DataSourceGCE.py[WARNING]: address "http://metadata.google.internal/computeMetadata/v1/" is not resolvable
```

Obviously something is wrong with DNS. It's apparent that `cloud-init` is
stuck in a bad loop:

```
url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [87/120s]: bad status code [404]
url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [93/120s]: bad status code [404]
url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [99/120s]: bad status code [404]
url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [105/120s]: bad status code [404]
url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [112/120s]: bad status code [404]
url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [119/120s]: unexpected error [Attempted to set connect timeout to 0.0, but the timeout cannot be set to a value less than or equal to 0.]
DataSourceEc2.py[CRITICAL]: Giving up on md from ['http://169.254.169.254/2009-04-04/meta-data/instance-id'] after 126 seconds
```

Those are EC2-type metadata queries and they won't work here. The instance
also has no idea how to set up networking:

```
Cloud-init v. 17.1 running 'init' at Wed, 07 Aug 2019 18:27:07 +0000. Up 17.50 seconds.
ci-info: +++++++++++++++++++++++++++Net device info++++++++++++++++++++++++++++
ci-info: +--------+-------+-----------+-----------+-------+-------------------+
ci-info: | Device |   Up  |  Address  |    Mask   | Scope |     Hw-Address    |
ci-info: +--------+-------+-----------+-----------+-------+-------------------+
ci-info: | eth0:  | False |     .     |     .     |   .   | 42:01:0a:f0:00:5f |
ci-info: |  lo:   |  True | 127.0.0.1 | 255.0.0.0 |   .   |         .         |
ci-info: |  lo:   |  True |     .     |     .     |   d   |         .         |
ci-info: +--------+-------+-----------+-----------+-------+-------------------+
```

This image is set up well for Amazon, but it needs some work to work at
Google.

## Fixing up the image

Go back to the `disk.raw` that we made in the first step of the blog post. We
need to mount that disk, mount some additional filesystems, and chroot into
the Fedora 30 installation on the raw disk.

Start by making a loop device for the raw disk and enumerating its partitions:

```
$ sudo losetup  /dev/loop0 disk.raw
$ kpartx -a /dev/loop0
```

Make a mountpoint and mount the first partition on that mountpoint:

```
$ sudo mkdir /mnt/disk
$ sudo mount /dev/mapper/loop0p1 /mnt/disk
```

We need some extra filesystems mounted before we can run certain commands in
the chroot:

```
$ sudo mount --bind /dev /mnt/disk/dev
$ sudo mount --bind /sys /mnt/disk/sys
$ sudo mount --bind /proc /mnt/disk/proc
```

Now we can hop into the chroot:

```
$ sudo chroot /mnt/disk
```

From inside the chroot, remove `cloud-init` and install
`google-compute-engine-tools` to help with Google cloud:

```
$ dnf -y remove cloud-init
$ dnf -y install google-compute-engine-tools
$ dnf clean all
```

The `google-compute-engine-tools` package has lots of services that help with
running on Google cloud. We need to enable each one to run at boot time:

```
$ systemctl enable google-accounts-daemon google-clock-skew-daemon \
    google-instance-setup google-network-daemon \
    google-shutdown-scripts google-startup-scripts
```

To learn more about these daemons and what they do, head on over to the
`GitHub page` for the package.

Exit the chroot and get back to your main system. Now that we have this image
just like we want it, it's time to unmount the image and send it to the
cloud:

```
$ sudo umount /mnt/disk/dev /mnt/disk/sys /mnt/disk/proc
$ sudo umount /mnt/disk
$ sudo losetup -d /dev/loop0
$ tar cvzf fedora-30-google-cloud-fixed.tar.gz disk.raw
$ gsutil cp fedora-30-google-cloud-fixed.tar.gz gs://fedora-cloud-image-30/
$ gcloud compute images create --source-uri \
    gs://fedora-cloud-image-30/fedora-30-google-cloud-fixed.tar.gz \
    fedora-30-google-cloud-fixed
```

Start a new instance with this fixed image and watch it boot in the serial
console:

```
[   10.379253] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 10737418240 ms ovfl timer
[   10.381350] RAPL PMU: hw unit of domain pp0-core 2^-0 Joules
[   10.382487] RAPL PMU: hw unit of domain package 2^-0 Joules
[   10.383415] RAPL PMU: hw unit of domain dram 2^-16 Joules
[   10.503233] EDAC sbridge:  Ver: 1.1.2


Fedora 30 (Cloud Edition)
Kernel 5.1.20-300.fc30.x86_64 on an x86_64 (ttyS0)

instance-2 login:
```

Yes! A ten second boot with networking is exactly what I needed.

[Google building]: /images/2019-08-07-google-hq.jpg
[pre-built AMI's]: https://alt.fedoraproject.org/cloud/
[Google Compute Engine console]: https://console.cloud.google.com/compute/
[GitHub page]: https://github.com/GoogleCloudPlatform/compute-image-packages
