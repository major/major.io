---
aktt_notify_twitter:
- false
aliases:
- /2010/08/13/very-unscientific-glusterfs-benchmarks/
author: Major Hayden
date: 2010-08-13 20:55:24
tags:
- benchmarks
- glusterfs
- linux
- sysadmin
title: Very unscientific GlusterFS benchmarks
---

I've been getting requests for GlusterFS benchmarks from every direction lately and I've been a bit slow on getting them done. You may suspect that you know the [cause of the delays][1], and you're probably correct. ;-)

Quite a few different sites argue that the default GlusterFS performance translator configuration from glusterfs-volgen doesn't allow for good performance. You can find other sites which say you should stick with the defaults that come from the script. I decided to run some simple tests to see which was true in my environment.

Here's the testbed:

  * GlusterFS 3.0.5 running on RHEL 5.4 Xen guests with ext3 filesystems
  * one GlusterFS client and two GlusterFS servers are running in separate Xen guests
  * cluster/replicate translator is being used to keep the servers in sync
  * the instances are served by a gigabit network

It's about time for some pretty graphs, isn't it?

<div style="text-align: center;">
  <a href="/wp-content/uploads/2010/08/iozone-rereader-glusterfs-default-translators.png"><img src="/wp-content/uploads/2010/08/iozone-rereader-glusterfs-default-translators-255x300.png" alt="iozone re-reader benchmark results with default glusterfs translators from glusterfs-volgen" title="iozone re-reader benchmark results with default glusterfs translators from glusterfs-volgen" width="255" height="300" class="alignnone size-medium wp-image-1720" style="padding-right: 25px;" srcset="/wp-content/uploads/2010/08/iozone-rereader-glusterfs-default-translators-255x300.png 255w, /wp-content/uploads/2010/08/iozone-rereader-glusterfs-default-translators.png 856w" sizes="(max-width: 255px) 100vw, 255px" /></a><a href="/wp-content/uploads/2010/08/iozone-rereader-glusterfs-without-translators.png"><img src="/wp-content/uploads/2010/08/iozone-rereader-glusterfs-without-translators-254x300.png" alt="iozone re-reader benchmark results with no glusterfs translators" title="iozone re-reader benchmark results with no glusterfs translators" width="254" height="300" class="alignnone size-medium wp-image-1721" srcset="/wp-content/uploads/2010/08/iozone-rereader-glusterfs-without-translators-254x300.png 254w, /wp-content/uploads/2010/08/iozone-rereader-glusterfs-without-translators.png 855w" sizes="(max-width: 254px) 100vw, 254px" /></a>
</div>

<div style="clear:both;">
</div>

The test run on the left used default stock [client][2] and [server][3] volume files as they come from glusterfs-volgen. The test run on the right used a [client volume file with no performance translators][4] (the server volume file was untouched). Between each test run, the GlusterFS mount was unmounted and remounted. I repeated this process four times (for a total of five runs) and averaged the data.

_You'll have to forgive the color mismatches and the lack of labeling on the legend (that's KB/sec transferred) as I'm far from an Excel expert._

The graphs show that running without any translators at all will drastically hinder read caching in GlusterFS - exactly as I expected. Without any translators, the performance is very even across the board. Since my instances had 256MB of RAM each, their iocache translator was limited to about 51MB of cache. That's reflected in the graph on the left - look for the vertical red/blue divider between the 32MB and 64MB file sizes. I'll be playing around with that value soon to see how it can improve performance for large and small files.

Keep in mind that this test was very unscientific and your results may vary depending on your configuration. While I hope to have more detailed benchmarks soon, this should help some of the folks who have been asking for something basic and easy to understand.

 [1]: /2010/07/14/version-2-0-has-arrived/
 [2]: http://pastebin.com/MAX1kWDg
 [3]: http://pastebin.com/uyE6qkZ6
 [4]: http://pastebin.com/gqMquRpB