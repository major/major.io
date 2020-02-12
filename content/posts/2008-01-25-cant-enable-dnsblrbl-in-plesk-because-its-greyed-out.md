---
title: Can’t enable DNSBL/RBL in Plesk because it’s greyed out
author: Major Hayden
type: post
date: 2008-01-25T17:11:27+00:00
url: /2008/01/25/cant-enable-dnsblrbl-in-plesk-because-its-greyed-out/
dsq_thread_id:
  - 3642772877
tags:
  - mail
  - plesk
  - qmail
  - spam

---
If you have a new Plesk installation and the following option is greyed out in Server -> Mail:

_Switch on spam protection based on DNS blackhole lists_

Just install the following RPM from Plesk:

`psa-qmail-rblsmtpd`