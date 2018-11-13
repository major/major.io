---
title: Fighting DDOS attacks in Linux
author: Major Hayden
type: post
date: 2007-02-07T13:45:43+00:00
url: /2007/02/07/fighting-ddos-attacks-in-linux/
dsq_thread_id:
  - 3658454187
tags:
  - command line
  - security

---
Check for a SYN flood:

`# netstat -alnp | grep :80 | grep SYN_RECV -c 1024`

Adjust network variables accordingly:

`echo 1 > /proc/sys/net/ipv4/tcp_syncookies<br />
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout<br />
echo 1800 >/proc/sys/net/ipv4/tcp_keepalive_time<br />
echo 0 >/proc/sys/net/ipv4/tcp_window_scaling<br />
echo 0 >/proc/sys/net/ipv4/tcp_sack<br />
echo 0 >/proc/sys/net/ipv4/tcp_timestamps`