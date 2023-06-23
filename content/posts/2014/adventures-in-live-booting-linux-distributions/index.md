---
aliases:
- /2014/07/29/adventures-in-live-booting-linux-distributions/
author: Major Hayden
date: 2014-07-29 13:05:54
dsq_thread_id:
- 3642807638
tags:
- arch
- centos
- debian
- development
- fedora
- filesystem
- live
- network
- opensuse
- redhat
- squashfs
- sysadmin
- ubuntu
title: Adventures in live booting Linux distributions
---

We're all familiar with live booting Linux distributions. Almost every Linux distribution under the sun has a method for making live CD's, writing live USB sticks, or booting live images over the network. The primary use case for some distributions is on a live medium (like [KNOPPIX][1]).

However, I embarked on an adventure to look at live booting Linux for a different use case. Sure, many live environments are used for demonstrations or installations - temporary activities for a desktop or a laptop. My goal was to find a way to boot a large fleet of servers with live images. These would need to be long-running, stable, feature-rich, and highly configurable live environments.

Finding off the shelf solutions wasn't easy. Finding cross-platform off the shelf solutions for live booting servers was even harder. I worked on a solution with a coworker to create a cross-platform live image builder that we hope to open source soon. (I'd do it sooner but the code is horrific.) ;)

#### Debian jessie (testing)

First off, we took a look at Debian's [Live Systems project][2]. It consists of two main parts: something to build live environments, and something to help live environments boot well off the network. At the time of this writing, the live build process leaves a lot to be desired. There's a peculiar tree of directories that are required to get started and the documentation isn't terribly straightforward. Although there's a bunch of documentation available, it's difficult to follow and it seems to skip some critical details. _(In all fairness, I'm an experienced Debian user but I haven't gotten into the innards of Debian package/system development yet. My shortcomings there could be the cause of my problems.)_

The second half of the Live Systems project consist of multiple packages that help with the initial boot and configuration of a live instance. These tools work **extremely well**. Version 4 (currently in alpha) has tools for doing all kinds of system preparation very early in the boot process and it's compatible with SysVinit or systemd. The live images boot up with a simple [SquashFS][3] (mounted read only) and they use AUFS to add on a writeable filesystem that stays in RAM. Reads and writes to the RAM-backed filesystem are extremely quick and you don't run into a brick wall when the filesystem fills up (more on that later with Fedora).

#### Ubuntu 14.04

Ubuntu uses [casper][4] which seems to precede Debian's Live Systems project or it could be a fork (please correct me if I'm incorrect). Either way, it seemed a bit less mature than Debian's project and left a lot to be desired.

#### Fedora and CentOS

Fedora 20 and CentOS 7 are very close in software versions and they use the same mechanisms to boot live images. They use [dracut][5] to create the initramfs and there are a set of [dmsquash modules][6] that handle the setup of the live image. The [livenet][7] module allows the live images to be pulled over the network during the early part of the boot process.

Building the live images is a little tricky. You'll find good [documentation and tools][8] for standard live bootable CD's and USB sticks, but booting a server isn't as straightforward. Dracut expects to find a [squashfs which contains a filesystem image][9]. When the live image boots, that filesystem image is connected to a loopback device and mounted read-only. A snapshot is made via device mapper that gives you a small overlay for adding data to the live image.

This overlay comes with some caveats. Keeping tabs on how quickly the overlay is filling up can be tricky. Using tools like _df_ is insufficient since device mapper snapshots are concerned with blocks. As you write 4k blocks in the overlay, you'll begin to fill the snapshot, just as you would with an LVM snapshot. When the snapshot fills up and there are no blocks left, the filesystem in RAM becomes corrupt and unusable. There are some tricks to force it back online but I didn't have much luck when I tried to recover. The only solution I could find was to hard reboot.

#### Arch

The ArchLinux live boot environments seem very similar to the ones I saw in Fedora and CentOS. All of them use dracut and systemd, so this makes sense. Arch once used a project called [Larch][10] to create live environments but it's fallen out of support due to AUFS2 being removed (according to the [wiki page][11]).

Although I didn't build a live environment with Arch, I booted one of their live ISO's and found their live environment to be much like Fedora and CentOS. There was a device mapper snapshot available as an overlay and once it's full, you're in trouble.

#### OpenSUSE

The path to live booting an OpenSUSE image seems quite different. The live squashfs is mounted read only onto _/read-only_. An ext3 filesystem is created in RAM and is mounted on _/read-write_. From there, [overlayfs][12] is used to lay the writeable filesystem on top of the read-only squashfs. You can still fill up the overlay filesystem and cause some temporary problems, but you can back out those errant files and still have a useable live environment.

Here's the problem: overlayfs was given the green light for _consideration_ in the Linux kernel [by Linus in 2013][13]. It's been proposed for several kernel releases and it didn't make it into 3.16 (which will be released soon). OpenSUSE has wedged overlayfs into their kernel tree just as Debian and Ubuntu have wedged AUFS into theirs.

#### Wrap-up

Building highly customized live images isn't easy and running them in production makes it more challenging. Once the upstream kernel has a stable, solid, stackable filesystem, it should be much easier to operate a live environment for extended periods. There has been a parade of stackable filesystems over the years (remember funion-fs?) but I've been told that overlayfs seems to be a solid contender. I'll keep an eye out for those kernel patches to land upstream but I'm not going to hold my breath quite yet.

 [1]: http://www.knoppix.org/
 [2]: http://live.debian.net/
 [3]: https://en.wikipedia.org/wiki/SquashFS
 [4]: https://help.ubuntu.com/community/LiveCDCustomizationFromScratch
 [5]: https://dracut.wiki.kernel.org/index.php/Main_Page
 [6]: https://git.kernel.org/cgit/boot/dracut/dracut.git/tree/modules.d/90dmsquash-live
 [7]: https://git.kernel.org/cgit/boot/dracut/dracut.git/tree/modules.d/90livenet
 [8]: https://fedoraproject.org/wiki/LiveOS_image
 [9]: https://fedoraproject.org/wiki/LiveOS_image#Operating_system_file_systems
 [10]: https://wiki.archlinux.org/index.php/larch
 [11]: https://wiki.archlinux.org/index.php/larch#Installation
 [12]: https://kernel.googlesource.com/pub/scm/linux/kernel/git/mszeredi/vfs/+/overlayfs.current/Documentation/filesystems/overlayfs.txt
 [13]: https://lwn.net/Articles/542709/