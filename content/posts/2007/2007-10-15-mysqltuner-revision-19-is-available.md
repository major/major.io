---
title: MySQLTuner Revision 19 is available
author: Major Hayden
date: 2007-10-16T01:54:34+00:00
url: /2007/10/15/mysqltuner-revision-19-is-available/
dsq_thread_id:
  - 3642770476
tags:
  - database
  - development
  - mysql
  - mysqltuner

---
I've revamped a few of the recommendations in MySQLTuner, and revision 19 is now available tonight! Here's the main changes:

* Adjusted infoprint to use asterisks (cosmetic)

* Per-thread/global buffer counts are now displayed

* Key buffer increases are only recommended if the buffer is smaller than total indexes and hit rate is < 95% \* Dropped max\_seeks\_for_key checks \* Temporary table size increases are not recommended over 256M * Aborted connection calculation and recommendation adjustments You can download the latest copy on the [MySQLTuner page][1], and you can [get diffs for the new version][2] as well.

 [1]: http://rackerhacker.com/mysqltuner/
 [2]: http://tools.assembla.com/mysqltuner/
