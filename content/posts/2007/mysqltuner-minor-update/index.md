---
aliases:
- /2007/09/06/mysqltuner-minor-update/
author: Major Hayden
date: 2007-09-07 01:41:14
tags:
- database
- development
title: MySQLTuner minor update
---

I rolled out a new [MySQLTuner][1] update tonight and made the following changes:

  * Added aborted connection checks
  * Added % reads/writes counts
  * Adjusted recommendations for slow query logging, max seeks per key, and joins without indexes
  * Added licensing data
  * Added props for Matthew Montgomery

Coming up soon is InnoDB support and additional per-thread buffer checks.

 [1]: http://rackerhacker.com/mysqltuner/