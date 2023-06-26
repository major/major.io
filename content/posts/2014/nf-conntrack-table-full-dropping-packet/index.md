---
aliases:
- /2014/01/07/nf-conntrack-table-full-dropping-packet/
author: Major Hayden
date: 2014-01-07 20:22:01
title: 'nf_conntrack: table full, dropping packet'
---

I was doing some testing with apachebench and received some peculiar results:

```
[608487.317284] nf_conntrack: table full, dropping packet
[608487.708916] nf_conntrack: table full, dropping packet
[608488.010236] nf_conntrack: table full, dropping packet
```

I've [seen this problem before][1] and I tried to fix it by adjusting /proc/sys/net/ipv4/ip\_conntrack\_max as I did back in 2008. However, Fedora 20 doesn't have the same structure in /proc under kernel 3.12.

The fix is to adjust /proc/sys/net/netfilter/nf\_conntrack\_max instead:

```
echo 256000 > /proc/sys/net/netfilter/nf_conntrack_max
```

After a quick test, apachebench was back to normal. You can make the change permanent and test it with:

```
echo "net.netfilter.nf_conntrack_max = 256000" >> /etc/sysctl.conf
sysctl -p
```

There are some handy connection tracking tools available in the conntrack-tools package. Take a look at the man page for conntrack and you'll find ways to review and flush the connection tracking table.

 [1]: /2008/01/24/ip_conntrack-table-full-dropping-packet/