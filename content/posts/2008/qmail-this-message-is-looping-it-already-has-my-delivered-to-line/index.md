---
aliases:
- /2008/01/23/qmail-this-message-is-looping-it-already-has-my-delivered-to-line/
author: Major Hayden
date: 2008-01-23 18:20:27
tags:
- mail
- plesk
- qmail
title: 'qmail: This message is looping: it already has my Delivered-To line'
---

I stumbled upon this peculiar bounce message recently while working on a server:

```
Hi. This is the qmail-send program at yourmailserver.com.
I'm afraid I wasn't able to deliver your message to the following addresses.
This is a permanent error; I've given up. Sorry it didn't work out.
<user1@domain.com>:
This message is looping: it already has my Delivered-To line. (#5.4.6)
--- Below this line is a copy of the message.</p>
Return-Path: <remoteuser@otherdomain.com>
Received: (qmail 14418 invoked by uid 110); 9 Jan 2008 13:04:33 -0600
Delivered-To: 54-user2@domain.com
Received: (qmail 14411 invoked by uid 110); 9 Jan 2008 13:04:33 -0600
Delivered-To: 53-user1@domain.com
Received: (qmail 14404 invoked from network); 9 Jan 2008 13:04:33 -0600
Received: from otherdomain.com (HELO otherdomain.com) (11.22.33.44)
by yourmailserver.com with SMTP; 9 Jan 2008 13:04:33 -0600
```

Basically, this is qmail's way of letting you know that your e-mails are stuck in a mail loop. One e-mail user is redirecting to another e-mail user, and that e-mail user is redirecting back to the first one. If q-mail already has a delivered to line which matches one that it already added, it bounces the e-mail and halts delivery.