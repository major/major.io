---
aktt_notify_twitter:
- false
aliases:
- /2008/12/03/reducing-inode-and-dentry-caches-to-keep-oom-killer-at-bay/
author: Major Hayden
date: 2008-12-04 00:44:20
tags:
- emergency
- kernel
title: Reducing inode and dentry caches to keep OOM killer at bay
---

When it comes to frustrating parts of the Linux kernel, [OOM killer][1] takes the cake. If it finds that applications are using too much memory on the server, it will kill process abruptly to free up memory for the system to use. I spent much of this week wrestling with a server that was in the clutches of OOM killer.

There are a few processes on the server that keep it fairly busy. Two of the processes are vital to the server's operation &#8211; if they are stopped, lots of work is required to get them running properly again. I found that a certain java process was being killed by OOM killer regularly, and another perl process was being killed occasionally.

Naturally, my disdain for java made me think that the java process was the source of the issue. The process was configured to use a small amount of RAM, so it was ruled out. The other perl process used even less memory, so it was ruled out as well. When I checked the sysstat data with sar, I found that the server was only using about 2-3GB out of 4GB of physical memory at the time when OOM killer was started. _At this point, I was utterly perplexed._

I polled some folks around the office and gathered some ideas. After putting some ideas together, I found that the server was actually caching too much data in the `ext3_inode_cache` and `dentry_cache`. These caches hold recently accessed files and directories on the server, and they're purged as the files and directories become stale. Since the operations on the server read and write large amounts of data locally and via NFS, I knew these caches had to be gigantic. If you want to check your own caches, you can use the `slabtop` command. For those who like things more difficult, you can also `cat` the contents of `/proc/slabinfo` and grep for the caches that are important to you.

An immense amount of Googling revealed very little, but I discovered a [dirty hack][2] to fix the issue **(don't run this yet)**:

<pre lang="html">echo 1 > /proc/sys/vm/drop_caches  # free pagecache
     [OR]
echo 2 > /proc/sys/vm/drop_caches  # free dentries and inodes
     [OR]
echo 3 > /proc/sys/vm/drop_caches  # free pagecache, dentries and inodes
sync  # forces the dump to be destructive</pre>

**<u>There are huge consequences to dumping these caches and running `sync`.</u>** If you are writing data at the time you run these commands, you'll actually be dumping the data out of the filesystem cache before it reaches the disk, which could lead to very bad things.

While discussing the issue with a coworker, he [found a different method][3] for correcting the issue that was **much** safer. You can echo values into **/proc/sys/vm/vfs\_cache\_pressure** to tell the kernel what priority it should take when clearing out the inode/dentry caches. LinuxInsight explains the range of values well:

> At the default value of vfs\_cache\_pressure = 100 the kernel will attempt to reclaim dentries and inodes at a &#8220;fair&#8221; rate with respect to pagecache and swapcache reclaim. Decreasing vfs\_cache\_pressure causes the kernel to prefer to retain dentry and inode caches. Increasing vfs\_cache\_pressure beyond 100 causes the kernel to prefer to reclaim dentries and inodes.

In short, values less than 100 won't reduce the caches very much as all. Values over 100 will signal to the kernel that you want to clear out the caches at a higher priority. I found that no matter what value you use, the kernel clears the caches at a slow rate. I've been using a value of 10000 on the server I talked about earlier in the article, and it has kept the caches down to a reasonable level.

 [1]: http://linux-mm.org/OOM_Killer
 [2]: http://www.linuxinsight.com/proc_sys_vm_drop_caches.html
 [3]: http://www.linuxinsight.com/proc_sys_vm_vfs_cache_pressure.html