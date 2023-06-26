---
aliases:
- /2010/09/10/installing-xen-4-on-fedora-13/
author: Major Hayden
date: 2010-09-10 13:56:49
tags:
- fedora
- linux
- sysadmin
- virtualization
- xen
title: Installing Xen 4 on Fedora 13
---

Installing Xen can be a bit of a challenge for a beginner and it's made especially difficult by distribution vendors who aren't eager to include it in their current releases. I certainly don't blame the distribution vendors for omitting it; the code to support Xen's privileged domain isn't currently in upstream kernels.

However, [Pasi Kärkkäinen][1] has written a [detailed walkthrough][2] about how to get Xen 4 running on Fedora 13. Although there are quite a few steps involved, it's worked well for me so far.

 [1]: http://www.xen.org/community/spotlight/pasi.html
 [2]: http://wiki.xensource.com/xenwiki/Fedora13Xen4Tutorial