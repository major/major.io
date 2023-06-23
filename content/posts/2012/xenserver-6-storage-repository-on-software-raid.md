---
aliases:
- /2012/01/16/xenserver-6-storage-repository-on-software-raid/
author: Major Hayden
date: 2012-01-16 15:00:21
dsq_thread_id:
- 3642806794
tags:
- command line
- linux
- lvm
- mdadm
- raid
- xen
- xenserver
title: 'XenServer 6: Storage repository on software RAID'
---

Although Citrix recommends against using software RAID with XenServer due to performance issues, I've had some pretty awful experiences with hardware RAID cards over the last few years. In addition, the price of software RAID makes it a very desirable solution.

**Before you get started,** [go through the steps to disable GPT][1]. That post also explains an optional adjustment to get a larger root partition (which I would recommend). _You cannot complete the steps in this post if your XenServer installation uses GPT._

You should have three partitions on your first disk after the installation:

```
# fdisk -l /dev/sda
-- SNIP --
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        2611    20971520   83  Linux
/dev/sda2            2611        5222    20971520   83  Linux
/dev/sda3            5222       19457   114345281   8e  Linux LVM
```


Here's a quick explanation of your partitions:

  * **/dev/sda1:** the XenServer root partition
  * **/dev/sda2:** XenServer uses this partition for temporary space during upgrades
  * **/dev/sda3:** your storage repository should be in this logical volume

We need to replicate the same partition structure across each of your drives and the software RAID volume will span the across the third partition on each disk. Copying the partition structure from disk to disk is done easily with `sfdisk`:

<span style="color: #D42020;"><b>WHOA THERE! NO TURNING BACK!</b> This step is destructive! If your other disks have any data on them, this step will make it (relatively) impossible to retrieve data on those disks again. Back up any data on the other disks in your XenServer machine before running these next commands.</span>

```
sfdisk -d /dev/sda | sfdisk --force /dev/sdb
sfdisk -d /dev/sda | sfdisk --force /dev/sdc
sfdisk -d /dev/sda | sfdisk --force /dev/sdd
```


If you have only two disks, stop with `/dev/sdb` and you'll be making a RAID 1 array. My machine has four disks and I'll be making a RAID 10 array.

We need to destroy the main storage repository, but we need to unplug the physical block device first. Get the storage repository uuid first, then use it to find the corresponding physical block device. Once the physical block device is unplugged, the storage repository can be destroyed:

```
# xe sr-list name-label=Local\ storage | head -1
uuid ( RO)                : 75264965-f981-749e-0f9a-e32856c46361
# xe pbd-list sr-uuid=75264965-f981-749e-0f9a-e32856c46361 | head -1
uuid ( RO)                  : ff7e9656-c27c-1889-7a6d-687a561f0ad0
# xe pbd-unplug uuid=ff7e9656-c27c-1889-7a6d-687a561f0ad0
# xe sr-destroy uuid=75264965-f981-749e-0f9a-e32856c46361
```


All of the LVM data from `/dev/sda3` should now be gone:

```
# lvdisplay && vgdisplay && pvdisplay
#
```


Change the third partition on each physical disk to be a software RAID partition type:

```
echo -e "t\n3\nfd\nw\n" | fdisk /dev/sda
echo -e "t\n3\nfd\nw\n" | fdisk /dev/sdb
echo -e "t\n3\nfd\nw\n" | fdisk /dev/sdc
echo -e "t\n3\nfd\nw\n" | fdisk /dev/sdd
```


Stop here and reboot your XenServer box to pick up the new partition changes. Once the server comes back from the reboot, start up a software RAID volume with `mdadm`:

```
// RAID 1 for two drives
mdadm --create /dev/md0 -l 1 -n 2 /dev/sda3 /dev/sdb3
// RAID 10 for four drives
mdadm --create /dev/md0 -l 10 -n 4 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3
```


Check to see that your RAID array is building:

```
# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sdd3[3] sdc3[2] sdb3[1] sda3[0]
      228690432 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      [>....................]  resync =  0.3% (694272/228690432) finish=16.4min speed=231424K/sec
```


Although you don't have to wait for the resync to complete, just be aware that XenServer doesn't do well with a lot of disk I/O within dom0. You may notice unusually slow performance in dom0 until it finishes. Save the array's configuration for reboots:

```
 /etc/mdadm.conf
```


Edit the `/etc/mdadm.conf` file and append `auto=yes` to the end of the line (but leave everything on one line):

```
ARRAY /dev/md0 level=raid10 num-devices=4 metadata=0.90 \
  UUID=2876748c:5117eed5:ce4d62d3:9592bd84 auto=yes
```


Create a new storage repository on the RAID volume with thin provisioning (thanks to [Spherical Chicken][2] for the command):

```
xe sr-create content-type=user type=ext device-config:device=/dev/md0 shared=false name-label="Local storage"
```


This command takes some time to complete since it makes logical volumes and then makes an ext3 filesystem for the new storage repository. Bigger RAID arrays will take more time and it's guaranteed to take longer than you'd expect if your RAID array is still building. As soon as it completes, you'll be given the uuid of your new storage repository and it should appear within the XenCenter interface.

TIP: If you run into any problems during reboots, open `/boot/extlinux.conf` and remove `splash` and `quiet` from the `label xe` boot section. This removes the framebuffer during boot-up and it causes a lot more output to be printed to the console. It won't affect the display once your XenServer box has fully booted.

 [1]: http://rackerhacker.com/2012/01/13/xenserver-6-disable-gpt-and-get-a-larger-root-partition/
 [2]: http://www.scriptkiddie.org/blog/2010/06/20/xenserver-5-6-thin-provisioning-with-ext3/