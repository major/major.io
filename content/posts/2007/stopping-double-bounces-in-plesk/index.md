---
aliases:
- /2007/03/05/stopping-double-bounces-in-plesk/
author: Major Hayden
date: 2007-03-05 22:50:41
tags:
- mail
- plesk
title: Stopping Double Bounces in Plesk
---

To stop those evil double bounce e-mails in Plesk, just do:

`echo "#" > /var/qmail/control/doublebounceto`