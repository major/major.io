---
aliases:
- /2013/04/15/seriously-stop-disabling-selinux/
author: Major Hayden
date: 2013-04-16 04:40:10
dsq_thread_id:
- 3642807184
tags:
- centos
- command line
- fedora
- general advice
- redhat
- security
- selinux
title: Seriously, stop disabling SELinux
---

After many discussions with fellow Linux users, I've come to realize that most seem to disable SELinux rather than understand why it's denying access. In an effort to turn the tide, I've created a new site as a public service to SELinux cowards everywhere: [stopdisablingselinux.com][1].

Here are some relatively useful SELinux posts from the blog:

  * [Getting started with SELinux][2]
  * [Receive email reports for SELinux AVC denials][3]

* * *

**Edit:** The goal of the post was to poke some fun at system administrators who disable SELinux immediately without learning how it works or why they're seeing certain operations being denied. Obviously, if your particular workload or demands don't allow for the use of SELinux, then I'm going to be the last person to encourage you to use it. Many system administrators have found that it doesn't provide a good ratio of work required to benefit gained, which I totally understand.

 [1]: http://stopdisablingselinux.com/
 [2]: /2012/01/25/getting-started-with-selinux/
 [3]: /2011/09/15/receive-e-mail-reports-for-selinux-avc-denials/