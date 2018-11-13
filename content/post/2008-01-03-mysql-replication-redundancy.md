---
title: 'MySQL Replication: Redundancy'
author: Major Hayden
type: post
date: 2008-01-04T02:39:11+00:00
url: /2008/01/03/mysql-replication-redundancy/
dsq_thread_id:
  - 3642770868
tags:
  - database
  - mysql

---
Although performance is a much larger benefit of replication, it provides some redundancy for your application as well. Adding a slave server to a master allows you to perform read operations on either server, but you're still bound to the master server for writes. In a group of multiple slaves with one master, you have your data available and online in multiple locations, which means that certain servers can fall out of replication without a large disaster.

When disaster does occur, use the following recommendations as a guide.

**If the master fails in a two-server replication environment,** you will be dead in the water with regards to write queries. You will need to convert the slave into a master. This can be done relatively quickly by following these steps:

  1. Log into MySQL on the slave and run `STOP SLAVE; RESET SLAVE;`
  2. Add `log-bin` to the slave's /etc/my.cnf file and restart MySQL
  3. The slave server will now be running as a master
  4. Adjust your application to send reads and writes to the slave

Once the original master comes back online, [set it up just like a new slave][1]. You can skip some steps, such as setting the server-id, since that still should correspond to your overall configuration.

**If the master fails in a multiple-server replication environment,** you're still in bad shape for writes. Follow the steps shown above, and then adjust the other slaves (with `CHANGE MASTER`) so that they pull events from the new master instead.

**If a slave fails in any replication environment,** adjust your application so that it no longer attempts to send reads to the failed slave. While you work to bring the failed slave back online, your queries will be distributed to the remaining servers.

You can automate many of these operations by using applications like [heartbeat][2], or by using load balancers to automatically route database traffic.

 [1]: http://rackerhacker.com/2007/12/31/seven-step-mysql-replication/
 [2]: http://www.linux-ha.org/
