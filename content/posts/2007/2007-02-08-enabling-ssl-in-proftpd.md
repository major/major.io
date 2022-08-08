---
title: Enabling SSL in ProFTPD
author: Major Hayden
date: 2007-02-08T23:28:18+00:00
url: /2007/02/08/enabling-ssl-in-proftpd/
dsq_thread_id:
  - 3679068279
tags:
  - ftp
  - plesk

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
