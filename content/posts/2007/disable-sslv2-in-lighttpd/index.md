---
aliases:
- /2007/04/08/disable-sslv2-in-lighttpd/
author: Major Hayden
date: 2007-04-08 23:26:07
tags:
- security
- web
title: Disable SSLv2 in Lighttpd
---

As with most things, turning off SSLv2 in Lighttpd is much easier than in Apache. Toss the following line in your lighttpd.conf and you're good to go:

```
ssl.use-sslv2 = "disable"
```