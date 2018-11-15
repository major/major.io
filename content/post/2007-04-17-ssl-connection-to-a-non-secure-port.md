---
title: SSL connection to a non-secure port
author: Major Hayden
type: post
date: 2007-04-17T22:27:12+00:00
url: /2007/04/17/ssl-connection-to-a-non-secure-port/
dsq_thread_id:
  - 3645464360
tags:
  - security
  - web

---
If you have weird SSL errors and this one appears, you are trying to speak SSL to a daemon that doesn't understand it:

```
$ openssl s_client -connect 222.222.222.222:443
CONNECTED(00000003)
5057:error:140770FC:SSL routines:SSL23_GET_SERVER_HELLO:unknown protocol:s23_clnt.c:567:
```

If you get this with Apache, be sure that you have `SSLEngine On` in the applicable VirtualHost and be sure that mod_ssl is being loaded.
