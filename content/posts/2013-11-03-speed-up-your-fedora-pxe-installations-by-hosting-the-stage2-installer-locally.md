---
title: Speed up your Fedora PXE installations by hosting the stage2 installer locally
author: Major Hayden
type: post
date: 2013-11-03T17:04:33+00:00
url: /2013/11/03/speed-up-your-fedora-pxe-installations-by-hosting-the-stage2-installer-locally/
dsq_thread_id:
  - 3642807417
categories:
  - Blog Posts
tags:
  - fedora
  - network
  - pxe
  - sysadmin

---
In my previous post about [installing Fedora via PXE][1], I forgot to mention a big time saver for the installation. A Fedora PXE installation requires a few different things:

  * initial ramdisk (`initrd.img`)
  * kernel (`vmlinuz`)
  * installation repository

If you only specify an installation repository, then Anaconda tries to drag down a 214MB squashfs.img file in each installation. You can host this file locally by recreating a portion of a Fedora repo's structure and dropping two files into it.

Do the following in a directory that can be served up via HTTP:

```
mkdir -p fedora/releases/19/Fedora/x86_64/os/LiveOS/
cd fedora/releases/19/Fedora/x86_64/os/LiveOS/
wget http://mirror.rackspace.com/fedora/releases/19/Fedora/x86_64/os/LiveOS/squashfs.img
cd ..
wget http://mirror.rackspace.com/fedora/releases/19/Fedora/x86_64/os/.treeinfo
```


Your files are now ready. Go back to your tftp server and adjust your `pxelinux.0/default` file:

```
label linux
  menu label Install Fedora 19 guest
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=http://localwebserver.example.com/fedora/releases/19/Fedora/x86_64/os/ inst.repo=http://mirror.rackspace.com/fedora/releases/19/Fedora/x86_64/os/ ks=http://example.com/kickstart.ks ip=eth0:dhcp
```


This should speed up your installations by a large amount (unless your internet connection is much faster than mine).

 [1]: /2013/07/23/pxe-boot-fedora-19-using-a-mikrotik-firewall/
