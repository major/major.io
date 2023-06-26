---
aliases:
- /2010/12/02/keep-web-servers-in-sync-with-drbd-and-ocfs2/
author: Major Hayden
date: 2010-12-03 02:01:12
featured_image: /wp-content/uploads/2010/12/drbd-and-ocfs2-e1291337653403.png
tags:
- command line
- filesystem
- kernel
- network
- sysadmin
title: Keep web servers in sync with DRBD and OCFS2
---

The [guide to redundant cloud hosting][1] that I wrote recently will need some adjustments as I've fallen hard for the performance and reliability of DRBD and OCFS2. As a few of my sites were gaining in popularity, I noticed that GlusterFS simply couldn't keep up. High I/O latency and broken replication threw a wrench into my love affair with GlusterFS and I knew there had to be a better option.

I've shared my configuration with my coworkers and I've received many good questions about it. Let's get to the Q&A:

**How does the performance compare to GlusterFS?**

On Gluster's best days, the data throughput speeds were quite good, but the latency to retrieve the data was often much too high. Page loads on this site were taking upwards of 3-4 seconds with GlusterFS latency accounting for well over 75% of the delays. For small files, GlusterFS's performance was about 20-25x slower than accessing the disk natively. The performance hit for DRBD and OCFS2 is usually between 1.5-3x for small files and difficult to notice for large file transfers.

**Couldn't you keep the data separate and then sync it with rsync?**

Everyone knows that rsync can be a resource consuming monster and it seems wasteful to call rsync via a cron job to keep my data in sync. There are some periods of the day where the actual data on the web root rarely changes. There are other times where it changes rapidly and I'd end up with nodes out of sync for a few minutes.

To get the just-in-time synchronization that I want, I'd have to run rsync at least once a minute. If the data isn't changing over a long period, rsync would end up crushing the disk and consuming CPU for no reason. DRBD only syncs data when data changes. Also, all reads with DRBD are done locally. This makes is a highly efficient and effective choice for instant synchronization.

**Why OCFS2? Isn't that overkill?**

When you use DRBD in dual-primary mode, it's functionally equivalent to having a raw storage device (like a SAN) mounted in two places. If you threw an ext4 filesystem onto a LUN on your SAN and then mounted it on two different servers, you'd be in bad shape very quickly. Non-clustered filesystems like ext3 or ext4 can't handle being mounted in more than one environment.

OCFS2 is built primarily to be mounted in more than one place and it comes with its own distributed locking manager (DLM). The configuration files for OCFS2 are extremely simple and you mount it like any other filesystem. It's been part of the mainline Linux kernel since 2.6.19.

**What happens when you lose one of the nodes?**

The configuration shown above can operate with just one node in an emergency. When the failed node comes back online, DRBD will resync the block device and you can mount the OCFS2 filesystem as you normally would.

**You're using an Oracle product? Really?**

You've got me there. I'm not a fan of how they treat the open source community with regards to some of their projects, but the OCFS2 filesystem is robust, free, and it meets my needs.

**Where's the how-to?**

It's coming soon! Stay tuned.

 [1]: /redundant-cloud-hosting-configuration-guide/