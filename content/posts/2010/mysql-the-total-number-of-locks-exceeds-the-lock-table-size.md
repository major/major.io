---
aliases:
- /2010/01/29/mysql-the-total-number-of-locks-exceeds-the-lock-table-size/
author: Major Hayden
date: 2010-01-29 13:12:21
dsq_thread_id:
- 3645404822
tags:
- command line
- database
- innodb
- memory
- mysql
title: 'MySQL: The total number of locks exceeds the lock table size'
---

This problem has cropped up for me a few times, but I've always forgotten to make a post about it. If you're working with a large InnoDB table and you're updating, inserting, or deleting a large volume of rows, you may stumble upon this error:

<pre lang="html">ERROR 1206 (HY000): The total number of locks exceeds the lock table size</pre>

InnoDB stores its lock tables in the main buffer pool. This means that the number of locks you can have at the same time is limited by the `innodb_buffer_pool_size` variable that was set when MySQL was started. By default, MySQL leaves this at 8MB, which is pretty useless if you're doing anything with InnoDB on your server.

Luckily, the fix for this issue is very easy: adjust `innodb_buffer_pool_size` to a more reasonable value. However, that fix does require a restart of the MySQL daemon. There's simply no way to adjust this variable on the fly (with the current stable MySQL versions as of this post's writing).

Before you adjust the variable, make sure that your server can handle the additional memory usage. The `innodb_buffer_pool_size` variable is a server wide variable, not a per-thread variable, so it's shared between all of the connections to the MySQL server (like the query cache). If you set it to something like 1GB, MySQL won't use all of that up front. As MySQL finds more things to put in the buffer, the memory usage will gradually increase until it reaches 1GB. At that point, the oldest and least used data begins to get pruned when new data needs to be present.

**So, you need a workaround without a MySQL restart?**

If you're in a pinch, and you need a workaround, break up your statements into chunks. If you need to delete a million rows, try deleting 5-10% of those rows per transaction. This may allow you to sneak under the lock table size limitations and clear out some data without restarting MySQL.

To learn more about InnoDB's parameters, visit the [MySQL documentation][1].

 [1]: http://dev.mysql.com/doc/refman/5.0/en/innodb-parameters.html