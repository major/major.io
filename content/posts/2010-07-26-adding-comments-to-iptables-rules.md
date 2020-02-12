---
title: Adding comments to iptables rules
author: Major Hayden
type: post
date: 2010-07-26T15:00:52+00:00
url: /2010/07/26/adding-comments-to-iptables-rules/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806200
categories:
  - Blog Posts
tags:
  - iptables
  - network
  - security
  - sysadmin

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
