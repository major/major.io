---
aliases:
- /2008/06/20/rebuilding-statistics-from-previous-months-on-plesk-83/
author: Major Hayden
date: 2008-06-20 17:00:06
tags:
- awstats
- plesk
title: Rebuilding statistics from previous months on Plesk 8.3
---

There was a bug in versions of Plesk prior to 8.3 where the AWStats statistics for the previous months were unavailable. It was a bug within Plesk's AWStat's implementation, and it was fixed in Plesk 8.3.

However, the fix only corrected the issue moving forward after the upgrade. There was no automated way to rebuild the previous months' statistics, _even though the AWStats data was right there on the disk_!

I saw this blog post about the issue, and the fix is quite elegant:

[Plesk 8.3 AWStats on Linux - Rebuilding Previous Month Statistics][1]

 [1]: http://www.europheus.com/?p=67