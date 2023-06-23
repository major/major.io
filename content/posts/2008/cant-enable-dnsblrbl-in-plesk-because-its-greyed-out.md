---
aliases:
- /2008/01/25/cant-enable-dnsblrbl-in-plesk-because-its-greyed-out/
author: Major Hayden
date: 2008-01-25 17:11:27
dsq_thread_id:
- 3642772877
tags:
- mail
- plesk
- qmail
- spam
title: Can’t enable DNSBL/RBL in Plesk because it’s greyed out
---

If you have a new Plesk installation and the following option is greyed out in Server -> Mail:

_Switch on spam protection based on DNS blackhole lists_

Just install the following RPM from Plesk:

`psa-qmail-rblsmtpd`