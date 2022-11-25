---
title: Xen 4.5 crashes during boot on Fedora 22
author: Major Hayden
date: 2015-05-27T12:33:21+00:00
url: /2015/05/27/xen-4-5-crashes-during-boot-on-fedora-22/
dsq_thread_id:
  - 3797709360
tags:
  - fedora
  - gcc
  - xen

---
[<img src="https://major.io/wp-content/uploads/2012/06/xen_logo_small-300x133.png" alt="Xen Logo" width="300" height="133" class="alignright size-medium wp-image-3397" srcset="https://major.io/wp-content/uploads/2012/06/xen_logo_small-300x133.png 300w, https://major.io/wp-content/uploads/2012/06/xen_logo_small.png 800w" sizes="(max-width: 300px) 100vw, 300px" />][1]If you're currently running a Xen hypervisor on a Fedora release before 22, **stay put for now**.

There's a bug in Xen when you compile it with GCC 5 that will cause your system to get an error during bootup. In my case, I'm sometimes getting the crash shortly after the hypervisor to dom0 kernel handoff and sometimes it's happening later in the boot process closer to when I'd expect a login screen to appear.

Here are some helpful links to follow the progress of the fix:

  * [Crash logs from the kernel panic][2]
  * [Bug 1219197 &#8211; Xen BUG at page_alloc.c:1738][3] [Red Hat Bugzilla]
  * [Bug 1908 &#8211; Xen BUG at page_alloc.c:1738][4]
  * [xen-devel mailing list thread][5]

Michael Young found that Xen 4.5.1-rc1 (which has code very similar to 4.5) will compile and boot [if compiled with GCC 4.x in Fedora 21][6]. It's a decent workaround but it's certainly not a long term fix.

I'm still doing some additional testing and I'll update this post as soon as there's more information available.

 [1]: https://major.io/wp-content/uploads/2012/06/xen_logo_small.png
 [2]: https://gist.github.com/major/baa0e2eee7de51a2bcd1
 [3]: https://bugzilla.redhat.com/show_bug.cgi?id=1219197
 [4]: http://bugzilla.xensource.com/bugzilla/show_bug.cgi?id=1908
 [5]: http://lists.xen.org/archives/html/xen-devel/2015-05/msg02604.html
 [6]: http://lists.xen.org/archives/html/xen-devel/2015-05/msg02769.html
