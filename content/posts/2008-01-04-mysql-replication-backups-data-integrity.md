---
title: 'MySQL Replication: Backups & Data Integrity'
author: Major Hayden
type: post
date: 2008-01-04T19:39:12+00:00
url: /2008/01/04/mysql-replication-backups-data-integrity/
dsq_thread_id:
  - 3679005510
tags:
  - database
  - mysql

---
An often overlooked benefit of MySQL replication is the ability to make reliable backups without affecting the integrity of the MySQL data.

With one MySQL server, backups have a huge impact on the server. If file-based backups are performed, you have to stop MySQL completely while the files are copied (unless you purchase expensive utilities that accomplish this while MySQL is running). If dumps are made with mysqldump, table locking and I/O operations will crush the performance of the server.

You can get around these performance hits by running dumps in single transaction mode, or by restricting mysqldump to locking one table at a time. The performance gain comes at a price, however, as your backups are not a perfect snapshot. After one table is locked for a period of table, previously locked tables are actively changing and some tables might not match up.

By having a slave available, you can perform a snapshot backup and lock all of the tables during the process. This provides an exact point-in-time backup with a very low effect on your MySQL servers' performance.
