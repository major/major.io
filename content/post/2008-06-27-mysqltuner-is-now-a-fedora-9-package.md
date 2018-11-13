---
title: MySQLTuner is now a Fedora 9 package!
author: Major Hayden
type: post
date: 2008-06-27T17:16:56+00:00
url: /2008/06/27/mysqltuner-is-now-a-fedora-9-package/
dsq_thread_id:
  - 3678981397
categories:
  - Blog Posts
tags:
  - database
  - fedora
  - mysql
  - mysqltuner

---
Thanks to [some work started by Ville Skyttä][1], MySQLTuner is now included in Fedora 9 repositories:

`# cat /etc/fedora-release<br />
Fedora release 9 (Sulphur)<br />
# yum info mysqltuner<br />
Loaded plugins: fastestmirror, priorities, refresh-packagekit<br />
Loading mirror speeds from cached hostfile<br />
 * updates: mirrors.usc.edu<br />
 * fedora: mirror.unl.edu<br />
 * livna: mirrors.tummy.com<br />
Available Packages<br />
Name       : mysqltuner<br />
Arch       : noarch<br />
Version    : 0.9.1<br />
Release    : 4<br />
Size       : 11 k<br />
Repo       : updates<br />
Summary    : MySQL high performance tuning script<br />
URL        : http://mysqltuner.com/<br />
License    : GPLv3+<br />
Description: MySQLTuner is a MySQL high performance tuning script written in perl that will provide you with a snapshot of a MySQL server's health. Based<br />
           : on the statistics gathered, specific recommendations will be provided that will increase a MySQL server's efficiency and performance.  The<br />
           : script gives you automated MySQL tuning that is on the level of what you would receive from a MySQL DBA.`

In addition to Ville, I'd like to thank Jason Tibbitts for reviewing and approving the new package.

 [1]: https://bugzilla.redhat.com/show_bug.cgi?id=452172
