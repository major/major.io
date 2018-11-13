---
title: Enable SSL support in Postfix
author: Major Hayden
type: post
date: 2007-07-01T16:31:01+00:00
url: /2007/07/01/enable-ssl-support-in-postfix/
dsq_thread_id:
  - 3644443771
tags:
  - mail
  - security

---
If you have postfix installed with OpenSSL support compiled in, you can enable SSL connections by editing two configuration files. First, add the following to /etc/postfix/main.cf:

`smtpd_use_tls = yes<br />
#smtpd_tls_auth_only = yes<br />
smtpd_tls_key_file = /etc/postfix/newkey.pem<br />
smtpd_tls_cert_file = /etc/postfix/newcert.pem<br />
smtpd_tls_CAfile = /etc/postfix/cacert.pem<br />
smtpd_tls_loglevel = 3<br />
smtpd_tls_received_header = yes<br />
smtpd_tls_session_cache_timeout = 3600s<br />
tls_random_source = dev:/dev/urandom`

Then, simply uncomment this line in /etc/postfix/master.cf:

<pre>smtps     inet  n       -       n       -       -       smtpd</pre>

Make sure to keep tabs between the elements in the master.cf file.