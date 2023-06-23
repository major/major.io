---
aliases:
- /2012/02/11/installing-fedora-16-in-xenserver/
author: Major Hayden
date: 2012-02-12 03:39:11
dsq_thread_id:
- 3642806861
tags:
- fedora
- kickstart
- sysadmin
- xen
- xenserver
title: Installing Fedora 16 in XenServer
---

Getting Fedora 16 working in XenServer isn't the easiest thing to do, but I've put together a [repository on GitHub][1] that should help. The repository contains a kickstart file along with some brief instructions to help with the installation. If you're ready to get started right now, just clone the repository:

```
git clone git://github.com/rackerhacker/kickstarts.git kickstarts
```


There are some big issues with Fedora 16 which cause problems for installations within XenServer:

  * the installer sets up a console on something other than hvc0
  * anaconda won't start without being in serial mode
  * anaconda tries to use GPT partitions by default
  * grub2 is now standard, but it causes problems for older XenServer versions

My kickstart works around the grub2 problem by throwing down an old-style grub configuration file and creating the proper symlinks. This config will still be updated when you upgrade kernels (at least in Fedora 16). It also sets up a very simple partitioning schema with one root and one swap partition. A DOS partition table is used in lieu of a GPT partition table.

When you start the installation, be sure to review the [README.md][2] in the git repository. It has some special instructions for boot options to meet the requirements of Fedora 16 and the kickstart file.

 [1]: https://github.com/rackerhacker/kickstarts
 [2]: https://github.com/rackerhacker/kickstarts/blob/master/Fedora%2016%20Minimal%20on%20XenServer%206/README.md