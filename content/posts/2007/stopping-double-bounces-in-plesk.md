---
aliases:
- /2007/03/05/stopping-double-bounces-in-plesk/
author: Major Hayden
date: 2007-03-05 22:50:41
dsq_thread_id:
- 3642765631
tags:
- mail
- plesk
title: Stopping Double Bounces in Plesk
---

To stop those evil double bounce e-mails in Plesk, just do:

`echo "#" > /var/qmail/control/doublebounceto`