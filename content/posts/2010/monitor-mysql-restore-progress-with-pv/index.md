---
aliases:
- /2010/11/24/monitor-mysql-restore-progress-with-pv/
author: Major Hayden
date: 2010-11-24 16:43:28
tags:
- command line
- database
- emergency
- mysql
- sysadmin
title: Monitor MySQL restore progress with pv
---

The [pv][1] command is one that I really enjoy using but it's also one that I often forget about. You can't get a much more concise definition of what pv does than this one:

> pv allows a user to see the progress of data through a pipeline, by giving information such as time elapsed, percentage completed (with progress bar), current throughput rate, total data transferred, and ETA.

The usage certainly isn't complicated:

> To use it, insert it in a pipeline between two processes, with the appropriate options. Its standard input will be passed through to its standard output and progress will be shown on standard error.

A great application of pv is when you're restoring large amounts of data into MySQL, especially if you're restoring data under duress due to an accidentally-dropped table or database. (Who hasn't been there before?) The standard way of restoring data is something we're all familiar with:

<pre lang="html"># mysql my_database &lt; database_backup.sql</pre>

The downside of this method is that you have no idea how quickly your restore is working or when it might be done. You could always open another terminal to monitor the tables and databases as they're created, but that can be hard to follow.

Toss in pv and that problem is solved:

<pre lang="html"># pv database_backup.sql | mysql my_database
96.8MB 0:00:17 [5.51MB/s] [==>                                ] 11% ETA 0:02:10
</pre>

When it comes to MySQL, your restore rate is going to be different based on some different factors, so the ETA might not be entirely accurate.

 [1]: http://linux.die.net/man/1/pv