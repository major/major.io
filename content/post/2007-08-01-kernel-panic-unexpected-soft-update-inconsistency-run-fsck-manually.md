---
title: 'Kernel Panic: Unexpected soft update inconsistency; run fsck manually'
author: Major Hayden
type: post
date: 2007-08-01T16:15:54+00:00
url: /2007/08/01/kernel-panic-unexpected-soft-update-inconsistency-run-fsck-manually/
dsq_thread_id:
  - 3644429934
categories:
  - Blog Posts
tags:
  - kernel panics

---
[![kernelpanic-bsdfs54.png][1]][2]

**Operating System:**
  
FreeBSD 5.4

**What happened:**
  
Server went unresponsive at the console and came up with the error upon power cycling.

**Work done:**
  
Ran a fsck from single user mode and then rebooted.

**End result:**
  
The fsck was successful and the server rebooted without an issue.

 [1]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-bsdfs54.thumbnail.png
 [2]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-bsdfs54.png "kernelpanic-bsdfs54.png"