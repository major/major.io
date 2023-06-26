---
aliases:
- /2007/02/09/delete-single-iptables-rules/
author: Major Hayden
date: 2007-02-09 19:03:18
tags:
- command line
- security
title: Delete single iptables rules
---

You can delete them based on what they're doing:

```
iptables -D INPUT -s 127.0.0.1 -p tcp --dport 111 -j ACCEPT
```

Or you can delete them based on their number and chain name:

```
iptables -D INPUT 4
```