---
title: Disable SSLv2 and Weak Ciphers in Postfix
author: Major Hayden
type: post
date: 2007-03-08T15:04:54+00:00
url: /2007/03/08/disable-sslv2-and-weak-ciphers-in-postfix/
dsq_thread_id:
  - 3642765725
tags:
  - mail
  - security

---
Enable these two options to disable SSLv2 and also disable ciphers which are less than 128-bit:

`smtpd_tls_mandatory_protocols = SSLv3, TLSv1<br />
smtpd_tls_mandatory_ciphers = medium, high`