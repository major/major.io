---
title: 'EXT3-fs error: ext3_check_descriptors / group descriptors corrupted'
author: Major Hayden
type: post
date: 2007-08-01T12:28:42+00:00
url: /2007/08/01/ext3-fs-error-ext3_check_descriptors-group-descriptors-corrupted/
dsq_thread_id:
  - 3679040026
categories:
  - Blog Posts
tags:
  - emergency
  - kernel panics

---
[![kernelpanic-badfs.png][1]][2]

**Operating System:**
  
Red Hat Enterprise Linux 4 Update 5

**What happened:**
  
The server was abruptly powered down, disassembled, and re-assembled.

**Work done:**
  
Ran a fsck from the rescue environment and it eventually completed (after much corruption was found), but the server would not boot properly.

**End result:**
  
The damage to the filesystem could not be adequately repaired as the errors were very extensive. The RAID array had to be rebuilt and a new OS was installed.

 [1]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-badfs.thumbnail.png
 [2]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-badfs.png "kernelpanic-badfs.png"