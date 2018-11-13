---
title: 'MySQL Replication: Performance'
author: Major Hayden
type: post
date: 2008-01-02T18:20:05+00:00
url: /2008/01/02/mysql-replication-performance/
dsq_thread_id:
  - 3679006537
tags:
  - database
  - mysql

---
MySQL replication can increase performance by allowing developers to spread queries over two servers. Queries that write data must be sent to the master at all times, but queries that read data can be sent to either server. This means that by adding a slave server to a database environment allows you to effectively double your read query performance.

**However, there are some large caveats to consider here.** The actual web site code itself will need to be written in such a way that read and write queries can be diverted to different destinations. Depending on the size of the application and how it has been developed, the work requires to provide this functionality may be prohibitive for replication.

Some load balancers can balance MySQL query traffic, and this can help if the code cannot balance the load internally. Open source applications like MySQL Proxy and pound can be used as well.

Also, if the queries are not optimized, and the correct storage engines are not used, replication will not work well. If queries take an extended time to execute, the performance gains will be almost non existent. Also, if the wrong storage engines are used, and much of the rows or tables are locked, performance gains will be greatly limited. Some situations may actually cause replication to halt due to locking. When this occurs, the data on the slave becomes stale and SELECTs run against the master and slave will return different results.

In short:

  * Replication can increase read performance
  * It cannot fix issues caused by bad queries/storage engines
  * Write queries can only be sent to the master