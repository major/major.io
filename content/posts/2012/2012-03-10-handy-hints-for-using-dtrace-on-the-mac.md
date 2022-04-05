---
title: Handy hints for using dtrace on the Mac
author: Major Hayden
type: post
date: 2012-03-10T18:49:59+00:00
url: /2012/03/10/handy-hints-for-using-dtrace-on-the-mac/
dsq_thread_id:
  - 3642806916
categories:
  - Blog Posts
tags:
  - dtrace
  - mac
  - systemtap

---
I'm a big fan of Linux tools which allow you to monitor things in great detail. Some of my favorites are strace, the [systemtap][1] tools, and sysstat. Finding tools similar to these on a Mac is a little more difficult.

There's a great blog post from Brendan Gregg's blog that covers a lot of detail around dtrace and its related tools:

  * <http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scripts-for-mac-os-x/>

One of the handier tools is `iosnoop`. It gives you a much easier to read (and easier to generate) view of the disk I/O on your Mac. If you remember, I talked about how to do this in Linux in the [systemtap][2] post as well as the post about [finding elusive sources of iowait][3]. This could give you a lot of handy information if you're staring at beachballs regularly while your disk drive churns.

 [1]: http://sourceware.org/systemtap/
 [2]: /2010/12/07/tap-into-your-linux-system-with-systemtap/
 [3]: /2008/03/11/hunting-down-elusive-sources-of-iowait/
