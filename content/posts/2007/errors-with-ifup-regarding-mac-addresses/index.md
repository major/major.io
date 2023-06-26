---
aliases:
- /2007/05/27/errors-with-ifup-regarding-mac-addresses/
author: Major Hayden
date: 2007-05-27 16:44:55
tags:
- command line
title: Errors with ifup regarding MAC addresses
---

If Redhat, CentOS, Fedora, or any other similar OS provides the following error:

```
# ifup eth1
Device eth1 has different MAC address than expected, ignoring.
```

Check that someone didn't put an IP in as a hardware address:

```
DEVICE=eth1
HWADDR=10.240.11.100
NETMASK=255.255.224.0
ONBOOT=yes
TYPE=Ethernet
```

If they did, then fix it with the correct configuration directive:

```
DEVICE=eth1
IPADDR=10.240.11.100
NETMASK=255.255.224.0
ONBOOT=yes
TYPE=Ethernet
```