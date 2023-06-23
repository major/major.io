---
aliases:
- /2008/02/11/mysqltuner-v085-is-now-available/
author: Major Hayden
date: 2008-02-11 18:02:11
dsq_thread_id:
- 3678995904
tags:
- database
- mysql
- mysqltuner
title: MySQLTuner v0.8.5 is now available
---

To get the latest copy, head over to the [download page][1]! Here's the changes from 0.8.0 to 0.8.5 for MySQLTuner:

**Fixed a copy/paste bug**

There was a bug in 0.8.0 that displayed "OK" in red rather than showing "!!". It affected the informational "-" outputs as well. Thanks to Nils Breunese for pointing out that confusing bug!

**Fixed a data length calculation bug with MySQL 4.0**

If the script was run against MySQL 4.0 servers, it would return the Max\_data\_length rather than Data_length, and this was returning some horribly incorrect results for the size of tables in use with certain storage engines.

**Fixed a key buffer calculation bug with MySQL 4.0**

It's not possible to ask a MySQL 4.0 server about how much of the key buffer is in use, so the functionality for MySQL 4.0 now matches 3.23 for key buffer calculations.

**Added a notification for well-optimized servers**

For situations where MySQLTuner can't make any recommendations for performance increases, it actually says so now.

**Version bump to 0.8.5**

It's getting close to a full 1.0 release!

 [1]: http://mysqltuner.com/