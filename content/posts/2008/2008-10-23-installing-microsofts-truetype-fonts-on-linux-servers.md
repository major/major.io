---
title: Installing Microsoft’s TrueType fonts on Linux servers
author: Major Hayden
type: post
date: 2008-10-24T00:31:23+00:00
url: /2008/10/23/installing-microsofts-truetype-fonts-on-linux-servers/
dsq_thread_id:
  - 3649065573
categories:
  - Blog Posts
tags:
  - fonts
  - rpm

---
Although the idea of [putting something from Microsoft on a Linux box][1] might sound awful at first, you may find a reason to use Microsoft TrueType fonts on a Linux server. If you're using GD to render an image, these fonts may come in handy.

If you have an RPM-based linux distribution, you can use a spec file that is available on [SourceForge][2]. You can follow the instructions on the [project's page][2], or you can follow these abbreviated instructions here:

Install some prerequisites:

```
// RHEL 4
up2date -i rpm-build wget ttmkfdir
// RHEL 5
yum install rpm-build wget ttmkfdir
```


Install [cabextract][3].

Build the RPM:

```
wget -O /usr/src/redhat/SPECS/msttcorefonts-2.0-1.spec http://corefonts.sourceforge.net/msttcorefonts-2.0-1.spec
rpmbuild -bb msttcorefonts-2.0-1.spec
rpm -Uvh /usr/src/redhat/SPECS/msttcorefonts-2.0-1.spec
```


Test it to be sure that they're installed:

```
xlsfonts | grep ^-microsoft
rpm -ql msttcorefonts
```


 [1]: http://www.rtr.com/fpsupport/
 [2]: http://corefonts.sourceforge.net/
 [3]: http://rpmfind.net/linux/rpm2html/search.php?query=cabextract&submit=Search+...
