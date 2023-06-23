---
aliases:
- /2007/01/24/verify-that-sslv2-is-disabled/
author: Major Hayden
date: 2007-01-24 15:57:51
dsq_thread_id:
- 3642764816
tags:
- mail
- security
- web
title: Verify that SSLv2 is disabled
---

If you're looking to get PCI/CISP compliance, or you just like better security, disable SSL version 2. Here's how to check if it's enabled on your server:

Testing a web server:

```
openssl s_client -connect hostname:443 -ssl2
```

Testing an SMTP server:

```
openssl s_client -connect hostname:25 -starttls smtp -ssl2
```

If you get lines like these, SSLv2 is disabled:

```
419:error:1407F0E5:SSL routines:SSL2\_WRITE:ssl handshake failure:s2\_pkt.c:428:
420:error:1406D0B8:SSL routines:GET\_SERVER\_HELLO:no cipher list:s2_clnt.c:450:
```

If it shows the actual certificate installed, SSLv2 is enabled!