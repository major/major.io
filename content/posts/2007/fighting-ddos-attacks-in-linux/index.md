---
aliases:
- /2007/02/07/fighting-ddos-attacks-in-linux/
author: Major Hayden
date: 2007-02-07 13:45:43
tags:
- command line
- security
title: Fighting DDOS attacks in Linux
---

Check for a SYN flood:

```
# netstat -alnp | grep :80 | grep SYN_RECV -c 1024
```

Adjust network variables accordingly:

```
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout
echo 1800 >/proc/sys/net/ipv4/tcp_keepalive_time
echo 0 >/proc/sys/net/ipv4/tcp_window_scaling
echo 0 >/proc/sys/net/ipv4/tcp_sack
echo 0 >/proc/sys/net/ipv4/tcp_timestamps
```