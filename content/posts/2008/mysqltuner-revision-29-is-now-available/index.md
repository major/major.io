---
aliases:
- /2008/01/15/mysqltuner-revision-29-is-now-available/
author: Major Hayden
date: 2008-01-16 04:13:12
tags:
- database
- development
- mysql
- mysqltuner
title: MySQLTuner Revision 29 is now available
---

A new version of MySQLTuner was released tonight to correct some bugs found within revision 26. As usual, you can [get a new copy][1] from the [MySQLTuner site][2].

Here are the new features:

**&raquo; Storage engine counts are shown**

In addition to the actual size of the tables stored under each storage engine, there is a table count as well. The table count reflects the number of tables that exist on the server which use the specified storage engine.

**&raquo; Minor changes**

  * Reduced overall code size
  * Optimized subroutines to use fewer system calls and math computations
  * Added storage engine disabling recommendations to the bottom of the output

**&raquo; Bugs fixed**

  * Fixed an issue that caused incorrect statistics for storage engines with MySQL 3.23
  * Corrected a logic bug that displayed odd storage engine statistics calculations

 [1]: http://mysqltuner.com/mysqltuner.pl
 [2]: http://mysqltuner.com/