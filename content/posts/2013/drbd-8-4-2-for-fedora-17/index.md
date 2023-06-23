---
aliases:
- /2013/03/31/drbd-8-4-2-for-fedora-17/
author: Major Hayden
date: 2013-03-31 17:35:29
dsq_thread_id:
- 3678910743
tags:
- drbd
- fedora
title: drbd 8.4.2 for Fedora 17
---

![1]

Fedora 17 [DRBD][2] users should see version 8.4.2 of the DRBD client tools make it into stable repositories soon. This [fixes a bug][3] caused when the kernel version was bumped to 3.8 and the kernel module no longer matched the tools. It's the same problem that [recently cropped up on Fedora 18][4].

<br clear="all" />

 [1]: /wp-content/uploads/2012/01/fedorainfinity.png
 [2]: http://en.wikipedia.org/wiki/DRBD
 [3]: https://bugzilla.redhat.com/show_bug.cgi?id=924821
 [4]: /2013/03/15/drbd-8-4-2-for-fedora-18/