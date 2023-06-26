---
aliases:
- /2007/07/01/active-ftp-connections-through-iptables/
author: Major Hayden
date: 2007-07-01 16:42:01
tags:
- command line
- security
title: Active FTP connections through iptables
---

One of the main reasons people like passive FTP is that it's easier to get through firewalls with it. However, some users might now know that they need to enable passive FTP, or they may have incapable clients. To get active FTP through firewalls, start by adding these rules:

Allowing established and related connections is generally a good idea:

```
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
```

Inbound connections on port 21 are required:

```
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
```

Just to cover our bases, add in a rule to allow established and related traffic leaving port 20 on the client's machine:

```
iptables -A INPUT -p tcp --sport 20 -m state --state ESTABLISHED,RELATED -j ACCEPT
```

Now, you have everything you need to allow the connections, but iptables will need to be able to mark and track these connections to allow them to pass properly. That is done with the ip\_conntrack\_ftp kernel module. To test things out, run this:

```
modprobe ip_conntrack_ftp
```

At this point, you should be able to connect without a problem. However, to keep this module loaded whenever iptables is running, you will need to add it to /etc/sysconfig/iptables-config:

```
IPTABLES_MODULES="ip_conntrack_ftp"
```