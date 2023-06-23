---
aliases:
- /2007/07/18/disable-x-support-in-freebsd/
author: Major Hayden
date: 2007-07-18 15:12:40
dsq_thread_id:
- 3662287513
tags:
- command line
title: Disable X support in FreeBSD
---

Add to /etc/make.conf:

`WITHOUT_X11=yes<br />
USE_NONDEFAULT_X11BASE=yes`