---
title: Enable submission port 587 in Postfix
author: Major Hayden
date: 2007-07-05T00:29:36+00:00
url: /2007/07/04/enable-submission-port-587-in-postfix/
dsq_thread_id:
  - 3642768522
tags:
  - mail
  - postfix
  - submission

---
Enabling submission port support for Postfix is really easy. To have postfix listen on both 25 and 587, be sure that the line starting with **submission** is uncommented in /etc/postfix/master.cf:

```
smtp      inet  n       -       n       -       -       smtpd
submission inet n      -       n       -       -       smtpd
```
