---
aliases:
- /2007/07/18/upgrading-freebsd-remotely/
author: Major Hayden
date: 2007-07-18 15:10:59
tags:
- command line
title: Upgrading FreeBSD remotely
---

It can be best to upgrade FreeBSD in an offline state, but if you do it online, you can do it like this:

```
# csup -g -L 2 -h cvsup5.us.freebsd.org /usr/share/examples/cvsup/standard-supfile
# cd /usr/src
# make buildworld
# make buildkernel
# make installkernel
# make installworld
# shutdown -r now
```