---
title: MySQLTuner Revision 22 is now available
author: Major Hayden
type: post
date: 2007-12-03T18:09:32+00:00
url: /2007/12/03/mysqltuner-revision-22-is-now-available/
dsq_thread_id:
  - 3642773328
tags:
  - database
  - development
  - mysql
  - mysqltuner

---
MySQLTuner revision 22 is available today. Here's some of the notable fixes and changes:

**&raquo; Changed how indexes are calculated on MySQL 5**

Thanks to Jon Hinds, I found that when running the tuning script against MySQL 5, the following SQL statement caused MySQL to open **all** of the tables on the server, which of course caused the table cache hit rate to plummet each time the script is run:

`SELECT SUM(INDEX_LENGTH) from information_schema.TABLES where ENGINE='MyISAM'`

The script now calculates index size using `du` operations for all MySQL versions.

**&raquo; Added checks for innodb\_log\_file_size**

I'm working in some InnoDB support, and the script now checks to see whether the innodb\_log\_file\_size is 25% (+/- 5%) of your innodb\_buffer\_pool\_size.

**&raquo; Added checks for 32-bit and 64-bit architectures**

The script now determines if you have a 32-bit system with less than 2GB of RAM. You'll get a polite suggestion to move to a 64-bit OS so that MySQL can allocate more than 2GB of RAM safely. Also, if your maximum possible memory usage is over 2GB on a 32-bit system, you'll get a warning about stability issues. (Allocating more than 2GB on a 32-bit system can cause thread thrashing and a system crash.)

**&raquo; Fixed a bug in the recommendations for temporary tables**

I had a pretty ugly math error, and it's fixed now. You will see recommendations for increasing the size of the max\_heap\_table and tmp\_table\_size buffers as long as they are not at 256MB already.

**&raquo; Fixed thread cache recommendations and warnings**

If your thread cache is set to 0, you now receive a warning about a disabled thread cache. Also, a separate recommendation is made in that situation. If your thread cache is set too low, but still enabled, a separate recommendation will appear.

**&raquo; Internal changes**

Some of the commented lines are switched around a bit, and some of the arrays have been consolidated to speed up the script a bit more.

**Ready to download the script?** Go to [http://mysqltuner.com/][1] and get it for free.

 [1]: http://mysqltuner.com
