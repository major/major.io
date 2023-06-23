---
aliases:
- /2009/02/18/upgrade-debian-etch-to-lenny/
author: Major Hayden
date: 2009-02-18 13:28:39
dsq_thread_id:
- 3642805560
tags:
- debian
- linux
title: Upgrade Debian etch to lenny
---

I've tested this Debian etch to lenny upgrade process a few times so far, and it seems to be working well.

<pre lang="html">sudo vim /etc/apt/sources.list     [change 'etch' -> 'lenny']
sudo aptitude update
sudo aptitude install apt dpkg aptitude
sudo aptitude full-upgrade</pre>