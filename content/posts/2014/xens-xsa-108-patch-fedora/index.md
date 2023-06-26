---
aliases:
- /2014/10/02/xens-xsa-108-patch-fedora/
author: Major Hayden
date: 2014-10-02 12:39:11
tags:
- fedora
- security
- xen
title: Xen’s XSA-108 patch and Fedora
---

[<img src="/wp-content/uploads/2012/06/xen_logo_small-300x133.png" alt="Xen Logo" width="300" height="133" class="alignright size-medium wp-image-3397" srcset="/wp-content/uploads/2012/06/xen_logo_small-300x133.png 300w, /wp-content/uploads/2012/06/xen_logo_small.png 800w" sizes="(max-width: 300px) 100vw, 300px" />][1]Xen's latest vulnerability, [XSA-108][2], has generated a lot of buzz over the last week. Most of the attention has come from the reboot notifications from large cloud providers (including [my employer][3]).

The vulnerability allows a user within a guest to potentially read memory from another guest or the hypervisor itself. The window of available memory is small but it could be read many times over - much like how the [Heartbleed][4] vulnerability was exploited. In some situations, these actions could cause the guest or the hypervisor to crash.

The fix involves a [small patch][5] to the Xen hypervisor kernel. The patch is essentially a one-liner since the write operation was merely a no-op already.

Thanks to the efforts of Michael Young, new packages are in testing for Fedora 19, 20, and 21:

  * [xen-4.2.5-3.fc19][6]
  * [xen-4.3.3-3.fc20][7]
  * [xen-4.4.1-6.fc21][8]

If you'd like to test these packages now, you can install koji and download the RPM's directly:

```
yum -y install koji
koji download-build --arch=x86_64 xen-4.2.5-3.fc19  # For Fedora 19
koji download-build --arch=x86_64 xen-4.3.3-3.fc20  # For Fedora 20
koji download-build --arch=x86_64 xen-4.4.1-6.fc21  # For Fedora 21
```


Use yum or rpm to install the new packages. Some servers may need to install all of the downloaded RPM's or only a portion of them. All of that depends on which Xen-related packages were installed already.

After testing, _please leave karma_ in [Bodhi][9] on the appropriate package page.

 [1]: /wp-content/uploads/2012/06/xen_logo_small.png
 [2]: http://xenbits.xen.org/xsa/advisory-108.html
 [3]: http://www.rackspace.com/blog/an-apology/
 [4]: http://heartbleed.com/
 [5]: http://xenbits.xen.org/xsa/xsa108.patch
 [6]: http://koji.fedoraproject.org/koji/buildinfo?buildID=582124
 [7]: http://koji.fedoraproject.org/koji/buildinfo?buildID=582115
 [8]: http://koji.fedoraproject.org/koji/buildinfo?buildID=582102
 [9]: https://admin.fedoraproject.org/updates/xen