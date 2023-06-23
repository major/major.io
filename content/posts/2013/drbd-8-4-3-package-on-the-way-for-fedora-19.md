---
aliases:
- /2013/08/02/drbd-8-4-3-package-on-the-way-for-fedora-19/
author: Major Hayden
date: 2013-08-02 16:57:00
dsq_thread_id:
- 3678904816
tags:
- development
- drbd
- fedora
- rpm
title: drbd 8.4.3 package on the way for Fedora 19
---

There's a [drbd-8.4.3-1 package][1] waiting in the testing repository for Fedora 19. The DRBD kernel module for kernel 3.10 is up to 8.4.3 but the client tools within Fedora 19 (currently at 8.4.2) should work fine. The API versions are the same for both the kernel modules and user tools.

If you're eager to see a changelog between 8.4.2 and 8.4.3, check [DRBD's git repository][2]. The majority of the changes are within the kernel module itself.

Please help me test the package if you can spare some time. Thanks!

 [1]: https://admin.fedoraproject.org/updates/drbd-8.4.3-1.fc19
 [2]: http://git.drbd.org/gitweb.cgi?p=drbd-8.4.git;a=blob_plain;f=ChangeLog;hb=HEAD