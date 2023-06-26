---
aktt_notify_twitter:
- false
aliases:
- /2010/07/26/adding-comments-to-iptables-rules/
author: Major Hayden
date: 2010-07-26 15:00:52
tags:
- iptables
- network
- security
- sysadmin
title: Adding comments to iptables rules
---

After I wrote a recent post on [best practices for iptables][1], I noticed that I forgot to mention comments for iptables rules. They can be extremely handy if you have some obscure rules for odd situations.

To make an iptables rule with a comment, simply add on the following arguments to the rule:

```
-m comment --comment "limit ssh access"
```

Depending on your distribution, you may need to load the `ipt_comment` or `xt_comment` modules into your running kernel first.

A full iptables rule to limit ssh access would look something like this:

```
iptables -A INPUT -j DROP -p tcp --dport 22 -m comment --comment "limit ssh access"
```

 [1]: http://rackerhacker.com/2010/04/12/best-practices-iptables/