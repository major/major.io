---
title: Enforcing mode requested but no policy loaded. Halting now.
author: Major Hayden
date: 2007-10-17T18:17:22+00:00
url: /2007/10/17/enforcing-mode-requested-but-no-policy-loaded-halting-now/
dsq_thread_id:
  - 3642770449
tags:
  - emergency
  - kernel panics
  - security

---
Here's a pretty weird kernel panic that I came across the other day:

```
Enforcing mode requested but no policy loaded. Halting now.
Kernel panic - not syncing: Attempted to kill init!
```

This usually means that you've set SELINUX in enforcing mode within /etc/sysconfig/selinux or /etc/selinux/selinux.conf but you don't have the appropriate SELINUX packages installed. To fix the issue, boot the server into the Red Hat rescue environment and disable SELINUX until you can install the proper packages that contain the SELINUX targeted configuration.

_This kernel panic appeared on a Red Hat Enterprise Linux 4 Update 5 server._
