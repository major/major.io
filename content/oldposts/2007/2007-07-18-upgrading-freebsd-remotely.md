---
title: Upgrading FreeBSD remotely
author: Major Hayden
date: 2007-07-18T15:10:59+00:00
url: /2007/07/18/upgrading-freebsd-remotely/
dsq_thread_id:
  - 3679042644
tags:
  - command line

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
