---
aliases:
- /2008/01/07/mysql-replication-horizontal-data-partitioning/
author: Major Hayden
date: 2008-01-07 17:57:56
tags:
- database
- mysql
title: 'MySQL Replication: Horizontal Data Partitioning'
---

If you have a master with multiple slaves, you can get some performance and save money on hardware by splitting data horizontally among your servers. For example, if you have one high traffic database and two lower traffic databases, you can selectively split them among the slaves. With five slaves, set up three of the slaves to replicate your high traffic database, and the two other slaves can handle one each out of the two low traffic databases.

This allows you to expand when you're ready, and you can move your databases around to take advantage of idle servers. MySQL AB already has [documentation on how to make this possible][1].

 [1]: http://dev.mysql.com/doc/refman/5.0/en/replication-solutions-partitioning.html