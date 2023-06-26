---
aliases:
- /2008/06/18/mysqltuner-v091-is-now-available/
author: Major Hayden
date: 2008-06-19 02:53:58
tags:
- database
- mysql
- mysqltuner
title: MySQLTuner v0.9.1 is now available
---

MySQLTuner v0.9.1 is [now available][1]! This long-awaited update includes bug fixes, feature enhancements, and compatibility improvements.

**MySQLTuner now checks for fragmented tables**

When deletes or updates are made on tables, MySQL will often leave holes behind that it hopes to fill in later. If the size and quantity keep climbing, the holes can cause performance degradation for writes and reads. Fragmentation can be corrected with `OPTIMIZE TABLE`, and the script recommends it if needed.

**Fixed a bug where zero-length passwords cause authentication to repeat**

The script will now allow you to have a zero-length password, and it won't re-prompt for the password over and over again.

**Fixed a wget 1.11 timestamp bug**

This can cause the version check to fail if the .wgetrc has timestamps enabled.

**Corrected a math error in the temporary table calculation**

The script should now be able to more accurately determine the relative quantity of temporary tables created on disk.

**Fixed an error when the status variable `Open_tables` returned zero**

The divide by zero error has been corrected.

**Added table cache changes in preparation for MySQL 6**

It's still in the early stages, but MySQLTuner should have full support for MySQL 6 by the time it reaches RC status.

**Thanks for the contributions!**

This update would not have been possible without help from Ville Skytta, Trent Hornibrook and Luuk Vosslamber.

To download the latest copy, visit the [MySQLTuner page][1].

 [1]: http://rackerhacker.com/mysqltuner/