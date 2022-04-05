---
title: Disable X support in FreeBSD
author: Major Hayden
type: post
date: 2007-07-18T15:12:40+00:00
url: /2007/07/18/disable-x-support-in-freebsd/
dsq_thread_id:
  - 3662287513
tags:
  - command line

---
Add to /etc/make.conf:

`WITHOUT_X11=yes<br />
USE_NONDEFAULT_X11BASE=yes`