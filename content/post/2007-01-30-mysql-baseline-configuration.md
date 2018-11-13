---
title: MySQL Baseline Configuration
author: Major Hayden
type: post
date: 2007-01-30T16:21:08+00:00
url: /2007/01/30/mysql-baseline-configuration/
dsq_thread_id:
  - 3667955131
tags:
  - database

---
Need a baseline configuration for MySQL 4.x or 5.x? Look no further:

`[mysqld]<br />
datadir=/var/lib/mysql<br />
socket=/var/lib/mysql/mysql.sock<br />
#old_passwords=1<br />
skip-locking<br />
key_buffer = 64M<br />
max_allowed_packet = 16M<br />
table_cache = 2048<br />
sort_buffer_size = 1M<br />
read_buffer_size = 1M<br />
read_rnd_buffer_size = 8M<br />
myisam_sort_buffer_size = 64M<br />
thread_cache_size = 16<br />
query_cache_size = 32M<br />
thread_concurrency = 8<br />
tmp_table_size=64M<br />
back_log = 100<br />
max_connect_errors = 10000<br />
join_buffer_size=1M<br />
[mysql.server]<br />
user=mysql<br />
basedir=/var/lib<br />
[mysqld_safe]<br />
err-log=/var/log/mysqld.log<br />
pid-file=/var/run/mysqld/mysqld.pid<br />
open_files_limit=65536`