---
aliases:
- /2007/09/15/testing-spamassassin-with-gtube/
author: Major Hayden
date: 2007-09-15 17:14:24
dsq_thread_id:
- 3648781441
tags:
- mail
title: Testing SpamAssassin with GTUBE
---

If you have SpamAssassin installed, but you want to make sure that it is marking or filtering your e-mails, simply send an e-mail which contains the special line provided here:

<http://spamassassin.apache.org/gtube/gtube.txt>

SpamAssassin will always mark e-mails that contain this special line as spam:

`XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X`