---
title: Using GNU sort to sort a list by IP address
author: Major Hayden
date: 2011-01-06T13:52:58+00:00
url: /2011/01/06/using-gnu-sort-to-sort-a-list-by-ip-address/
dsq_thread_id:
  - 3648600041
tags:
  - command line
  - linux
  - sysadmin

---
My [daily work][1] requires me to work with a lot of customer data and much of it involves IP address allocations. If you find that you need to sort a list by IP address with GNU sort on a Linux server, just use these handy arguments for sort:

```
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 somefile.txt
```

_For this to work, the file you're sorting needs to have the IP address as the first item on each line._

 [1]: http://rackspace.com/
