---
title: 'Fedora 11 httpd: alloc_listener: failed to get a socket for (null)'
author: Major Hayden
type: post
date: 2009-08-14T17:14:02+00:00
url: /2009/08/14/fedora-11-httpd-alloc_listener-failed-to-get-a-socket-for-null/
dsq_thread_id:
  - 3642805715
categories:
  - Blog Posts
tags:
  - apache
  - emergency
  - fedora
  - kernel
  - yum

---
If you use Fedora 11 in a virtualized environment, you may have seen this error recently if you've updated to apr-1.3.8-1:

<pre lang="html">[root@f11 ~]# /etc/init.d/httpd start
Starting httpd: [Fri Aug 14 17:05:24 2009] [crit] (22)Invalid argument: alloc_listener: failed to get a socket for (null)
Syntax error on line 134 of /etc/httpd/conf/httpd.conf:
Listen setup failed
                                                           [FAILED]</pre>

The issue is related to three kernel calls that are used in apr-1.3.8-1: accept4(), dup3() and epoll_create1(). Without these calls, apache is unable to start.

**<u>Update on August 17, 2009:</u> the Fedora team has [pushed apr-1.3.8-2 into the stable repositories][1] for Fedora 11, which eliminates the need for the temporary fix shown below.**

**Deprecated solution:** There is a [bug open][2] with the Fedora team, and there is a [temporary fix][3] available:

<pre lang="html">yum --enablerepo=updates-testing update apr</pre>

 [1]: https://bugzilla.redhat.com/show_bug.cgi?id=516331#c12
 [2]: https://bugzilla.redhat.com/show_bug.cgi?id=516331
 [3]: https://bugzilla.redhat.com/show_bug.cgi?id=516331#c10
