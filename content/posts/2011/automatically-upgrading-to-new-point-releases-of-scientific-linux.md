---
aliases:
- /2011/11/23/automatically-upgrading-to-new-point-releases-of-scientific-linux/
author: Major Hayden
date: 2011-11-23 13:20:12
dsq_thread_id:
- 3642806730
tags:
- centos
- red hat
- scientific linux
- security
- yum
title: Automatically upgrading to new point releases of Scientific Linux
---

When you install Scientific Linux, it will keep you on the same point release that you installed. For example, if you install it from a 6.0 DVD, you'll stay on 6.0 and get security releases for that point release only.

Getting it to behave like Red Hat Enterprise Linux and CentOS is a painless process. Just install the _sl6x_ repository with `yum`:

```
yum install yum-conf-sl6x
```

Check to ensure that you're getting updates from the new repository:

```
# yum repolist
repo id            repo name                                              status
sl                 Scientific Linux 6.1 - x86_64                          6,251
sl-security        Scientific Linux 6.1 - x86_64 - security updates         548
sl6x               Scientific Linux 6x - x86_64                           6,251
sl6x-security      Scientific Linux 6x - x86_64 - security updates          548
repolist: 13,598
```