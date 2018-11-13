---
title: Getting back to using eth0 in Fedora 15
author: Major Hayden
type: post
date: 2011-09-25T22:08:20+00:00
url: /2011/09/25/getting-back-to-using-eth0-in-fedora-15/
dsq_thread_id:
  - 3642806710
categories:
  - Blog Posts
tags:
  - command line
  - fedora
  - networking
  - sysadmin
  - xen

---
Fedora 15 was released with some updates to allow for [consistent network device names][1]. Once it's installed, you'll end up with network devices that are named something other than eth0, eth1, and so on.

For example, all onboard ethernet adapters are labeled as emX (em1, em2&#8230;) and all PCI ethernet adapters are labeled as pXpX (p[slot]p[port], like p7p1 for port 1 on slot 7). Ethernet devices within Xen virtual machines aren't adjusted.

This may make sense to people who swap out the chassis on servers regularly and they don't want to mess with hard-coding MAC addresses in network configuration files. Also, it should give users predictable names even if a running system's drives are inserted into a newer hardware revision of the same server.

However, I don't like this on my personal dedicated servers and I prefer to revert back to the old way of doing things. Getting back to eth0 is pretty simple and it only requires a few configuration files to be edited followed by a reboot.

First, add `biosdevname=0` to your `grub.conf` on the kernel line:

```
title Fedora (2.6.40.4-5.fc15.x86_64)
	root (hd0,0)
	kernel /boot/vmlinuz-2.6.40.4-5.fc15.x86_64 ro root=/dev/md0 SYSFONT=latarcyrheb-sun16 KEYTABLE=us biosdevname=0 quiet LANG=en_US.UTF-8
	initrd /boot/initramfs-2.6.40.4-5.fc15.x86_64.img
```


Open `/etc/udev/rules.d/70-persistent-net.rules` in your favorite text editor (create it if it doesn't exist) and add in the following:

```
# Be sure to put your MAC addresses in the fields below
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:11:22:33:44:10", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:11:22:33:44:11", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"
```


Be sure to rename your `ifcfg-*` files in `/etc/sysconfig/network-scripts/` to match the device names you've assigned. Just for good measure, I add in the MAC address in `/etc/sysconfig/network-scripts/ifcfg-ethX`:

```
...
HWADDR=00:11:22:33:44:10
...
```


Reboot the server and you should be back to eth0 and eth1 after a reboot.

 [1]: http://fedoraproject.org/wiki/Features/ConsistentNetworkDeviceNaming
