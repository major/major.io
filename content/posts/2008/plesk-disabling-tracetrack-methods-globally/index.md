---
aliases:
- /2008/04/23/plesk-disabling-tracetrack-methods-globally/
author: Major Hayden
date: 2008-04-23 23:40:50
tags:
- plesk
- security
- web
title: 'Plesk: Disabling TRACE/TRACK methods globally'
---

**UPDATE:** The TRACE/TRACK methods are disabled in Plesk 8.4 right out of the box!

It's always been a [bit of a challenge][1] to disable TRACE and TRACK methods with Plesk. The only available options were to create a ton of vhost.conf files or adjust the httpd.include files and prevent modifications with `chattr` (which is a bad idea on many levels).

Luckily, Parallels has made things easier with a [new knowledge base article][2].

 [1]: http://rackerhacker.com/2007/08/28/apache-disable-trace-and-track-methods/
 [2]: http://kb.parallels.com/en/4638