---
title: 'MySQL: The total number of locks exceeds the lock table size'
author: Major Hayden
type: post
date: 2010-02-16T18:00:29+00:00
url: /2010/02/16/mysql-the-total-number-of-locks-exceeds-the-lock-table-size-2/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805988
categories:
  - Blog Posts
tags:
  - configuration
  - database
  - innodb
  - memory
  - mysql
  - optimization

---
If you're running an operation on a large number of rows within a table that uses the InnoDB storage engine, you might see this error:

`ERROR 1206 (HY000): The total number of locks exceeds the lock table size`

MySQL is trying to tell you that it doesn't have enough room to store all of the row locks that it would need to execute your query. The only way to fix it for sure is to adjust `innodb_buffer_pool_size` and restart MySQL. By default, this is set to only 8MB, which is too small for anyone who is using InnoDB to do anything.

**If you need a temporary workaround,** reduce the amount of rows you're manipulating in one query. For example, if you need to delete a million rows from a table, try to delete the records in chunks of 50,000 or 100,000 rows. If you're inserting many rows, try to insert portions of the data at a single time.

Further reading:

  * [MySQL Bug #15667 - The total number of locks exceeds the lock table size][1]
  * [MySQL Error 1206 &raquo; Mike R's Blog][2]

 [1]: http://bugs.mysql.com/bug.php?id=15667
 [2]: http://mrothouse.wordpress.com/2006/10/20/mysql-error-1206/
