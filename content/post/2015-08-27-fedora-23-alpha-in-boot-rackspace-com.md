---
title: Fedora 23 Alpha in boot.rackspace.com
author: Major Hayden
type: post
date: 2015-08-27T13:03:57+00:00
url: /2015/08/27/fedora-23-alpha-in-boot-rackspace-com/
dsq_thread_id:
  - 4071825825
categories:
  - Blog Posts
tags:
  - fedora
  - ipxe
  - networking
  - rackspace

---
Fedora 23's Alpha release [was announced earlier this month][1] and work is underway for the beta release. The full list of dates for the Fedora 23 release is in the [Fedora wiki][2].

If you'd like to try Fedora 23 Alpha a little sooner, check out [boot.rackspace.com][3]. I [added support for Fedora 23][4] in the menus last night.

## Quick start

If you want to get underway quickly, simply download the boot.rackspace.com ISO and attach it to a virtual machine:

```
wget http://boot.rackspace.com/ipxe/boot.rackspace.com-main.iso
```


When it boots, you'll be able to select Fedora 23's Alpha release from the menus. The Workstation, Atomic, and Server images are available.

[<img src="/wp-content/uploads/2015/08/f23_alpha_bootrackspace.png" alt="Fedora 23 alpha" width="720" height="512" class="aligncenter size-full wp-image-5855" srcset="/wp-content/uploads/2015/08/f23_alpha_bootrackspace.png 720w, /wp-content/uploads/2015/08/f23_alpha_bootrackspace-300x213.png 300w" sizes="(max-width: 720px) 100vw, 720px" />][5]

Enjoy!

 [1]: https://lists.fedoraproject.org/pipermail/announce/2015-August/003284.html
 [2]: https://fedoraproject.org/wiki/Releases/23/Schedule
 [3]: http://bootrackspacecom.readthedocs.org/en/latest/
 [4]: https://github.com/rackerlabs/boot.rackspace.com/pull/21
 [5]: /wp-content/uploads/2015/08/f23_alpha_bootrackspace.png
