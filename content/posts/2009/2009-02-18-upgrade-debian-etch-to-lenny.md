---
title: Upgrade Debian etch to lenny
author: Major Hayden
date: 2009-02-18T13:28:39+00:00
url: /2009/02/18/upgrade-debian-etch-to-lenny/
dsq_thread_id:
  - 3642805560
tags:
  - debian
  - linux

---
I've tested this Debian etch to lenny upgrade process a few times so far, and it seems to be working well.

<pre lang="html">sudo vim /etc/apt/sources.list     [change 'etch' -> 'lenny']
sudo aptitude update
sudo aptitude install apt dpkg aptitude
sudo aptitude full-upgrade</pre>
