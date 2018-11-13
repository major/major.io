---
title: openssl heartbleed updates for Fedora 19 and 20
author: Major Hayden
type: post
date: 2014-04-08T01:18:19+00:00
url: /2014/04/07/openssl-heartbleed-updates-for-fedora-19-and-20/
dsq_thread_id:
  - 3642807443
categories:
  - Blog Posts
tags:
  - fedora
  - security
  - sysadmin
  - yum

---
[<img src="/wp-content/uploads/2014/04/heartbleed-247x300.png" alt="heartbleed" width="247" height="300" class="alignright size-medium wp-image-4805" srcset="/wp-content/uploads/2014/04/heartbleed-247x300.png 247w, /wp-content/uploads/2014/04/heartbleed.png 341w" sizes="(max-width: 247px) 100vw, 247px" />][1]The [openssl heartbleed bug][2] has made the rounds today and there are two new testing builds or openssl out for Fedora 19 and 20:

  * [Fedora 19][3]
  * [Fedora 20][4]

Both builds are making their way over into the <del datetime="2014-04-08T01:27:56+00:00">updates-testing</del> **stable** repository thanks to some quick testing and karma from the Fedora community.

If the stable updates haven't made it into your favorite mirror yet, you can live on the edge and grab the koji builds:

### For Fedora 19 x86_64:

```
yum -y install koji
koji download-build --arch=x86_64 openssl-1.0.1e-37.fc19.1
yum localinstall openssl-1.0.1e-37.fc19.1.x86_64.rpm
```


### For Fedora 20 x86_64:

```
yum -y install koji
koji download-build --arch=x86_64 openssl-1.0.1e-37.fc20.1
yum localinstall openssl-1.0.1e-37.fc20.1.x86_64.rpm
```


Be sure to replace _x86_64_ with _i686_ for 32-bit systems or _armv7hl_ for ARM systems (Fedora 20 only). If your system has `openssl-libs` or other package installed, be sure to install those with yum as well.

Kudos to [Dennis Gilmore][5] for the hard work and to the Fedora community for the quick tests.

 [1]: /wp-content/uploads/2014/04/heartbleed.png
 [2]: http://heartbleed.com/
 [3]: https://admin.fedoraproject.org/updates/openssl-1.0.1e-37.fc19.1
 [4]: https://admin.fedoraproject.org/updates/openssl-1.0.1e-37.fc20.1
 [5]: https://fedoraproject.org/wiki/User:Ausil
