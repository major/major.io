---
title: 'Plesk and qmail: 421 temporary envelope failure (#4.3.0)'
author: Major Hayden
type: post
date: 2007-12-04T18:21:23+00:00
url: /2007/12/04/plesk-and-qmail-421-temporary-envelope-failure-430/
dsq_thread_id:
  - 3661560834
tags:
  - mail
  - plesk
  - qmail

---
I stumbled upon a server running Plesk 8.2.1 where a certain user could not receive e-mail. I sent an e-mail to the user from my mail client, and I never saw it enter the user's mailbox. It didn't even appear in the logs.

After checking the usual suspects, like MX records, mail account configuration, and firewalls, I was unable to find out why it was occurring. Even after a run of `mchk`, the emails would not be delivered.

I began testing with a telnet connection to the SMTP port:

`$ telnet 11.22.33.44 25<br />
Trying 11.22.33.44...<br />
Connected to 11.22.33.44.<br />
Escape character is '^]'.<br />
220 www.yourserver.com ESMTP<br />
HELO domain.com<br />
250 www.yourserver.com<br />
MAIL FROM: test@test.com<br />
250 ok<br />
RCPT TO: someuser@somedomain.com<br />
421 temporary envelope failure (#4.3.0)<br />
QUIT<br />
221 www.yourserver.com<br />
Connection closed by foreign host.`

Temporary envelope failure? I was still confused. After reviewing the logs, I found the following line whenever I tried to telnet to port 25 and send an e-mail:

`Dec  2 00:15:49 www relaylock: /var/qmail/bin/relaylock: mail from 44.33.22.11:17249 (yourdesktop.com)`

It turns out that the customer was using greylisting in qmail with qmail-envelope-scanner. After a quick check of /tmp/greylist_dbg.txt, I found the entries from me (as well as a lot of other senders), and that ended up being the root of the problem.
