---
title: MySQLTuner v0.8.9 is now available
author: Major Hayden
date: 2008-04-05T16:03:14+00:00
url: /2008/04/05/mysqltuner-v089-is-now-available/
dsq_thread_id:
  - 3678992108
tags:
  - database
  - mysql
  - mysqltuner

---
MySQLTuner v0.8.9 is [now available][1].  There are a few bug fixes, performance improvements, and readability adjustments.

**Table enumeration and sizing can now be skipped**

I've received reports that MySQLTuner will stall while enumerating tables on servers that contain a lot of tables or a lot of large tables.  You can now use the `--skipsize` option to skip over the table enumeration process and let the script finish.  However, you will not be able to receive some recommendations since the script was unable to determine which storage engines are enabled.

**New table enumeration and sizing method for MySQL 5**

The script now uses information_schema to enumerate tables and their sizes for MySQL 5 servers.  This has provided a drastic improvement in performance.

**Readability improvements**

The recommendations for query\_cache\_limit and max\_heap\_table\_size/tmp\_table_size have been improved.

As always, I welcome your suggestions, bug reports, and questions!  Please feel free to drop a comment on this blog posting or send me an e-mail (it's in the script).  Also, don't forget to [sign up for the MySQLTuner version announcement list][2].

 [1]: http://rackerhacker.com/mysqltuner/ "MySQLTuner v0.8.9"
 [2]: http://rackerhacker.com/mysqltuner/ "MySQLTuner Mailing List"
