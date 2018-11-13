---
title: MySQLTuner v0.9.0 is now available
author: Major Hayden
type: post
date: 2008-04-06T14:30:28+00:00
url: /2008/04/06/mysqltuner-v090-is-now-available/
dsq_thread_id:
  - 3642771114
tags:
  - database
  - mysql
  - mysqltuner

---
MySQLTuner v0.9.0 is [now available][1]. There is a bug fix and also a new feature!

**Fixed a bug in the enumeration/sizing of tables in MySQL 5**
  
In MySQL 5 on some distributions, a NULL is returned for the storage engine and data length. Luuk Vosslamber quickly e-mailed me about the bug yesterday and it has been fixed.

**MySQLTuner version checking**
  
MySQLTuner will now check to see if a new version is available when the script runs. You can disable the check with the `--skipversion` option if you do not wish to perform the check.

The version check does not submit any information about the server, the MySQL installation, or any of your MySQL data. It simply queries a page on mysqltuner.com with the version number of your currently running script. Based on the value returned by the page, MySQLTuner will alert you if a new version is available.

To download the new version right now, please go to the [project page][1] and use the download links.

 [1]: http://rackerhacker.com/mysqltuner/