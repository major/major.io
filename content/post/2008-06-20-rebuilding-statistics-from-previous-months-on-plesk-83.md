---
title: Rebuilding statistics from previous months on Plesk 8.3
author: Major Hayden
type: post
date: 2008-06-20T17:00:06+00:00
url: /2008/06/20/rebuilding-statistics-from-previous-months-on-plesk-83/
dsq_thread_id:
  - 3664268107
categories:
  - Blog Posts
tags:
  - awstats
  - plesk

---
There was a bug in versions of Plesk prior to 8.3 where the AWStats statistics for the previous months were unavailable. It was a bug within Plesk's AWStat's implementation, and it was fixed in Plesk 8.3.

However, the fix only corrected the issue moving forward after the upgrade. There was no automated way to rebuild the previous months' statistics, _even though the AWStats data was right there on the disk_!

I saw this blog post about the issue, and the fix is quite elegant:

[Plesk 8.3 AWStats on Linux - Rebuilding Previous Month Statistics][1]

 [1]: http://www.europheus.com/?p=67
