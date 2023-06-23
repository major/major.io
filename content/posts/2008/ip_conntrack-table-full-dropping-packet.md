---
aliases:
- /2008/01/24/ip_conntrack-table-full-dropping-packet/
author: Major Hayden
date: 2008-01-24 18:26:40
dsq_thread_id:
- 3642773011
tags:
- command line
- iptables
- kernel
title: 'ip_conntrack: table full, dropping packet'
---

**Using Linux kernel 3.12 or later?** See [this updated post][1] instead.

* * *

Last week, I found myself with a server under low load, but it couldn't make or receive network connections. When I ran `dmesg`, I found the following line repeating over and over:

<pre lang="html">ip_conntrack: table full, dropping packet</pre>

I'd seen this message before, but I headed over to [Red Hat's site][2] for more details. It turns out that the server was running iptables, but it was under a very heavy load and also handling a high volume of network connections. Generally, the ip\_conntrack\_max is set to the total MB of RAM installed multiplied by 16. However, this server had 4GB of RAM, but ip\_conntrack\_max was set to 65536:

<pre lang="html"># cat /proc/sys/net/ipv4/ip_conntrack_max
65536</pre>

I logged into another server with 1GB of RAM (RHES 5, 32-bit) and another with 2GB of RAM (RHES 4, 64-bit), and both had ip\_conntrack\_max set to 65536. I'm not sure if this is a known Red Hat issue, or if it's just set to a standard value out of the box.

If you want to check your server's current tracked connections, just run the following:

<pre lang="html"># cat /proc/sys/net/ipv4/netfilter/ip_conntrack_count</pre>

If you want to adjust it (as I did), just run the following as root:

<pre lang="html"># echo 131072 > /proc/sys/net/ipv4/ip_conntrack_max</pre>

 [1]: https://major.io/2014/01/07/nf-conntrack-table-full-dropping-packet/
 [2]: http://kbase.redhat.com/faq/FAQ_45_11238.shtm