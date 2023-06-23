---
aliases:
- /2007/03/27/setting-the-hostname-in-sendmail/
author: Major Hayden
date: 2007-03-27 21:01:26
dsq_thread_id:
- 3642766175
tags:
- mail
title: Setting the hostname in Sendmail
---

If you need to change the hostname that Sendmail announces itself as, just add the following to sendmail.mc:

``define(`confDOMAIN_NAME', `mail.yourdomain.com')dnl``

And, to add additional stuff onto the end of the line:

``define(`confSMTP_LOGIN_MSG',`mailer ready')dnl``