---
title: 'BIND: ‘RRset exists (value dependent)’ prerequisite not satisfied (NXRRSET)'
author: Major Hayden
type: post
date: 2007-10-10T18:13:22+00:00
url: /2007/10/10/bind-rrset-exists-value-dependent-prerequisite-not-satisfied-nxrrset/
dsq_thread_id:
  - 3644940448
tags:
  - bind
  - security

---
I was recently working on a server where a user on the server was concerned with these log messages:

```
Oct 7 20:59:33 web named[13698]: client 111.222.333.444#50389: updating zone 'domain.com/IN': update failed: 'RRset exists (value dependent)' prerequisite not satisfied (NXRRSET)
Oct 7 20:59:34 web named[13698]: client 111.222.333.444#50392: update 'domain.com/IN' denied
Oct 7 21:59:35 web named[13698]: client 111.222.333.444#50422: updating zone 'domain.com/IN': update failed: 'RRset exists (value dependent)' prerequisite not satisfied (NXRRSET)
Oct 7 21:59:35 web named[13698]: client 111.222.333.444#50425: update 'domain.com/IN' denied
Oct 7 22:59:20 web named[13698]: client 111.222.333.444#50458: updating zone 'domain.com/IN': update failed: 'RRset exists (value dependent)' prerequisite not satisfied (NXRRSET)
```

The messages here are actually showing that named is doing its job well. Some user was attempting to dynamically update a DNS zone repeatedly, but named was rejecting the updates since they were not coming from a valid sources.

Further reading:

[Zytrax.com: DNS BIND Zone Transfers and Updates][1]

[Internet Systems Consortium: Dynamic Updates][2]

 [1]: http://www.zytrax.com/books/dns/ch7/xfer.html#allow-update
 [2]: http://www.isc.org/sw/bind/arm95/BvARM-all.html#dynamic_update
