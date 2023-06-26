---
aliases:
- /2007/02/21/gmt-ftp-timestamps-in-plesk/
author: Major Hayden
date: 2007-02-21 19:13:01
tags:
- ftp
- plesk
title: ProFTPD shows incorrect GMT time with Plesk
---

A really really strange issue randomly appears with ProFTPD and Plesk occasionally. On the filesystem, a file will have a correct creation/modification date, but then when you view it over FTP, it's always off by the amount of hours you differ from GMT.

For example, if the server is on Central Time, all of the files will seem to be created 6 hours after they were really created. The filesystem will show something like 10AM, but the FTP client will say 4PM. Luckily, **there is a fix!**

Add the following to your /etc/proftpd.conf file and you should be good to go:

```
TimesGMT off
SetEnv TZ :/etc/localtime
```