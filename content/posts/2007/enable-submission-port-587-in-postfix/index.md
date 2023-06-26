---
aliases:
- /2007/07/04/enable-submission-port-587-in-postfix/
author: Major Hayden
date: 2007-07-05 00:29:36
tags:
- mail
- postfix
- submission
title: Enable submission port 587 in Postfix
---

Enabling submission port support for Postfix is really easy. To have postfix listen on both 25 and 587, be sure that the line starting with **submission** is uncommented in /etc/postfix/master.cf:

```
smtp      inet  n       -       n       -       -       smtpd
submission inet n      -       n       -       -       smtpd
```