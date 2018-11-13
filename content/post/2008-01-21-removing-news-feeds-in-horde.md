---
title: Removing news feeds in Horde
author: Major Hayden
type: post
date: 2008-01-21T18:36:49+00:00
url: /2008/01/21/removing-news-feeds-in-horde/
dsq_thread_id:
  - 3642772891
tags:
  - horde
  - mail
  - plesk
  - web

---
If you've used newer versions of Horde with Plesk, you have probably noticed the news feed that runs down the left side of the screen. Depending on the types of e-mails you receive, you may get some pretty odd news popping up on the screen.

Luckily, you can remove the news feeds pretty easily. Open the following file in your favorite text editor:

`/usr/share/psa-horde/templates/portal/sidebar.inc`

Once the file is open, drop down to line 102 and comment out the entire if() statement (lines 102-117).

**NOTE:** If you upgrade Plesk, this change will most likely be reversed.
