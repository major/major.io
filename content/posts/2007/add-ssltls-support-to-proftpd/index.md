---
aliases:
- /2007/05/16/add-ssltls-support-to-proftpd/
author: Major Hayden
date: 2007-05-17 01:45:37
dsq_thread_id:
- 3660466517
tags:
- ftp
- security
title: Add SSL/TLS support to proftpd
---

To enable SSL/TLS support in proftpd, add the following to the proftpd.conf file:

```
<IfModule mod_tls.c>
    TLSEngine on
    TLSLog /var/ftpd/tls.log
    TLSRequired off
    TLSRSACertificateFile /usr/share/ssl/certs/server.crt
    TLSRSACertificateKeyFile /usr/share/ssl/private/server.key
    TLSCACertificateFile /usr/share/ssl/certs/cacert.crt
    TLSVerifyClient off
    TLSRenegotiate required off
</IfModule>
```

To **require** SSL/TLS on all connections, change `TLSRequired` to **on**. Of course, replace the certificate, key, and CA certificate (if applicable) to the correct files on your system.

Once you're all done, close your FTP connection and make a new one. There is no need to restart xinetd.