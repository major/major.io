---
title: Delete single iptables rules
author: Major Hayden
type: post
date: 2007-02-09T19:03:18+00:00
url: /2007/02/09/delete-single-iptables-rules/
dsq_thread_id:
  - 3642765103
categories:
  - Blog Posts
tags:
  - command line
  - security

---
You can delete them based on what they're doing:

```
iptables -D INPUT -s 127.0.0.1 -p tcp --dport 111 -j ACCEPT
```

Or you can delete them based on their number and chain name:

```
iptables -D INPUT 4
```
