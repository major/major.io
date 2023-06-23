---
aliases:
- /2007/05/17/relay-access-denied/
author: Major Hayden
date: 2007-05-18 03:16:06
dsq_thread_id:
- 3661467397
tags:
- mail
- security
title: Relay access denied
---

If you're checking through your mail logs, or you catch a bounced e-mail with "554 relay access denied" in the bounce, the issue can be related to a few different things:

If **your** server bounces with this message when people send e-mail to **you**:

  * Check to make sure that your mail server is configured to receive mail for your domain
      * Postfix: /etc/postfix/mydomains (on some systems)
      * Sendmail: /etc/mail/local-host-names
      * Qmail: /var/qmail/control/rcpthosts
  * Verify that your MX records are pointing to your server, and not someone else's (very important during server migrations)
  * If you recently made changes in Postfix, make sure to run `postmap` on your domains file and run `postfix reload`

If you get this message when you try to send e-mail to other people through your server:

  * Enable SMTP authentication in your e-mail client
  * If SMTP authentication is on in your client, check your server's authentication daemons to be sure they're operating properly