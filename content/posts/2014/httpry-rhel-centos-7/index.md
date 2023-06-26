---
aliases:
- /2014/08/13/httpry-rhel-centos-7/
author: Major Hayden
date: 2014-08-13 13:20:28
tags:
- centos
- fedora
- httpry
- network
- redhat
title: httpry 0.1.8 available for RHEL and CentOS 7
---

Red Hat Enterprise Linux and CentOS 7 users can now install [httpry][1] [0.1.8][2] in EPEL 7 Beta. The new httpry version is also available for RHEL/CentOS 6 and supported Fedora versions (19, 20, 21 branched, and rawhide).

Configuring EPEL on a RHEL/CentOS server is easy. [Follow the instructions][4] on EPEL's site and install the epel-release RPM that matches your OS release version.

If you haven't used httpry before, [check the output][5] on Jason Bittel's site. It's a handy way to watch almost any type of HTTP server and see the traffic in an easier to read (and easier to grep) format.

 [1]: https://github.com/jbittel/httpry
 [2]: https://github.com/jbittel/httpry/blob/master/doc/ChangeLog
 [4]: https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F
 [5]: http://dumpsterventures.com/jason/httpry/