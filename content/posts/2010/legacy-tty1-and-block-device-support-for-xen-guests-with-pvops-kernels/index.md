---
aktt_notify_twitter:
- false
aliases:
- /2010/05/14/legacy-tty1-and-block-device-support-for-xen-guests-with-pvops-kernels/
author: Major Hayden
date: 2010-05-14 13:24:34
tags:
- development
- kernel
- linux
- virtualization
- xen
title: Legacy tty1 and block device support for Xen guests with pvops kernels
---

The discussions about the [paravirt_ops][1], or "pvops", support in upstream kernels at [Xen Summit 2010][2] last month really piqued my interest.

Quite a few distribution maintainers have gone to great lengths to keep Xen domU support in their kernels and it's been an uphill battle. Some kernels, such as Ubuntu's [linux-ec2][3] kernels, have patches from 2.6.18 dragged forward into 2.6.32 and even 2.6.33. It certainly can't be enjoyable to keep dragging those patches forward into new kernel trees.

The paravirt_ops support for Xen guests was added in 2.6.23 and continues to be included and improved in the latest kernel trees. However, there are two significant problems with these new kernels if you're trying to work with legacy environments:

  * the console is on `hvc0`, not `tty1`
  * block devices are now `/dev/xvdX` rather than `/dev/sdX`

If you only have a few guests, these changes are generally pretty easy. Switching the console just requires some changes to your inittab or upstart configurations. Changing the block device names requires changes to the guest's Xen configuration file and `/etc/fstab` within the guest itself.

Considering the [amount of environments][4] I work with daily at Rackspace, changing the guest configuration is definitely not an option. I needed a way to keep the console and block devices unchanged so that our customers could have a consistent experience on our infrastructure.

Luckily, [Soren Hansen][5] offered to pitch in and a solution became apparent. Through some [relatively small patches][6], the legacy console and block device support was available in the latest 2.6.32 version (2.6.32.12 as of this post's writing).

So far, I've tested x86_64 and i386 versions of 2.6.32.12 with the console and block device patches. It's gone through its paces on Xen 3.0.3, 3.1.2, 3.3.0 and 3.4.2. All revisions of Fedora, CentOS, Ubuntu, Debian, Gentoo and Arch made within the last two years are working well with the new kernels.

 [1]: http://wiki.xensource.com/xenwiki/XenParavirtOps
 [2]: http://www.xen.org/xensummit/xensummit_spring_2010.html
 [3]: http://packages.ubuntu.com/lucid/linux-ec2
 [4]: http://www.rackspacecloud.com/cloud_hosting_products/servers
 [5]: http://blog.warma.dk/
 [6]: http://lists.xensource.com/archives/html/xen-devel/2010-05/msg00712.html