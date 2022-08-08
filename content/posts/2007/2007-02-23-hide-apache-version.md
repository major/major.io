---
title: Hide Apache Version
author: Major Hayden
date: 2007-02-23T21:07:48+00:00
url: /2007/02/23/hide-apache-version/
dsq_thread_id:
  - 3679065452
tags:
  - security
  - web

---
If you want to hide the current version of Apache and your OS, just replace

`ServerTokens OS`

with

`ServerTokens Prod`

and restart Apache.