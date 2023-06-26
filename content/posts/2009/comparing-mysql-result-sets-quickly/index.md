---
aliases:
- /2009/05/05/comparing-mysql-result-sets-quickly/
author: Major Hayden
date: 2009-05-05 15:51:09
title: Comparing MySQL result sets quickly
---

I found a really helpful tip on [Xaprb][1] for comparing result sets in MySQL:

<pre lang="html">mysql> pager md5sum -
PAGER set to 'md5sum -'
mysql> select * from test;
a09bc56ac9aa0cbcc659c3d566c2c7e4  -
4096 rows in set (0.00 sec)</pre>

It's a quick way to determine if you have two tables that are properly in sync. Although there are [better ways][2] to compare tables in replicated environments, this method can get it done pretty quickly.

 [1]: http://www.xaprb.com/blog/2009/03/25/mysql-command-line-tip-compare-result-sets/
 [2]: http://www.maatkit.org/doc/mk-table-checksum.html