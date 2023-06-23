---
aliases:
- /2007/07/01/mysql-time-zone-different-from-system-time-zone/
author: Major Hayden
date: 2007-07-01 16:29:11
dsq_thread_id:
- 3642768403
tags:
- database
title: MySQL time zone different from system time zone
---

In some situations, the system time zone will be different than the one in MySQL, even though MySQL is set to use the system time zone. This normally means that a user has changed the system time zone, but they haven't started MySQL to cause it to change as well.

<pre>$ date
Sun Jul  1 11:32:56 CDT 2007
mysql> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | PDT    |
| time_zone        | SYSTEM |
+------------------+--------+
2 rows in set (0.00 sec)</pre>

If you find yourself in this situation, just restart MySQL and the situation should be fixed:

<pre>mysql> show variables like '%time_zone%';
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | CDT    |
| time_zone        | SYSTEM |
+------------------+--------+
2 rows in set (0.00 sec)</pre>