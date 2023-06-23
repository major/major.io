---
aliases:
- /2007/05/07/horde-refreshes-when-logging-in/
author: Major Hayden
date: 2007-05-07 21:20:51
dsq_thread_id:
- 3679051727
tags:
- mail
- plesk
- web
title: Horde refreshes when logging in
---

If you find that Horde (with Plesk) keeps refreshing when you attempt to log in, and there are no errors logged on the screen or in Apache's logs, check the `session.auto_start` variable in /etc/php.ini.

If `session.auto_start` is set to 1, set it to 0 and Horde will miraculously start working again.