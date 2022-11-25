---
title: Finding compromised mail accounts in Plesk
author: Major Hayden
date: 2007-02-10T16:35:23+00:00
url: /2007/02/10/finding-compromised-mail-accounts-in-plesk/
dsq_thread_id:
  - 3642765175
tags:
  - mail
  - plesk
  - security

---
If odd bounced e-mails are coming back to the server or the server is listed in a blacklist, some accounts may be compromised on the server. Here's how to diagnose the issue:

Read the queue and look for messages with funky senders or lots of recipients.

```# /var/qmail/bin/qmail-qread
10 Feb 2007 07:31:08 GMT  #476884  10716  <service@paypal.com>
        remote  debbarger@earthlink.net
        remote  debbiabbis@hotmail.com
        remote  debbiak@aol.com
        *** lots more recicpients below ***
```

This is a phishing e-mail being sent out to imitate PayPal. Now you need to find which IP is sending this e-mail, so grab the message ID and pass it to qmHandle:

```
# qmHandle -m476884 | less
Received: (qmail 20390 invoked from network); 10 Feb 2007 07:31:08 -0600
Received: from unknown (HELO User) (207.219.92.194)
```

In this case, the offender is from 207.219.92.194. Now we can dig for the login in /var/log/messages:

```
# grep -i 207.219.92.194 /var/log/messages
Feb 10 10:19:33 s60418 smtp_auth: SMTP connect from unknown@ [207.219.92.194]
Feb 10 10:19:33 s60418 smtp_auth: smtp_auth: SMTP user [USER] : /var/qmail/mailnames/[DOMAIN]/[USER] logged in from unknown@ [207.219.92.194]
```

Just for giggles, let's find out what their password is:

```
# mysql -u admin -p`cat /etc/psa/.psa.shadow`
mysql> use psa;
mysql> select CONCAT(mail_name,"@",name) as email_address,accounts.password
from mail left join domains on domains.id=mail.dom_id left join accounts on
accounts.id=mail.account_id where mail_name like '[USER]';
+---------------------------+----------+
| email_address             | password |
+---------------------------+----------+
| [USER]@[DOMAIN]           | password |
+---------------------------+----------+
1 row in set (0.00 sec)
```

Well, 'password' isn't a great password. Log into Plesk and change this password ASAP. To verify your work, tail /var/log/messages and you should see this:

```
# tail -f /var/log/messages
Feb 10 10:27:08 s60418 smtp_auth: SMTP connect from unknown@ [207.219.92.194]
Feb 10 10:27:08 s60418 smtp_auth: smtp_auth: FAILED: [USER] - password incorrect  from unknown@ [207.219.92.194]
```

Big thanks goes to Jon B. and Mike J. for this.
