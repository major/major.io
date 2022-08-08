---
title: Setting the hostname in Sendmail
author: Major Hayden
date: 2007-03-27T21:01:26+00:00
url: /2007/03/27/setting-the-hostname-in-sendmail/
dsq_thread_id:
  - 3642766175
tags:
  - mail

---
If you need to change the hostname that Sendmail announces itself as, just add the following to sendmail.mc:

``define(`confDOMAIN_NAME', `mail.yourdomain.com')dnl``

And, to add additional stuff onto the end of the line:

``define(`confSMTP_LOGIN_MSG',`mailer ready')dnl``