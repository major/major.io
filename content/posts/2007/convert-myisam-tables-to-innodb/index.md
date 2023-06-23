---
aliases:
- /2007/10/03/convert-myisam-tables-to-innodb/
author: Major Hayden
date: 2007-10-04 03:29:13
dsq_thread_id:
- 3642770192
tags:
- database
title: Convert MyISAM tables to InnoDB
---

If you want to convert a MyISAM table to InnoDB, the process is fairly easy, but you can do something extra to speed things up. Before converting the table, adjust its order so that the primary key column is in order:

```


This will pre-arrange the table so that it can be converted quickly without a lot of re-arranging required in MySQL. Then, simply change the table engine:

```


If your table is large, then it may take a while to convert it over. There will probably be a fair amount of CPU usage and disk I/O in the process.

These statements are also safe in replicated environments. When you issue this statement to the master, it will begin the conversion process. Once it is complete on the master, the statement will roll down to the slaves, and they will begin the conversion as well. Keep in mind, however, that this can greatly reduce the performance of your configuration in the process.

_Special thanks to Matthew Montgomery for the ORDER BY recommendation._