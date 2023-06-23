---
aliases:
- /2008/06/27/mysqltuner-is-now-a-fedora-9-package/
author: Major Hayden
date: 2008-06-27 17:16:56
dsq_thread_id:
- 3678981397
tags:
- database
- fedora
- mysql
- mysqltuner
title: MySQLTuner is now a Fedora 9 package!
---

Thanks to [some work started by Ville Skyttä][1], MySQLTuner is now included in Fedora 9 repositories:

```
# cat /etc/fedora-release
Fedora release 9 (Sulphur)
# yum info mysqltuner
Loaded plugins: fastestmirror, priorities, refresh-packagekit
Loading mirror speeds from cached hostfile
 * updates: mirrors.usc.edu
 * fedora: mirror.unl.edu
 * livna: mirrors.tummy.com
Available Packages
Name       : mysqltuner
Arch       : noarch
Version    : 0.9.1
Release    : 4
Size       : 11 k
Repo       : updates
Summary    : MySQL high performance tuning script
URL        : http://mysqltuner.com/
License    : GPLv3+
summary: MySQLTuner is a MySQL high performance tuning script written in perl that will provide you with a snapshot of a MySQL server's health. Based
           : on the statistics gathered, specific recommendations will be provided that will increase a MySQL server's efficiency and performance.  The
           : script gives you automated MySQL tuning that is on the level of what you would receive from a MySQL DBA.`

In addition to Ville, I'd like to thank Jason Tibbitts for reviewing and approving the new package.
```

 [1]: https://bugzilla.redhat.com/show_bug.cgi?id=452172