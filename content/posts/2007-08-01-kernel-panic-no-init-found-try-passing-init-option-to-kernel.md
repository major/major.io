---
title: 'Kernel panic: No init found. Try passing init= option to kernel'
author: Major Hayden
type: post
date: 2007-08-01T12:26:14+00:00
url: /2007/08/01/kernel-panic-no-init-found-try-passing-init-option-to-kernel/
dsq_thread_id:
  - 3669570923
categories:
  - Blog Posts
tags:
  - kernel panics

---
[![kernelpanic-noinit.png][1]][2]

**Operating System:**
  
Red Hat Enterprise Linux 2.1

**What happened:**
  
The server was powered down gracefully, moved to a new rack, and then powered on.

**Work done:**
  
Ran a fsck from the rescue environment and it eventually completed, but the server would not boot properly.

**End result:**
  
The hard drive was in the process of failing, so it was replaced and the operating system was installed onto the new disk. The old disk was stable enough to be mounted read-only, and much of the data was salvaged.

 [1]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-noinit.thumbnail.png
 [2]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-noinit.png "kernelpanic-noinit.png"