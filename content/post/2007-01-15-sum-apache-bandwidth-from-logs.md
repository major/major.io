---
title: Sum Apache Bandwidth From Logs
author: Major Hayden
type: post
date: 2007-01-15T15:33:09+00:00
url: /2007/01/15/sum-apache-bandwidth-from-logs/
dsq_thread_id:
  - 3645210752
tags:
  - web

---
If you're not a fan of scientific notation, use this to calculate the apache bandwidth used from log files in MB:

cat /var/log/httpd/access_log | awk '{ SUM += $5} END { print SUM/1024/1024 }'
