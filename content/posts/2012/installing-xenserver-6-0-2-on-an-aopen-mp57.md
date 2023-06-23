---
aliases:
- /2012/03/12/installing-xenserver-6-0-2-on-an-aopen-mp57/
author: Major Hayden
date: 2012-03-12 17:00:56
dsq_thread_id:
- 3648618936
tags:
- virtualization
- xen
- xenserver
title: Installing XenServer 6.0.2 on an AOpen MP57
---

[<img src="/wp-content/uploads/2012/03/BBM-APN-MP57D.jpg" alt="AOpen MP57" title="AOpen MP57" width="200" height="200" class="alignright size-full wp-image-3165" srcset="/wp-content/uploads/2012/03/BBM-APN-MP57D.jpg 300w, /wp-content/uploads/2012/03/BBM-APN-MP57D-150x150.jpg 150w" sizes="(max-width: 200px) 100vw, 200px" />][1]Getting XenServer installed on some unusual platforms takes a bit of work and the [AOpen MP57][2] is a challenging platform for a XenServer 6.0.2 installation.

My MP57 box came with the i57QMx-vP motherboard. If yours came with something else, this post may or may not work for you.

You'll need the [XenServer 6 installation ISO][3] burned to a CD to get started. Boot the CD in your MP57 and wait for the initial boot screen to appear. Type **safe** at the prompt and press enter. Go through the normal installation steps and reboot.

After the reboot, you'll notice that there's no video output for dom0. Hop on another nearby computer and ssh to your XenServer installation using the root user and the password that you set during the installation process. Open up `/boot/extlinux.conf` in your favorite text editor and make sure the `label xe` section looks like this:

```
label xe
  # XenServer
  kernel mboot.c32
  append /boot/xen.gz mem=1024G dom0_max_vcpus=4 dom0_mem=752M lowmem_emergency_pool=1M crashkernel=64M@32M acpi=off console=vga --- /boot/vmlinuz-2.6-xen root=LABEL=root-aouozuoo ro xencons=hvc console=hvc0 console=tty0 vga=785 --- /boot/initrd-2.6-xen.img
```


The `console=vga` adjustment ensures that the dom0 console is piped to the vga output and `acpi=off` fixes the lockup that will occur when the vga output is sent to your display. I also removed `splash` and `quiet` from the kernel line so that I could see all of the boot messages in detail.

 [1]: /wp-content/uploads/2012/03/BBM-APN-MP57D.jpg
 [2]: http://global.aopen.com/products_detail.aspx?Auno=3047
 [3]: https://www.citrix.com/lang/English/lp/lp_1688615.asp