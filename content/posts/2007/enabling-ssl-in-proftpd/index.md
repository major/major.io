---
aliases:
- /2007/02/08/enabling-ssl-in-proftpd/
author: Major Hayden
date: 2007-02-08 23:28:18
dsq_thread_id:
- 3679068279
tags:
- ftp
- plesk
title: Enabling SSL in ProFTPD
---

If you need to enable SSL in ProFTPD, try this out:

```
<IfModule mod_tls.c>
    TLSEngine on
    TLSRequired off
    TLSRSACertificateFile /etc/httpd/conf/ssl.crt/server.crt
    TLSRSACertificateKeyFile /etc/httpd/conf/ssl.key/server.key
    TLSVerifyClient off
</IfModule>
```