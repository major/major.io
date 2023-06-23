---
aliases:
- /2007/01/15/sum-apache-bandwidth-from-logs/
author: Major Hayden
date: 2007-01-15 15:33:09
dsq_thread_id:
- 3645210752
tags:
- web
title: Sum Apache Bandwidth From Logs
---

If you're not a fan of scientific notation, use this to calculate the apache bandwidth used from log files in MB:

```
cat /var/log/httpd/access_log | awk '{ SUM += $5} END { print SUM/1024/1024 }'
```