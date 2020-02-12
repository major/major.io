---
title: Improving LXC template security
author: Major Hayden
type: post
date: 2015-06-18T19:52:11+00:00
url: /2015/06/18/improving-lxc-template-security/
dsq_thread_id:
  - 3859849191
categories:
  - Blog Posts
tags:
  - centos
  - containers
  - development
  - fedora
  - lxc
  - red hat
  - security
  - ubuntu

---
[<img src="/wp-content/uploads/2015/06/containers-300x276.png" alt="LXC logo" width="300" height="276" class="alignright size-medium wp-image-5669" srcset="/wp-content/uploads/2015/06/containers-300x276.png 300w, /wp-content/uploads/2015/06/containers.png 318w" sizes="(max-width: 300px) 100vw, 300px" />][1]I've been getting involved with the [Fedora Security Team][2] lately and we're working as a group to crush security bugs that affect Fedora, CentOS (via EPEL) and Red Hat Enterprise Linux (via EPEL). During some of this work, I stumbled upon a [group of Red Hat Bugzilla tickets][3] talking about LXC template security.

The gist of the problem is that there's a wide variance in how users and user credentials are handled by the different LXC templates. An [inventory of the current situation][4] revealed some horrifying problems with many OS templates.

Many of the templates set an **awful** default root password, like rooter, toor, or root. Some of the others create a regular user with sudo privileges and give it a default, predictable password unless the user specifies otherwise.

There are some bright spots, though. Fedora and CentOS templates will accept a root password from the user during the build and set a randomized password for the root user if a password isn't specified. Ubuntu Cloud takes another approach by locking out the root user and requiring cloud-init configuration data to configure the root account.

I kicked off a [mailing list thread][5] and wrote a [terrible pull request][6] to get things underway. Stéphane Graber requested that all templates use a shared script to handle users and credentials via standardized environment variables and command line arguments. In addition, all passwords for users (regular or root) should be empty with password-less logins disabled. Those are some reasonable requests and I'm working on a shell script that's easy to import into LXC templates.

There's also a push to remove sshd from all LXC templates by default, but I'm hoping to keep that one tabled until the credentials issue is solved.

If you'd like to help out with the effort, let me know! I'll probably get some code up onto Github soon and as for comments.

 [1]: /wp-content/uploads/2015/06/containers.png
 [2]: https://fedoraproject.org/wiki/Security_Team
 [3]: https://bugzilla.redhat.com/show_bug.cgi?id=1132001
 [4]: https://fedoraproject.org/wiki/LXC_Template_Security_Improvements
 [5]: https://lists.linuxcontainers.org/pipermail/lxc-devel/2015-June/011883.html
 [6]: https://github.com/lxc/lxc/pull/574
