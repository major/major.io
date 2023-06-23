---
aliases:
- /2008/01/09/mysql-replication-breakdown/
author: Major Hayden
date: 2008-01-09 18:24:03
dsq_thread_id:
- 3642773120
tags:
- database
- mysql
title: 'MySQL Replication: Breakdown'
---

On some occasions, MySQL replication can break down if an statement comes from the master that makes no sense to the slave. For example, if an UPDATE statement arrives from the master server, but the table referenced by the UPDATE no longer exists, then the slave will halt replication and throw an error when `SHOW SLAVE STATUS;` is run.

The obvious question here is: how can the master and the slave have different data after replication has started? After all, you make a dump file prior to starting replication, so both servers contain the same information. Stray updates can be thrown into the mix from application errors or plain user errors. These kinds of things happen, even though we all try to avoid it.

Don't worry - this is almost always an easy fix. You have two main options:

**Fix the problem yourself.** If the master sent a query that the slave can't run, fix it manually. For example, if the master wants to run an INSERT on a table that doesn't exist, run a quick `SHOW CREATE TABLE;` on the master and create the table manually on the slave. When the table is there, run a `START SLAVE;` on the slave and you should be all set.

**Skip an unnecessary query.** Let's say that the master sent over a `DROP TABLE` query but the table doesn't exist on the master. It's safe to say that the master won't be sending any write queries to that table in the future, so the query can be skipped. To skip it, run the following statement:

`mysql> SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;<br />
mysql> START SLAVE;`

In short, you're telling MySQL to skip that unnecessary query and keep going with the ones after that. Of course, if you need to skip multiple queries, change the 1 to whatever number you need and then run `START SLAVE;`.