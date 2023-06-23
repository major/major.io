---
aliases:
- /2012/07/16/boot-the-xen-hypervisor-by-default-in-fedora-17-with-grub-2/
author: Major Hayden
date: 2012-07-16 15:00:44
dsq_thread_id:
- 3642807030
tags:
- fedora
- grub2
- sysadmin
- xen
title: Boot the Xen hypervisor by default in Fedora 17 with GRUB 2
---

Although GRUB 2 does give us some nice benefits, changing its configuration can be a bit of a challenge if you're used to working with the original GRUB for many, many years. I've recently installed some Fedora 17 systems with Xen and I've had to go back to the documentation to change the default GRUB 2 boot option. Hopefully this post will save you some time.

A good place to start reading is on Fedora's own page about [GRUB 2][1] and the helpful commands provided to manage its configuration.

I'll assume you've installed the **xen** packages already and those packages have configured a (non-default) menu entry in your GRUB 2 configuration. Start by getting a list of your grub menu entry options (without the submenu options):

```
[root@remotebox ~]# grep ^menuentry /boot/grub2/grub.cfg | cut -d "'" -f2
Fedora
Fedora, with Xen hypervisor
```


We obviously wan't the second one to be our default option. Let's adjust the GRUB 2 settings and then check our work:

```
[root@remotebox ~]# grub2-set-default 'Fedora, with Xen hypervisor'
[root@remotebox ~]# grub2-editenv list
saved_entry=Fedora, with Xen hypervisor
```


The configuration file hasn't been written yet! I prefer to disable the graphical framebuffer and I like to see all of the kernel boot messages each time I reboot. Some of those messages can be handy if you have failing hardware or a bad configuration somewhere in your boot process. Open up **/etc/sysconfig/grub** in your favorite text editor and remove **rhgb quiet** from the line that starts with **GRUB\_CMDLINE\_LINUX**.

Write your new GRUB 2 configuration file:

```
[root@remotebox ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
```


Reboot your server. Once it's back, check to see if you loaded the right boot option. Even without any Xen daemons running, you should be able to check for the presence of the hypervisor:

```
[root@i7tiny ~]# dmesg | grep -i "xen version"
[    0.000000] Xen version: 4.1.2 (preserve-AD)
```


 [1]: http://fedoraproject.org/wiki/GRUB_2