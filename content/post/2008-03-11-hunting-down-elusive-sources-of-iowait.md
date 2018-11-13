---
title: Hunting down elusive sources of iowait
author: Major Hayden
type: post
date: 2008-03-11T18:00:18+00:00
url: /2008/03/11/hunting-down-elusive-sources-of-iowait/
dsq_thread_id:
  - 3642772707
tags:
  - iowait
  - performance

---
A question I'm asked daily is "How can I find out what is generating iowait on my server?" Sure, you can dig through pages of lsof output, restart services, or run strace, but it can be a frustrating process. I saw a process on [this blog post][1], and I changed the regexes to fit Red Hat and CentOS systems a bit better:

`# /etc/init.d/syslog stop<br />
# echo 1 > /proc/sys/vm/block_dump<br />
# dmesg | egrep "READ|WRITE|dirtied" | egrep -o '([a-zA-Z]*)' | sort | uniq -c | sort -rn | head<br />
   1526 mysqld<br />
    819 httpd<br />
    429 kjournald<br />
     35 qmail<br />
     27 in<br />
      7 imapd<br />
      6 irqbalance<br />
      5 pop<br />
      4 pdflush<br />
      3 spamc`

In my specific situation, it looks like MySQL is the biggest abuser of my disk, followed by Apache and the filesystem journaling. As expected, qmail is a large contender, too.

**Don't forget to set things back to their normal state when you're done!**

`# echo 0 > /proc/sys/vm/block_dump<br />
# /etc/init.d/syslog start`

 [1]: http://blog.eikke.com/index.php/ikke/2007/03/22/who_s_abusing_my_sata_controller
