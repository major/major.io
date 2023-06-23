---
aliases:
- /2009/11/03/changing-the-time-zone-in-irssi/
author: Major Hayden
date: 2009-11-03 14:34:42
dsq_thread_id:
- 3642805831
tags:
- irc
- irssi
- linux
- time zone
title: Changing the time zone in irssi
---

I usually set the time zone on my servers to UTC, but that makes it a bit confusing for me when I use irssi. If you have perl support built into irssi, you can run these commands to alter your time zone within irssi only:

<pre lang="html">/load perl
/script exec $ENV{'TZ'}='(nameofyourtimezone)';</pre>

For example, I'm in Central Time, so I'd use:

<pre lang="html">/script exec $ENV{'TZ'}='CST6CDT';</pre>

To update the time in your status bar, simply /whois yourself and you should see the updated time zone. If you want more handy irssi tips, look no further than [irssi's documentation][1].

 [1]: http://irssi.org/documentation/tips