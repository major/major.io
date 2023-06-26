---
aliases:
- /2008/03/11/hunting-down-elusive-sources-of-iowait/
author: Major Hayden
date: 2008-03-11 18:00:18
tags:
- iowait
- performance
title: Hunting down elusive sources of iowait
---

A question I'm asked daily is &#8220;How can I find out what is generating iowait on my server?&#8221; Sure, you can dig through pages of lsof output, restart services, or run strace, but it can be a frustrating process. I saw a process on [this blog post][1], and I changed the regexes to fit Red Hat and CentOS systems a bit better:

```
# /etc/init.d/syslog stop
# echo 1 > /proc/sys/vm/block_dump
# dmesg | egrep "READ|WRITE|dirtied" | egrep -o '([a-zA-Z]*)' | sort | uniq -c | sort -rn | head
   1526 mysqld
    819 httpd
    429 kjournald
     35 qmail
     27 in
      7 imapd
      6 irqbalance
      5 pop
      4 pdflush
      3 spamc
```

In my specific situation, it looks like MySQL is the biggest abuser of my disk, followed by Apache and the filesystem journaling. As expected, qmail is a large contender, too.

**Don't forget to set things back to their normal state when you're done!**

```
# echo 0 > /proc/sys/vm/block_dump
# /etc/init.d/syslog start
```

 [1]: http://blog.eikke.com/index.php/ikke/2007/03/22/who_s_abusing_my_sata_controller