---
aliases:
- /2007/03/06/finding-compromised-scripts/
author: Major Hayden
date: 2007-03-06 18:41:21
dsq_thread_id:
- 3642765646
tags:
- plesk
- security
- web
title: Finding compromised scripts
---

If your server is sending out spam because of some bad scripts, hunt that stuff down:

```
grep POST /var/log/httpd/access_log | awk '{ print $7 }' | sort | uniq -c | sort -rn
```

Or on Plesk:

```
grep POST /home/httpd/vhosts/*/statistics/logs/access_log | awk '{ print $7 }' | sort | uniq -c | sort -rn
```