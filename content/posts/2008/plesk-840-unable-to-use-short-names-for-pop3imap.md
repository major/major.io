---
aliases:
- /2008/07/28/plesk-840-unable-to-use-short-names-for-pop3imap/
author: Major Hayden
date: 2008-07-28 16:08:50
dsq_thread_id:
- 3644424358
tags:
- courier-imap
- imap
- plesk
- pop3
- smtp
title: 'Plesk 8.4.0: Unable to use short names for POP3/IMAP'
---

If you recently upgraded to Plesk 8.4.0 with short names enabled, you may have found that it's working with SMTP, but it doesn't work with POP3 or IMAP. There's a bug in the Plesk version that prevents the courier configuration from being updated.

To correct the issue, first make sure that Plesk has short names enabled (Server > Mail). Once you've confirmed that Plesk thinks it's enabled, add `SHORTNAMES=1` to the following configuration files:

  * /etc/courier-imap/imapd
  * /etc/courier-imap/imapd-ssl
  * /etc/courier-imap/pop3d
  * /etc/courier-imap/pop3d-ssl

Restart courier-imap with `/etc/init.d/courier-imap restart` and you should be all set.