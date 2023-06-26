---
aliases:
- /2008/01/14/mysql-replication-slave-performance/
author: Major Hayden
date: 2008-01-14 18:26:40
tags:
- database
- mysql
title: 'MySQL Replication: Slave Performance'
---

There's a few final configuration options that may help the performance of your slave MySQL servers. If you're not using certain storage engines, like InnoDB or Berkeley, then by all means, remove them from your configuration. For those two specifically, just add the following to your my.cnf on the slave server:

`skip-innodb<br />
skip-bdb`

To reduce disk I/O on big MyISAM write operations, you can [delay the flushing of indexes][1] to the disk:

`delay_key_write = ALL`

You can also make all of your [write queries take a backseat][2] to any reads:

`low-priority-updates`

Keep in mind, however, that the last two options will increase slave performance, but it [may cause them to lag behind the master][3]. Depending on your application, this may not be acceptable.

 [1]: http://dev.mysql.com/doc/refman/5.0/en/server-options.html#option_mysqld_delay-key-write
 [2]: http://dev.mysql.com/doc/refman/5.0/en/server-options.html#option_mysqld_low-priority-updates
 [3]: http://rackerhacker.com/2008/01/08/mysql-replication-delayed-slaves/