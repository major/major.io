---
title: supernova is coming to Fedora repositories
author: Major Hayden
date: 2015-09-11T13:13:42+00:00
url: /2015/09/11/supernova-is-coming-to-fedora-repositories/
dsq_thread_id:
  - 4119453604
tags:
  - epel
  - fedora
  - nova
  - openstack
  - python
  - supernova

---
[<img src="/wp-content/uploads/2012/01/fedorainfinity.png" alt="Fedora Infinity Logo" width="105" height="102" class="alignright size-full wp-image-2712" />][1]If you use Fedora, you will soon be able to install [supernova][2] via a Fedora package! The [packages are currently in the testing repositories][3] but they will soon be available in the stable repositories for Fedora 22, 23, and rawhide.

### Want it right now?

If you want to install supernova now, simply tell dnf to install it from the updates-testing repository:

```
dnf install --enablerepo=updates-testing supernova
```


### supernova in EPEL

A few people have asked for supernova to be added to [EPEL][4], but the version of the [click][5] module for python is too old. Getting supernova into EPEL isn't completely off the table, but it will require some additional work.

Many thanks to [Pete][6] and Carl for helping me with the package review and bug fixes.

 [1]: /wp-content/uploads/2012/01/fedorainfinity.png
 [2]: https://github.com/major/supernova
 [3]: https://bodhi.fedoraproject.org/updates/?packages=supernova
 [4]: https://fedoraproject.org/wiki/EPEL
 [5]: http://click.pocoo.org/5/
 [6]: https://fedoraproject.org/wiki/User:Immanetize
