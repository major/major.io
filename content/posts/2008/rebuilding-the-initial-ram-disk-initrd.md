---
aliases:
- /2008/01/28/rebuilding-the-initial-ram-disk-initrd/
author: Major Hayden
date: 2008-01-28 18:23:39
dsq_thread_id:
- 3647708564
tags:
- command line
- kernel
title: Rebuilding the initial ram disk (initrd)
---

Installing new hardware may mean that new kernel need to be loaded when your server boots up. There's a two step process to making a new initrd file:

**First,** add the appropriate line to your /etc/modules.conf or /etc/modprobe.conf which corresponds to your new kernel module.

**Next,** rebuild the initial ram disk after making a backup of the current one:

```
# cp /boot/initrd-`uname -r`.img /boot/initrd-`uname -r`.img.bak
# mkinitrd -f initrd-`uname -r`.img `uname -r`
```

Reboot the server now and make sure the new driver is loaded properly.