---
aliases:
- /2007/06/14/adjusting-qmail-queue-time-lifetime/
author: Major Hayden
date: 2007-06-14 22:58:01
dsq_thread_id:
- 3648243943
tags:
- mail
title: Adjusting qmail queue time / lifetime
---

If you want to adjust how long e-mails will spend in the qmail queue before they're bounced, simple set the queuelifetime:

```
# echo "432000" > /var/qmail/control/queuelifetime
# /etc/init.d/qmail restart
```

The above example is for 5 days (qmail needs the time length in seconds). Just take the days and multiply by 86,400 seconds to get your result.