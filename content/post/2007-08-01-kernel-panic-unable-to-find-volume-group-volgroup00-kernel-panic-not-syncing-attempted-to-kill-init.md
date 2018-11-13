---
title: 'Kernel Panic: Unable to find volume group “VolGroup00”; Kernel panic – not syncing: Attempted to kill init!'
author: Major Hayden
type: post
date: 2007-08-01T16:18:26+00:00
url: /2007/08/01/kernel-panic-unable-to-find-volume-group-volgroup00-kernel-panic-not-syncing-attempted-to-kill-init/
dsq_thread_id:
  - 3642768833
categories:
  - Blog Posts
tags:
  - kernel panics

---
[![kernelpanic-missingdriver.png][1]][2]

**Operating System:**
  
Red Hat Enterprise Linux 4

**What happened:**
  
The kernel was upgraded and these messages appeared upon reboot.

**Work done:**
  
The modules for the RAID card had to be re-compiled and installed for the new kernel.

**End result:**
  
Once the drivers were installed, the server came up just fine after a reboot.

 [1]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-missingdriver.thumbnail.png
 [2]: http://cdn.cloudfiles.mosso.com/c8031/kernelpanic-missingdriver.png "kernelpanic-missingdriver.png"