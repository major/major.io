---
title: Errors with ifup regarding MAC addresses
author: Major Hayden
type: post
date: 2007-05-27T16:44:55+00:00
url: /2007/05/27/errors-with-ifup-regarding-mac-addresses/
dsq_thread_id:
  - 3648198985
tags:
  - command line

---
If Redhat, CentOS, Fedora, or any other similar OS provides the following error:

`# ifup eth1<br />
Device eth1 has different MAC address than expected, ignoring.`

Check that someone didn't put an IP in as a hardware address:

`DEVICE=eth1<br />
HWADDR=10.240.11.100<br />
NETMASK=255.255.224.0<br />
ONBOOT=yes<br />
TYPE=Ethernet`

If they did, then fix it with the correct configuration directive:

`DEVICE=eth1<br />
IPADDR=10.240.11.100<br />
NETMASK=255.255.224.0<br />
ONBOOT=yes<br />
TYPE=Ethernet`
