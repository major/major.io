---
title: Upgrading FreeBSD remotely
author: Major Hayden
type: post
date: 2007-07-18T15:10:59+00:00
url: /2007/07/18/upgrading-freebsd-remotely/
dsq_thread_id:
  - 3679042644
tags:
  - command line

---
It can be best to upgrade FreeBSD in an offline state, but if you do it online, you can do it like this:

`# csup -g -L 2 -h cvsup5.us.freebsd.org /usr/share/examples/cvsup/standard-supfile<br />
# cd /usr/src<br />
# make buildworld<br />
# make buildkernel<br />
# make installkernel<br />
# make installworld<br />
# shutdown -r now`