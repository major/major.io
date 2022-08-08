---
title: Finding compromised scripts
author: Major Hayden
date: 2007-03-06T18:41:21+00:00
url: /2007/03/06/finding-compromised-scripts/
dsq_thread_id:
  - 3642765646
tags:
  - plesk
  - security
  - web

---
If your server is sending out spam because of some bad scripts, hunt that stuff down:

```
grep POST /var/log/httpd/access_log | awk '{ print $7 }' | sort | uniq -c | sort -rn
```

Or on Plesk:

```
grep POST /home/httpd/vhosts/*/statistics/logs/access_log | awk '{ print $7 }' | sort | uniq -c | sort -rn
```
