---
aliases:
- /2007/06/14/rebuild-rpm-file-permissions-and-ownerships/
author: Major Hayden
date: 2007-06-14 22:36:47
dsq_thread_id:
- 3642773914
tags:
- command line
- emergency
- security
title: Rebuild RPM file permissions and ownerships
---

If you find that someone has done a recursive chmod or chown on a server, don't fret. You can set almost everything back to its original permissions and ownership by doing the following:

```
rpm -qa | xargs rpm --setperms --setugids
```

Depending on how many packages are installed as well as the speed of your disk I/O, this may take a while to complete.