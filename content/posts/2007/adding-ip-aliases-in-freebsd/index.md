---
aliases:
- /2007/08/08/adding-ip-aliases-in-freebsd/
author: Major Hayden
date: 2007-08-09 00:35:44
dsq_thread_id:
- 3642769069
tags:
- command line
title: Adding IP aliases in FreeBSD
---

One question I hear quite often is "how do I add IP aliases in FreeBSD?" It's not terribly intuitive, but you can follow these steps:

**Example:**

Server's primary IP: 192.168.1.5

Additional IP's to add: 192.168.1.10, 192.168.1.15, and 192.168.1.20

**Boot-time configuration:**

Add it to /etc/rc.conf first (so you don't forget). In this example, we have a Realtek card called rl0:

```
ifconfig_rl0="inet 192.168.1.5 netmask 255.255.255.0"
ifconfig_rl0_alias0="inet 192.168.1.10 netmask 255.255.255.0"
ifconfig_rl0_alias1="inet 192.168.1.15 netmask 255.255.255.0"
ifconfig_rl0_alias2="inet 192.168.1.20 netmask 255.255.255.0"
```

**UBER-IMPORTANT NOTE:** Start with the number 0 (zero) any time that you make IP alias configurations in /etc/rc.conf.

This is **BAD** form:

```
ifconfig_rl0="inet 192.168.1.5 netmask 255.255.255.0"
ifconfig_rl0_alias1="inet 192.168.1.10 netmask 255.255.255.0"
ifconfig_rl0_alias2="inet 192.168.1.15 netmask 255.255.255.0"
ifconfig_rl0_alias3="inet 192.168.1.20 netmask 255.255.255.0"
```

If you do it the wrong way (which means starting alias with anything but alias0), only the primary comes up. Keep that in mind.

**Bringing up the new IP's:**

You can do things the extraordinarily dangerous way:

```
# /etc/rc.network restart
```

Or, you can follow the recommended steps:

```
# ifconfig rl0 alias 192.168.1.10 netmask 255.255.255.0
# ifconfig rl0 alias 192.168.1.15 netmask 255.255.255.0
# ifconfig rl0 alias 192.168.1.20 netmask 255.255.255.0
```

**Test your work:**

Any good system administrator knows to test things once their configured. Make sure to ping your new IP's from a source on your network and outside your network (if possible/applicable).