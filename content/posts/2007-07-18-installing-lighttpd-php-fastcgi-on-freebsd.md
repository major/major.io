---
title: Installing Lighttpd + PHP + FastCGI on FreeBSD
author: Major Hayden
type: post
date: 2007-07-18T15:12:06+00:00
url: /2007/07/18/installing-lighttpd-php-fastcgi-on-freebsd/
dsq_thread_id:
  - 3653853939
tags:
  - command line
  - web

---
With portinstall:

```
# portinstall lighttpd fcgi php5
```

Without portinstall:

```
# make -C /usr/ports/www/lighttpd all install clean
# make -C /usr/ports/www/fcgi all install clean
# make -C /usr/ports/lang/php5 all install clean
```

Add `lighttpd_enable="YES"` to /etc/rc.conf, and uncomment the usual items in /usr/local/etc/lighttpd.conf to enable fastcgi.
