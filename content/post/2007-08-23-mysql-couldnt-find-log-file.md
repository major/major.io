---
title: MySQL couldn’t find log file
author: Major Hayden
type: post
date: 2007-08-24T00:24:28+00:00
url: /2007/08/23/mysql-couldnt-find-log-file/
dsq_thread_id:
  - 3642769531
tags:
  - database
  - emergency

---
This error will pop up when binary logging is enabled, and someone thought it was a good idea to remove binary logs from the filesystem:

`/usr/sbin/mysqld: File './mysql_bin.000025' not found (Errcode: 2)<br />
[ERROR] Failed to open log (file './9531_mysql_bin.000025', errno 2)<br />
[ERROR] Could not open log file<br />
[ERROR] Can't init tc log<br />
[ERROR] Aborting`

`InnoDB: Starting shutdown...<br />
InnoDB: Shutdown completed; log sequence number 0 2423986213<br />
[Note] /usr/sbin/mysqld: Shutdown complete`

Basically, MySQL is looking in the **mysql-bin.index** file and it cannot find the log files that are listed within the index. This will keep MySQL from starting, but the fix is quick and easy. You have two options:

**Edit the index file**

You can edit the mysql-bin.index file in a text editor of your choice and remove the references to any logs which don't exist on the filesystem any longer. Once you're done, save the index file and start MySQL.

**Take away the index file**

Move or delete the index file and start MySQL. This will cause MySQL to reset its binary log numbering scheme, so if this is important to you, you may want to choose the previous option.

So how do you prevent this from happening? Use the `PURGE MASTER LOGS` statement and allow MySQL to delete its logs on its own terms. If you're concerned about log files piling up, adjust the `expire_logs_days` variable in your /etc/my.cnf.

Further reading:

[12.6.1.1. PURGE MASTER LOGS Syntax][1]

[5.2.3 System Variables][2]

 [1]: http://dev.mysql.com/doc/refman/5.0/en/purge-master-logs.html
 [2]: http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html
