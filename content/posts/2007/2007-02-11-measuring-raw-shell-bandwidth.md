---
title: Measuring raw shell bandwidth
author: Major Hayden
date: 2007-02-12T04:20:06+00:00
url: /2007/02/11/measuring-raw-shell-bandwidth/
dsq_thread_id:
  - 3642765296
tags:
  - command line

---
Okay, so we know it's easy to measure web, ftp and mail traffic, right? You can just parse the logs, sum it all up, and move on with your day. However, what do you do about users with SFTP or RSYNC privileges? This can create a problem when the bandwidth on your server keeps cranking up, but your web/ftp/mail traffic stats don't show an increase.

Need a solution? Enjoy:

First, create an OUTPUT rule for your user, which in this case will be root. Why no INPUT rule? Many hosts don't charge for incoming bandwidth, so why bother?

```
# iptables -A INPUT -j ACCEPT -m owner --uid-owner=root
```

Now check this out:

```
# /sbin/iptables -v -xL -Z
Chain OUTPUT (policy ACCEPT 1287 packets, 221983 bytes)
pkts      bytes target     prot opt in     out     source        destination
437    59684 ACCEPT     all  --  any    any     anywhere      anywhere  OWNER UID match root`
```

The number in the 'bytes' column is the count of bytes that this user sent out of your server since the last time you ran that iptables command. If you don't want to zero out the bytes each time you run the command, just drop the Z flag from the iptables command.

You can go wild with awk if you desire:

```
# /sbin/iptables -v -xL | grep root | awk '{ print $2 }'
59684
```
