---
title: 'MySQL: Errcode: 24 when using LOCK TABLES'
author: Major Hayden
type: post
date: 2007-08-20T03:07:30+00:00
url: /2007/08/19/mysql-errcode-24-when-using-lock-tables/
dsq_thread_id:
  - 3642769458
categories:
  - Blog Posts
tags:
  - database

---
While running into MySQL's open files limit will manifest itself into various error messages, this is the standard one that you'll receive during a mysqldump:

```
mysqldump: Got error: 29: File './databasename/tablename.MYD' not found
(Errcode: 24) when using LOCK TABLES</pre>

The best way to get to the bottom of the error is to find out what it means:

```
$ perror 24
OS error code  24:  Too many open files</pre>

There's two ways to fix the problem. First, if you find that you only hit the limit during mysqldumps and never during normal database operation, just add `--single-transaction` to your mysqldump command line options. This will cause mysql to keep only one table open at a time.

However, if this happens while backups aren't running, you may want to increase the `open_files_limit` in your MySQL configuration file. By default, the variable is set to 1,024 open files.

For further reading:

[5.2.3. System Variables][1]

[7.13. mysqldump - A Database Backup Program][2]

 [1]: http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#option_mysqld_open_files_limit
 [2]: http://dev.mysql.com/doc/refman/5.0/en/mysqldump.html
