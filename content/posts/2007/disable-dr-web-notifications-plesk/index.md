---
aliases:
- /2007/02/27/disable-dr-web-notifications-plesk/
author: Major Hayden
date: 2007-02-27 16:10:56
tags:
- mail
- plesk
title: Disable Dr. Web Notifications in Plesk
---

You can edit /etc/drweb/drweb_qmail.conf to eliminate receiving notification messages when Dr. Web has an issue:

```ini
[VirusNotifications]
SenderNotify = no
AdminNotify = no
RcptsNotify = no
```

Then just restart Dr. Web with:

```
/etc/init.d/drwebd restart
```

Plesk has a [KB article][1] about this issue as well.

 [1]: http://kb.swsoft.com/article_122_1685_en.html