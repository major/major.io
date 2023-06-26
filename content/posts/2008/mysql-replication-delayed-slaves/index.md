---
aliases:
- /2008/01/08/mysql-replication-delayed-slaves/
author: Major Hayden
date: 2008-01-09 03:11:11
tags:
- database
- mysql
title: 'MySQL Replication: Delayed Slaves'
---

In a perfect world, slaves will contain the same data as the master at all times. The events should be picked up and executed by the slaves in milliseconds. However, in real world scenarios, replication will be held up for different reasons. Whether it's table locks, disk I/O, network saturation, or CPU usage, slaves might become several seconds, minutes or even hours behind the master.

In some situations, delays of less than 30 seconds may not be a big issue. Some applications, like social networking applications, would need to have the data match at all times. Lags would not be acceptable.

For example, review this scenario. Let's say you go to a site and create an account. That would send a write query to the master. Once you've finished the account creation, the page will depend on a read query. If the slave is behind the master, it won't have any data about your new account, and the application will probably tell you that you don't have an account. That would be pretty annoying for your application's users.

To check your current lag, simply run [`SHOW SLAVE STATUS;`][1] in MySQL, and review the number following `Seconds_Behind_Master`. If everything is running well, it should be followed by 0. If `NULL` is shown, then there is most likely an issue with replication, and you might want to check `Last_Error`.

So, how can replication lags be corrected? Try these methods:

**Review your queries.** When queries keep running in MySQL, the slave may be unable to keep up. Make sure that your read queries are as [optimized as possible][2] so they complete quickly.

**Optimize your MySQL server variables.** Be sure to [thoroughly review your MySQL configuration][3] for any bottlenecks.

**Choose the right storage engines.** If you're making a lot of updates to a table, [consider using InnoDB][4]. If your tables are not updated often, c[onsider using MyISAM tables][4] (or even [compressed MyISAM tables][5]).

**Upgrade your hardware.** Find your hardware bottleneck. If it's the CPU, consider upgrading to a multi-core CPU, or a CPU with a higher clock speed. For I/O bottlenecks, consider a RAID solution with SAS drives. If you're lucky enough to have a network bottleneck (lucky since it means you're doing well with CPU and I/O), use a dedicated switch or upgrade to gigabit (or faster) hardware.

 [1]: http://dev.mysql.com/doc/refman/5.0/en/show-slave-status.html
 [2]: http://dev.mysql.com/doc/refman/5.0/en/explain.html
 [3]: http://rackerhacker.com/mysqltuner/
 [4]: http://rackerhacker.com/2007/11/06/when-to-use-myisam-or-innodb/
 [5]: http://dev.mysql.com/doc/refman/5.0/en/myisampack.html