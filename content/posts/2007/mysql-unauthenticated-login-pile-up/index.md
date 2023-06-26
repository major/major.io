---
aliases:
- /2007/08/16/mysql-unauthenticated-login-pile-up/
author: Major Hayden
date: 2007-08-16 12:14:21
tags:
- database
title: MySQL unauthenticated login pile-up
---

Sometimes MySQL's process list will fill with unauthenticated login entries that look like this:

```
|  971 | unauthenticated user | xxx.xxx.xxx.xxx:35406 | NULL        | Connect | NULL | login | NULL             |
```

Generally, this means one of two things are happening. First, this could be a brute force attack against your server from an external attacker. Be sure to firewall off access to port 3306 from the outside world or run MySQL with `skip-networking` in the /etc/my.cnf file, and that should curtail those login attempts quickly.

However, MySQL could be attempting to resolve the reverse DNS for each connection, and this definitely isn't necessary if your grant statements refer to remote machines' IP addresses rather than hostnames (as they should). In this case, add `skip-name-resolve` to your /etc/my.cnf and restart MySQL. These connection attempts should authenticate much faster, and they shouldn't pile up in the queue any longer.

**Note:** Connections via sockets aren't affected by DNS resolution since sockets don't involve any networking access at all. If your web applications use 'localhost' for their connection string, then MySQL won't bring DNS resolution into play whatsoever.

Recommended reading: [6.5.9. How MySQL Uses DNS][1]

 [1]: http://dev.mysql.com/doc/refman/5.0/en/dns.html