---
aliases:
- /2007/10/12/enabling-dr-web-virus-scanning-for-new-accounts/
author: Major Hayden
date: 2007-10-12 18:35:06
tags:
- mail
- plesk
title: Enabling Dr. Web virus scanning for new accounts
---

If you're using Plesk 8.0 or later, you can set up Dr. Web to be enabled for all new mail accounts. To do this, you have to create an event handler.

Here's the steps you will need:

&raquo; Log into Plesk

&raquo; Click "Server"

&raquo; Click "Event Manager"

&raquo; Choose "Mail Name Created" next to "Event"

&raquo; In the command area, enter `/usr/local/psa/bin/mail.sh --update $NEW_MAILNAME -antivirus inout`

&raquo; Click "OK"