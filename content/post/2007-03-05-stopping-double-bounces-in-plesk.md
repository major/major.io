---
title: Stopping Double Bounces in Plesk
author: Major Hayden
type: post
date: 2007-03-05T22:50:41+00:00
url: /2007/03/05/stopping-double-bounces-in-plesk/
dsq_thread_id:
  - 3642765631
tags:
  - mail
  - plesk

---
To stop those evil double bounce e-mails in Plesk, just do:

`echo "#" > /var/qmail/control/doublebounceto`