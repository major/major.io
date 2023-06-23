---
aliases:
- /2007/05/27/install-mysql-server-from-ports-on-freebsd/
author: Major Hayden
date: 2007-05-27 21:47:13
dsq_thread_id:
- 3642767607
tags:
- database
title: Install mysql-server from ports on FreeBSD
---

Installing mysql on FreeBSD from ports is one of the oddest installations I've ever completed. Here's the step by step:

Get it compiled:

```
# portinstall mysql50-server
-- OR --
# make -C /usr/ports/databases/mysql50-server install clean
```

Once it's installed, copy my-small.cnf, my-medium.cnf or my-huge.cnf to /usr/local/etc/my.cnf:

`# cp /usr/local/share/mysql/my-small.cnf /usr/local/etc/my.cnf`

Enable mysql in the rc.conf:

`# echo "mysql_enable=\"YES\"" >> /etc/rc.conf`

Install the authentication tables:

`# mysql_install_db`

Last, change the ownership on MySQL's data directory:

`# chown -R mysql:mysql /var/db/mysql`

If you miss the last step, you'll get something ugly like this:

```
mysqld started
[ERROR] /usr/local/libexec/mysqld: Can't find file: './mysql/host.frm' (errno: 13)
[ERROR] /usr/local/libexec/mysqld: Can't find file: './mysql/host.frm' (errno: 13)
[ERROR] Fatal error: Can't open and lock privilege tables: Can't find file: './mysql/host.frm' (errno: 13)
mysqld ended
```