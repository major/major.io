---
title: Mounting a raw partition file made with dd or dd_rescue in Linux
author: Major Hayden
type: post
date: 2010-12-15T01:07:24+00:00
url: /2010/12/14/mounting-a-raw-partition-file-made-with-dd-or-dd_rescue-in-linux/
dsq_thread_id:
  - 3642806385
categories:
  - Blog Posts
tags:
  - command line
  - emergency
  - sysadmin

---
This situation might not affect everyone, but it struck me today and left me scratching my head. Consider a situation where you need to clone one drive to another with [dd][1] or when a hard drive is failing badly and you use [dd_rescue][2] to salvage whatever data you can.

Let's say you cloned data from a drive using something like this:

```


Once that's finished, you should end up with your partition table as well as the grub data from the MBR in your image file. If you run `file` against the image file you made, you should see something like this:

```
# file harddrive.img
harddrive.img: x86 boot sector; GRand Unified Bootloader, stage1 version 0x3, stage2
address 0x2000, stage2 segment 0x200, GRUB version 0.97; partition 1: ID=0x83,
active, starthead 1, startsector 63, 33640047 sectors, code offset 0x48</pre>

What if you want to pull some files from this image without writing it out to another disk? Mounting it like a loop file isn't going to work:

```
# mount harddrive /mnt/temp
mount: you must specify the filesystem type</pre>

The key is to mount the file [with an offset specified][3]. In the output from `file`, there is a particular portion of the output that will help you:

```


This means that the filesystem itself starts on sector 63. You can also view this with `fdisk -l`:

```
# fdisk -l harddrive.img
                    Device Boot      Start         End      Blocks   Id  System
harddrive.img                *          63    33640109    16820023+  83  Linux</pre>

Since we need to scoot 63 sectors ahead, and each sector is 512 bytes long, we need to use an offset of 32,256 bytes. Fire up the mount command and you'll be on your way:

```
# mount -o ro,loop,offset=32256 harddrive.img /mnt/loop
# mount | grep harddrive.img
/root/harddrive.img on /mnt/loop type ext3 (ro,loop=/dev/loop1,offset=32256)</pre>

If you made this image under duress (due to a failing drive or other emergency), you might have to check and repair the filesystem first. Doing that is easy if you make a loop device:

```
# losetup --offset 32256 /dev/loop2 harddrive.img
# fsck /dev/loop2</pre>

Once that's complete, you can save some time and mount the loop device directly:

```


 [1]: http://en.wikipedia.org/wiki/Dd_(Unix)
 [2]: http://www.garloff.de/kurt/linux/ddrescue/
 [3]: http://www.linuxquestions.org/questions/linux-general-1/trouble-mounting-dd-image-file-644362/#post3660310
