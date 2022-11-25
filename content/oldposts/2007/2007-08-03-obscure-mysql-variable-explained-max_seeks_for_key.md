---
title: 'Obscure MySQL variable explained: max_seeks_for_key'
author: Major Hayden
date: 2007-08-03T22:01:33+00:00
url: /2007/08/03/obscure-mysql-variable-explained-max_seeks_for_key/
dsq_thread_id:
  - 3642769029
tags:
  - database

---
MySQL documentation can be awfully flaky - extremely verbose on issues that don't require such verbosity, and then extremely terse on issues that need a lot of explanation. The documentation for **max\_seeks\_for_key** matches the latter.

This is MySQL's own documentation:

> [7.2.16. How to Avoid Table Scans][1]

> Start mysqld with the -max-seeks-for-key=1000 option or use SET max\_seeks\_for_key=1000 to tell the optimizer to assume that no key scan causes more than 1,000 key seeks. [See Section 5.2.3, â€œSystem Variablesâ€][2].

> [5.2.3. System Variables][2]

> Limit the assumed maximum number of seeks when looking up rows based on a key. The MySQL optimizer assumes that no more than this number of key seeks are required when searching for matching rows in a table by scanning an index, regardless of the actual cardinality of the index (see [Section 13.5.4.13, "SHOW INDEX Syntax"][3]). By setting this to a low value (say, 100), you can force MySQL to prefer indexes instead of table scans.

Just in case you need a quick refresher on cardinality, here you go:

> [13.5.4.13. SHOW INDEX Syntax][3]

> **Cardinality**

> An estimate of the number of unique values in the index. This is updated by running ANALYZE TABLE or myisamchk -a. Cardinality is counted based on statistics stored as integers, so the value is not necessarily exact even for small tables. The higher the cardinality, the greater the chance that MySQL uses the index when doing joins.

Are you confused yet? If you're not confused, you are a tremedously awesome DBA (or you're a MySQL developer). Here's the break down:

Cardinality is the count of how many items in the index are unique. So, if you have 10 values in an indexed column, and the same two values are reused throughout, then the cardinality would be relatively low. A good example of this would be if you have country or state names in a database table. You're going to have repeats, so this means that your cardinality is low. A good example of high cardinality is when you have a column that is a primary key (or unique). In this case, every single row has a unique key in the column, and the cardinality should equal the number of rows.

How does this come into play with max\_seeks\_for_key? It's higly confusing based on the documentation, but lowering this variable actually makes MySQL prefer to use indexes - even if your cardinality is low - rather than using table scans. This can reduce total query time, iowait, and CPU usage. I'm not completely sure why MySQL doesn't default to this behavior since it's easy to see the performance gains.

By default, this variable is set to the largest number your system can handle. On 32-bit systems, this is 4,294,967,296. On 64-bit systems, this is 18,446,744,073,709,551,616. Some linux variants, like Gentoo Linux, are setting this value to 1,000 in the default configuration files. Reducing max\_seeks\_for_key to 1,000 is like telling MySQL that you want it to use indexes when the cardinality of the index is over 1,000. I've seen this variable reduced to as low as 1 on some servers without any issues.

I'm still utterly confused at why this variable is set so high by default. If anyone has any ideas, please send them my way!

 [1]: http://dev.mysql.com/doc/refman/5.0/en/how-to-avoid-table-scan.html
 [2]: http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html
 [3]: http://dev.mysql.com/doc/refman/5.0/en/show-index.html
