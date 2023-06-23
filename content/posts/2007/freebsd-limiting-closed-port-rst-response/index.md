---
aliases:
- /2007/06/06/freebsd-limiting-closed-port-rst-response/
author: Major Hayden
date: 2007-06-07 04:42:13
dsq_thread_id:
- 3642767754
tags:
- command line
- security
title: 'FreeBSD: Limiting closed port RST response'
---

One of the nifty things about FreeBSD's kernel is that it will limit closed port RST responses, which, in layman's terms, just means that if someone repeatedly hits a port that's closed, the kernel won't respond to all of the requests.

You generally get something like this in the system log:

```
kernel: Limiting closed port RST response from 211 to 200 packets/sec
kernel: Limiting closed port RST response from203 to 200 packets/sec
```

In certain situations, this functionality might be undesirable. For example, if you're running an IDS like snort or a vulnerability scanner like nessus, these responses might be helpful. If you want to disable this functionality, just add the following to `/etc/sysctl.conf`:

```
net.inet.tcp.blackhole=2
net.inet.udp.blackhole=1
```