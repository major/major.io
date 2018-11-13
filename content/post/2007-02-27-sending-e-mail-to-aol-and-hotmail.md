---
title: Sending E-mail to AOL and Hotmail
author: Major Hayden
type: post
date: 2007-02-27T17:05:32+00:00
url: /2007/02/27/sending-e-mail-to-aol-and-hotmail/
dsq_thread_id:
  - 3642765518
tags:
  - mail

---
To send e-mail properly to AOL and Hotmail, three things must match:

  * Your IP must have reverse DNS.
  * If you ask for the forward DNS record for the reverse, it must match.
  * Your mail server's HELO must match the DNS records.

If you need to test your setup, use these commands.

`$ host mhtx.net<br />
<strong>mhtx.net</strong> has address 209.61.157.17<br />
$ host 209.61.157.17<br />
17.157.61.209.in-addr.arpa domain name pointer <strong>mhtx.net</strong>.<br />
$ telnet 209.61.157.17 25<br />
Trying 209.61.157.17...<br />
Connected to mhtx.net.<br />
Escape character is '^]'.<br />
220 <strong>mhtx.net</strong> ESMTP Postfix`
