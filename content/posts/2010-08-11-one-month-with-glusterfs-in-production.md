---
title: One month with GlusterFS in production
author: Major Hayden
type: post
date: 2010-08-11T13:29:02+00:00
url: /2010/08/11/one-month-with-glusterfs-in-production/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806209
categories:
  - Blog Posts
tags:
  - glusterfs
  - linux
  - network
  - sysadmin
  - web
  - wordpress

---
As many of you might have noticed from my [previous GlusterFS blog post][1] and my [various tweets][2], I've been working with GlusterFS in production for my personal hosting needs for just over a month. I've also been learning quite a bit from some of the folks in the [#gluster][3] channel on [Freenode][4]. On a few occasions I've even been able to help out with some configuration problems from other users.

There has been quite a bit of interest in GlusterFS as of late and I've been inundated with questions from coworkers, other system administrators and developers. Most folks want to know about its reliability and performance in demanding production environments. I'll try to do my best to cover the big points in this post.

**First off, here's now I'm using it in production:** I have two web nodes that keep content in sync for various web sites. They each run a GlusterFS server instance and they also mount their GlusterFS share. I'm using the [replicate translator][5] to keep both web nodes in sync with client side replication.

Here are my impressions after a month:

**I/O speed is often tied heavily to network throughput**

This one may seem obvious, but it's not always true in all environments. If you deal with a lot of small files like I do, a 40mbit/sec link between the Xen guests is plenty. Adding extra throughput didn't add any performance to my servers. However, if you wrangle large files on your servers regularly, you may want to consider higher throughput links between your servers. I was able to push just under 900mbit/sec by using dd to create a large file within a GlusterFS mount.

**Network and I/O latency are big factors for small file performance**

If you have a busy network and the latency creeps up from time to time, you'll find that your small file performance will drop significantly (especially with the replicate translator). Without getting too nerdy (you're welcome to read the [technical document on replication][6]), replication is an intensive process. When a file is accessed, the client goes around to each server node to ensure that it not only has a copy of the file being read, but that it has the _correct_ copy. If a server didn't save a copy of a file (due to disk failure or the server being offline when the file was written), it has to be synced across the network from one of the good nodes.

When you write files on replicated servers, the client has to roll through the same process first. Once that's done, it has to lock the file, write to the change log, then do the write operation, drop the change log entries, and then unlock the file. All of those operations must be done on _all of the servers_. High latency networks will wreak havoc on this process and cause it to take longer than it should.

It's quite obvious that if you have a fast, low-latency network between your servers, slow disks can still be a problem. If the client is waiting on the server nodes' disks to write data, the read and write performance will suffer. I've tested this in environments with fast networks and very busy RAID arrays. Even if the network was very underutilized, slow disks could cut performance drastically.

**Monitoring GlusterFS isn't easy**

When the client has communication problems with the server nodes, some weird things can happen. I've seen situations where the client loses connections to the servers (see the next section on reliability) and the client mount simply hangs. In other situations, the client has been knocked offline entirely and the process is missing from the process tree by the time I logged in. Your monitoring will need to ensure that the mount is active and is responding in a timely fashion.

There's a [handy script][7] which allows you to monitor GlusterFS mounts via nagios that Ian Rogers put together. Also, you can get some historical data with [acrollet's munin-glusterfs plugin][8].

**GlusterFS 3.x is pretty reliable**

When I first started working with GlusterFS, I was using a version from the 2.x tree. The Fedora package maintainer hadn't updated the package in quite some time, but I figured it should work well enough for my needs. I found that the small file performance was lacking and the nodes often had communication issues when many files were being accessed or written simultaneously. This improved when I built my own RPMs of 3.0.4 (and later 3.0.5) and began using those instead.

I did some failure testing by hard cycling the server and client nodes and found some interesting results. First off, abruptly pulling clients had no effects on the other clients or the server nodes. The connection eventually timed out and the servers logged the timeout as expected.

Abruptly pulling servers led to some mixed results. In the 2.x branch, I saw client hangs and timeouts when I abruptly removed a server. This appears to be mostly corrected in the 3.x branch. If you're using replicate, it's important to keep in mind that the first server volume listed in your client's volume file is the one that will be coordinating the file and directory locking. Should that one fall offline quickly, you'll see a hiccup in performance for a brief moment and the next server will be used for coordinating the locking. When your original server comes back up, the locking coordination will shift back.

**Conclusion**

I'm really impressed with how much GlusterFS can do with the simplicity of how it operates. Sure, you can get better performance and more features (sometimes) from something like Lustre or GFS2, but the amount of work required to stand up that kind of cluster isn't trivial. GlusterFS really only requires that your kernel have FUSE support (it's been in mainline kernels since 2.6.14).

There are some things that GlusterFS really needs in order to succeed:

  * **Documentation** - The current documentation is often out of date and confusing. I've even found instances where the documentation contradicts itself. While there are some good technical documents about the design of some translators, they really ought to do some more work there.
  * **Statistics gathering** - It's very difficult to find out what GlusterFS is doing and where it can be optimized. Profiling your environment to find your bottlenecks is nearly impossible with the 2.x and 3.x branches. It doesn't make it easier when some of the performance translators actually decrease performance.
  * **Community involvement** - This ties back into the documentation part a little, but it would be nice to see more participation from Gluster employees on IRC and via the mailing lists. They're a little better with mailing list responses than other companies I've seen, but there is still room for improvement.

If you're considering GlusterFS for your servers but you still have more questions, feel free to leave a comment or find me on Freenode (I'm 'rackerhacker').

 [1]: /2010/05/27/glusterfs-on-the-cheap-with-rackspaces-cloud-servers-or-slicehost/
 [2]: http://twitter.com/rackerhacker
 [3]: http://java.freenode.net/index.php?channel=gluster
 [4]: http://freenode.net/
 [5]: http://www.gluster.com/community/documentation/index.php/Translators/cluster/replicate
 [6]: http://ftp.zresearch.com/pub/gluster/glusterfs/doc/afr.pdf
 [7]: http://www.sirgroane.net/2010/04/monitoring-gluster-with-nagios/
 [8]: http://github.com/acrollet/munin-glusterfs
