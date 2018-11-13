---
title: supernova 2.2.0 is available
author: Major Hayden
type: post
date: 2015-12-04T15:04:39+00:00
url: /2015/12/04/supernova-2-2-0-is-available/
dsq_thread_id:
  - 4375398564
categories:
  - Blog Posts
tags:
  - fedora
  - openstack
  - python
  - supernova

---
[<img src="/wp-content/uploads/2011/08/OpenStackLogo_270x279.jpg" alt="OpenStack logo - supernova" width="270" height="279" class="alignright size-full wp-image-2399" />][1]Thanks to all of the contributors that helped make a new release of [supernova][2] possible! Version 2.2.0 is available on [GitHub][3] or [PyPi][4].

## Changes

There's now a [fix][5] for some Pygi keyring errors that appeared on the console for some systems that use GnomeKeyring for credential storage. Thanks to [dbolackrs][6] for the fix and to [gtmanfred][7] for updating the tests.

Justin [added some functionality][8] to provide shorter listings of environment variables when you ask supernova to print all of the configurations from your `.supernova` file. This a big help for users with lots of environments configured on their system.

Finally, Daniel was able to get the `[DEFAULT]` configuration section [working again][9]. Users with lots of environments that share common configuration items can simplify their configuration files with this change.

## Updating

If you've already installed supernova with `pip`, you can get your update now:

```
pip install -U supernova
```


Builds for Fedora will be up soon.

 [1]: /wp-content/uploads/2011/08/OpenStackLogo_270x279.jpg
 [2]: https://github.com/major/supernova
 [3]: https://github.com/major/supernova/releases/tag/v2.2.0
 [4]: https://pypi.python.org/pypi/supernova/2.2.0
 [5]: https://github.com/major/supernova/commit/bbe747bef8f226e6bc2397babb6bef079b33e153
 [6]: https://github.com/dbolackrs
 [7]: https://github.com/gtmanfred
 [8]: https://github.com/major/supernova/commit/53cdf26feacb2f01aaf3988f370931a0e7ac758a
 [9]: https://github.com/major/supernova/commit/3b2398c1423d5a1b7d6965a78b4bb5dde5329cda
