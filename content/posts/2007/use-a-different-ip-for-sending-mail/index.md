---
aliases:
- /2007/08/27/use-a-different-ip-for-sending-mail/
author: Major Hayden
date: 2007-08-28 03:13:21
tags:
- command line
- mail
title: Use a different IP for sending mail
---

If you find yourself in a pinch and you need a temporary fix when your primary IP is blacklisted, use the following iptables rule:

```
/sbin/iptables -t nat -A POSTROUTING -p tcp --dport 25 -j SNAT --to-source [desired outgoing ip]
```

Keep in mind, however, that you will need to adjust any applicable SPF records for your domains since your e-mail will appear to be leaving via one of the secondary IP's on your server. Also, remember that this is only a temporary fix - you should find out why you were blacklisted and eliminate that problem as soon as possible. :-)