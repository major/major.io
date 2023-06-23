---
aliases:
- /2007/08/02/generate-self-signed-certificate-and-key-in-one-line/
author: Major Hayden
date: 2007-08-03 02:48:25
dsq_thread_id:
- 3642768896
tags:
- web
title: Generate self-signed certificate and key in one line
---

If you need a quick self-signed certificate, you can generate the key/certificate pair, then sign it, all with one openssl line:

```
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt
```