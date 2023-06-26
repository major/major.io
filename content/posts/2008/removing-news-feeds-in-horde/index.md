---
aliases:
- /2008/01/21/removing-news-feeds-in-horde/
author: Major Hayden
date: 2008-01-21 18:36:49
tags:
- horde
- mail
- plesk
- web
title: Removing news feeds in Horde
---

If you've used newer versions of Horde with Plesk, you have probably noticed the news feed that runs down the left side of the screen. Depending on the types of e-mails you receive, you may get some pretty odd news popping up on the screen.

Luckily, you can remove the news feeds pretty easily. Open the following file in your favorite text editor:

`/usr/share/psa-horde/templates/portal/sidebar.inc`

Once the file is open, drop down to line 102 and comment out the entire if() statement (lines 102-117).

**NOTE:** If you upgrade Plesk, this change will most likely be reversed.