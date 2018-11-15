---
title: Reduce disk I/O for small reads using memory
author: Major Hayden
type: post
date: 2008-08-07T17:00:27+00:00
url: /2008/08/07/reduce-disk-io-for-small-reads-using-memory/
dsq_thread_id:
  - 3642772096
categories:
  - Blog Posts
tags:
  - iowait
  - kernel
  - memory

---
Many applications that are used on a standard server perform quite a few of small writes to the disk (like MySQL or Apache). These writes can pile up and limit the performance of your applications. If you have kernel 2.6.9 or later, you can adjust how these small writes are handled to allow for better performance.

There's two main kernel variables to know:

**vm.dirty_ratio** - The highest % of your memory that can be used to hold dirty data. If you set this to a low value, the kernel will flush small writes to the disk more often. Higher values allow the small writes to stack up in memory. They'll go to the disk in bigger chunks.

**vm.dirty\_background\_ratio** - The lowest % of your memory where pdflush is told to stop when it is writing dirty data. You'll want to keep this set as low as possible.

These might confuse you. In short, when your memory begins filling with little pieces of data that needs to be written to the disk, it will keep filling until it reaches the dirty\_ratio. At that point, pdflush will start up, and it will write data until it reduces the dirty data to the value set by dirty\_background_ratio.

Stock 2.6.9 kernels have a dirty\_background\_ratio of 10% and a dirty\_ratio of 40%. Some distributions tweak these defaults to something different, so you may want to review the settings on your system. On a system with heavy disk I/O, you can increase the dirty\_ratio and reduce the dirty\_background\_ratio. A little experimentation may be necessary to find the perfect setting for your server.

If you want to play with the variables, just use your standard echo:

```
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 60 > /proc/sys/vm/dirty_ratio
```

Once you've found the right setting, you can set it permanently by adding lines to your /etc/sysctl.conf:

```
vm.dirty_background_ratio = 5
vm.dirty_ratio = 60
```

If you have a reliable server with a good RAID card and power supply, you could set the dirty\_ratio to 100 and the dirty\_background_ratio to 1. This was recommended by a buddy of mine who runs quite a few servers running virtual machines.
