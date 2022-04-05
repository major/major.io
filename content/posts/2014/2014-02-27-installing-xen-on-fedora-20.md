---
title: Installing Xen on Fedora 20
author: Major Hayden
type: post
date: 2014-02-28T03:43:27+00:00
url: /2014/02/27/installing-xen-on-fedora-20/
dsq_thread_id:
  - 3642807420
categories:
  - Blog Posts
tags:
  - linux
  - sysadmin
  - virt-manager
  - virtualization
  - xen

---
[<img src="/wp-content/uploads/2012/06/xen_logo_small-300x133.png" alt="Xen Logo" width="300" height="133" class="alignright size-medium wp-image-3397" srcset="/wp-content/uploads/2012/06/xen_logo_small-300x133.png 300w, /wp-content/uploads/2012/06/xen_logo_small.png 800w" sizes="(max-width: 300px) 100vw, 300px" />][1]I've written about [installing Xen on Fedora 19][2] and earlier versions on this blog before. Let's tackle it on Fedora 20.

Start with the Xen hypervisor and the basic toolset first:

```
yum -y install xen xen-hypervisor xen-libs xen-runtime
systemctl enable xend.service
systemctl enable xendomains.service
```


Get GRUB2 in order:

```
# grep ^menuentry /boot/grub2/grub.cfg | cut -d "'" -f2
Fedora, with Linux 3.13.4-200.fc20.x86_64
Fedora, with Linux 0-rescue-c9dcecb251df472fbc8b4e620a749f6d
Fedora, with Xen hypervisor
# grub2-set-default 'Fedora, with Xen hypervisor'
# grub2-editenv list
saved_entry=Fedora, with Xen hypervisor
# grub2-mkconfig -o /boot/grub2/grub.cfg
```


Now reboot. When the server restarts, verify that Xen is running:

```
# xm dmesg | head
 __  __            _  _    _____  _    ___    __      ____   ___
 \ \/ /___ _ __   | || |  |___ / / |  / _ \  / _| ___|___ \ / _ \
  \  // _ \ '_ \  | || |_   |_ \ | |_| (_) || |_ / __| __) | | | |
  /  \  __/ | | | |__   _| ___) || |__\__, ||  _| (__ / __/| |_| |
 /_/\_\___|_| |_|    |_|(_)____(_)_|    /_(_)_|  \___|_____|\___/

(XEN) Xen version 4.3.1 (mockbuild@[unknown]) (gcc (GCC) 4.8.2 20131212 (Red Hat 4.8.2-7)) debug=n Thu Feb  6 16:52:58 UTC 2014
(XEN) Latest ChangeSet:
(XEN) Bootloader: GRUB 2.00
(XEN) Command line: placeholder
```


As I've mentioned before, I enjoy using virt-manager to manage my VM's. Let's get started:

```
yum -y install virt-manager dejavu* xorg-x11-xauth
yum -y install libvirt-daemon-driver-network libvirt-daemon-driver-storage libvirt-daemon-xen
systemctl enable libvirtd.service
systemctl start libvirtd.service
```


By this point, you have the Xen hypervisor running and you have VM management tools available from virt-manager and libvirt. Enjoy!

 [1]: /wp-content/uploads/2012/06/xen_logo_small.png
 [2]: /2013/06/02/installing-the-xen-hypervisor-on-fedora-19/
