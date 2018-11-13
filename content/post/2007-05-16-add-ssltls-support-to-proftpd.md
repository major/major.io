---
title: Add SSL/TLS support to proftpd
author: Major Hayden
type: post
date: 2007-05-17T01:45:37+00:00
url: /2007/05/16/add-ssltls-support-to-proftpd/
dsq_thread_id:
  - 3660466517
tags:
  - ftp
  - security

---
To enable SSL/TLS support in proftpd, add the following to the proftpd.conf file:

<pre>&lt;IfModule mod_tls.c&gt;
    TLSEngine on
    TLSLog /var/ftpd/tls.log
    TLSRequired off
    TLSRSACertificateFile /usr/share/ssl/certs/server.crt
    TLSRSACertificateKeyFile /usr/share/ssl/private/server.key
    TLSCACertificateFile /usr/share/ssl/certs/cacert.crt
    TLSVerifyClient off
    TLSRenegotiate required off
&lt;/IfModule&gt;</pre>

To **require** SSL/TLS on all connections, change `TLSRequired` to **on**. Of course, replace the certificate, key, and CA certificate (if applicable) to the correct files on your system.

Once you're all done, close your FTP connection and make a new one. There is no need to restart xinetd.
