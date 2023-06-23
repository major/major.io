---
aliases:
- /2007/06/14/adjusting-sendmail-queue-time-lifetime/
author: Major Hayden
date: 2007-06-14 22:56:27
dsq_thread_id:
- 3644160199
tags:
- mail
title: Adjusting sendmail queue time / lifetime
---

By default, sendmail will keep items in the queue for up to 5 days. If you want to make this something shorter, like 3 days, you can adjust the following in /etc/mail/sendmail.mc:

```
define(`confTO_QUEUERETURN', `3d')dnl
```

If you want to get super fancy, you can adjust the queue lifetime for messages with certain priorities:

```
define(`confTO_QUEUERETURN_NORMAL', `3d')dnl
define(`confTO_QUEUERETURN_URGENT', `5d')dnl
define(`confTO_QUEUERETURN_NONURGENT', `1d')dnl
```