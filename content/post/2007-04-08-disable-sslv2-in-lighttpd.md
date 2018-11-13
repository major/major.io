---
title: Disable SSLv2 in Lighttpd
author: Major Hayden
type: post
date: 2007-04-08T23:26:07+00:00
url: /2007/04/08/disable-sslv2-in-lighttpd/
dsq_thread_id:
  - 3676739093
categories:
  - Blog Posts
tags:
  - security
  - web

---
As with most things, turning off SSLv2 in Lighttpd is much easier than in Apache. Toss the following line in your lighttpd.conf and you're good to go:

```

