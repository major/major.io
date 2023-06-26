---
aliases:
- /2012/07/15/mounting-an-lvm-snapshot-containing-partitions/
author: Major Hayden
date: 2012-07-15 20:11:38
tags:
- emergency
- fedora
- linux
- lvm
- sysadmin
- xen
title: Mounting an LVM snapshot containing partitions
---

LVM snapshots can be really handy when you're trying to take a backup of a running virtual machine. However, mounting the snapshot can be tricky if the logical volume is partitioned.

I have a virtual machine running [zoneminder][1] on one of my servers at home and I needed to take a backup of the instance with [rdiff-backup][2]. I made a snapshot of the logical volume and attempted to mount it:

```
[root@i7tiny ~]# lvcreate -s -n snap -L 5G /dev/vg_i7tiny/vm_zoneminder
  Logical volume "snap" created
[root@i7tiny ~]# mount /dev/vg_i7tiny/snap /mnt/snap/
mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg_i7tiny-snap,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
```


Oops. The logical volume has partitions. We will need to mount the volume with an offset so that we can get the right partition. Figuring out the offset can be done fairly easily with fdisk:

```
[root@i7tiny ~]# fdisk -l /dev/vg_i7tiny/vm_zoneminder

Disk /dev/vg_i7tiny/vm_zoneminder: 53.7 GB, 53687091200 bytes
255 heads, 63 sectors/track, 6527 cylinders, total 104857600 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0007a1d5

                       Device Boot      Start         End      Blocks   Id  System
/dev/vg_i7tiny/vm_zoneminder1   *        2048     1026047      512000   83  Linux
/dev/vg_i7tiny/vm_zoneminder2         1026048   102825983    50899968   83  Linux
/dev/vg_i7tiny/vm_zoneminder3       102825984   104857599     1015808   82  Linux swap / Solaris
```


It looks like we have a small boot partition, a big root partition and a swap volume. We want to mount the second volume to copy files from the root filesystem. There are two critical pieces of information here that we need:

  * the **sector** where the partition starts (the _Start_ column from fdisk)
  * the **number of bytes per sector** (512 in this case - see the third line of the fdisk output)

Let's calculate how many bytes we need to skip when we mount the partition and then mount it:

```
[root@i7tiny ~]# echo "512 * 1026048" | bc
525336576
[root@i7tiny ~]# mount -o offset=525336576 /dev/mapper/vg_i7tiny-snap /mnt/snap/
[root@i7tiny ~]# ls /mnt/snap/
bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```


The root filesystem from the virtual machine is now mounted and we can copy some files from it. Don't forget to clean up when you're finished:

```
[root@i7tiny ~]# umount /mnt/snap/
[root@i7tiny ~]# lvremove -f /dev/vg_i7tiny/snap
  Logical volume "snap" successfully removed
```


If you need to do this with file-backed virtual machine storage or with a flat file you made with dd/dd_rescue, [read my post from 2010][3] about tackling that similar problem.

 [1]: http://www.zoneminder.com/
 [2]: http://www.nongnu.org/rdiff-backup/
 [3]: /2010/12/14/mounting-a-raw-partition-file-made-with-dd-or-dd_rescue-in-linux/