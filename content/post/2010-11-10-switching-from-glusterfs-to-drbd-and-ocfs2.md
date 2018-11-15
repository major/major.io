---
title: Switching from GlusterFS to DRBD and OCFS2
author: Major Hayden
type: post
date: 2010-11-10T13:55:50+00:00
url: /2010/11/10/switching-from-glusterfs-to-drbd-and-ocfs2/
dsq_thread_id:
  - 3642806318
categories:
  - Blog Posts
tags:
  - command line
  - drbd
  - filesystem
  - glusterfs
  - ocfs2
  - sysadmin
  - web

---
As my uptime reports have shown, and as some of you have reported, my blog's load time has increased steadily over the past few weeks. It turns out that one of my VM's was on a physical machine that had some trouble and I was reaching a point where GlusterFS's replicate functionality couldn't meet my performance needs.

Instead of using [GlusterFS][1] as I had before in my [redundant cloud hosting guide][2], I decided to use [DRBD][3] in dual-primary mode with [OCFS2][4] as the clustering filesystem on top of it. The performance is quite good so far:

<div id="attachment_1851" style="width: 630px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/pingdomresponsetime-rackerhacker.com_.png"><img src="/wp-content/uploads/2010/11/pingdomresponsetime-rackerhacker.com_.png" alt="Pingdom Response Time Graph for rackerhacker.com" title="Pingdom Response Time Graph for rackerhacker.com" width="620" height="339" class="size-full wp-image-1851" /></a>

  <p class="wp-caption-text">
    Pingdom Response Time Graph for rackerhacker.com
  </p>
</div>

I switched over the DNS late last night and the response time has fallen from the two to three second range (during times of low load) to right around one second per request. In addition to the reduced load times, I can support higher concurrency without significant performance degradation.

Don't worry - I'll make a detailed post on this topic later along with a guide on how to set it up yourself.

 [1]: http://en.wikipedia.org/wiki/GlusterFS
 [2]: /redundant-cloud-hosting-configuration-guide/
 [3]: http://en.wikipedia.org/wiki/DRBD
 [4]: http://en.wikipedia.org/wiki/OCFS
