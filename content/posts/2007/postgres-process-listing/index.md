---
aliases:
- /2007/06/06/postgres-process-listing/
author: Major Hayden
date: 2007-06-07 04:44:39
tags:
- database
title: Postgres process listing
---

If you're used to `SHOW PROCESSLIST;` or `mysqladmin processlist` in MySQL, you might be searching for this same functionality in postgresql. Here's the quick way to get a process list in postgresql:

Switch to the postgres user:

`# su - postgres`

Get into the postgres shell:

`# psql`

Then run a quick query:

`select * from pg_stat_activity;`

**NOTE:** To actually see the queries being run, you will need logging enabled (it's disabled by default). I don't know how to turn it on yet, so this post will be left open until I find out!