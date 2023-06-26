---
aktt_notify_twitter:
- false
aliases:
- /2007/09/07/mysql-binary-log-rotation/
author: Major Hayden
date: 2007-09-07 22:07:17
tags:
- database
title: MySQL binary log rotation
---

If you've run MySQL in a replication environment, or if you've enabled binary logging for transactional integrity, you know that the binary logs can grow rather quickly. The only safe way to delete the logs is to use [PURGE MASTER LOGS][1] in MySQL, but if you want MySQL to automatically remove the logs after a certain period of time, add this in your my.cnf:

```
expire_logs_days = 14
```

[5.11.3. The Binary Log][2]

 [1]: http://dev.mysql.com/doc/refman/5.0/en/purge-master-logs.html
 [2]: http://dev.mysql.com/doc/refman/5.0/en/binary-log.html