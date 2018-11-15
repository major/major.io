---
title: supernova 0.9.5 is available
author: Major Hayden
type: post
date: 2014-04-29T13:14:54+00:00
url: /2014/04/29/supernova-0-9-5-is-available/
dsq_thread_id:
  - 3642807486
categories:
  - Blog Posts
tags:
  - openstack
  - python
  - supernova

---
I just pushed [supernova 0.9.5 to pypi][1] and it's now available for installation using pip. You can get the latest version by running:

```
pip install --upgrade supernova
```

Some of the new features include the ability to use suprernova [with other executables][2], like [glance][3]. Place a configuration option within your ~/.supernova file that looks like this:

```ini
OS_EXECUTABLE=/usr/bin/glance
```

Once you do that, supernova will package up all of your environment variables as it normally would, but it will call glance instead of nova. Don't worry, nova is still the default unless you specify a different executable.

Installation instructions are improved and some folks were kind enough to fix some PEP8 issues. Visit the [github project page][4] for the changes that went into this release.

 [1]: https://pypi.python.org/pypi/supernova/0.9.5
 [2]: https://github.com/major/supernova/commit/60f78f16f1c433fa6c9d4c5196e20778005dea7a
 [3]: http://docs.openstack.org/developer/glance/
 [4]: https://github.com/major/supernova
