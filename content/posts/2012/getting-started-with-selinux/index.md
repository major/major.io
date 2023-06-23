---
aliases:
- /2012/01/25/getting-started-with-selinux/
author: Major Hayden
date: 2012-01-26 04:28:41
dsq_thread_id:
- 3642806820
tags:
- centos
- command line
- fedora
- red hat
- security
- seliux
- sysadmin
title: Getting started with SELinux
---

I used to be one of those folks who would install Fedora, CentOS, Scientific Linux, or Red Hat and disable SELinux during the installation. It always seemed like SELinux would get in my way and keep me from getting work done.

Later on, I found that one of my servers (which I'd previously secured quite thoroughly) had some rogue processes running that were spawned through httpd. Had I actually been using SELinux in enforcing mode, those processes would have probably never even started.

If you're trying to get started with SELinux but you're not sure how to do it without completely disrupting your server's workflow, these tips should help:

**Get some good reporting and monitoring**

Two of the most handy SELinux tools are [setroubleshoot and setroubleshoot-server][1]. If you're running a server without X, you can use [my guide for configuring setroubleshoot-server][2]. You will receive email alerts within seconds of an AVC denial and the emails should contain tips on how to resolve the denial if the original action should be allowed. If the AVC denial caught something you didn't expect, you'll know about the potential security breach almost immediately.

**Start out with SELinux in permissive mode**

If you're overly concerned about SELinux getting in your way, or if you're enabling SELinux on a server that has been running without SELinux since it was installed, start out with SELinux in permissive mode. To make the change effective immediately, just run:

```
# setenforce 0
# getenforce
Permissive
```


Edit `/etc/sysconfig/selinux` to make it persistent across reboots:

```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
```


**Adjust booleans before adding your own custom modules**

There are a lot of booleans you can toggle to get the functionality you need without adding your own custom SELinux modules with `audit2allow`. If you wanted to see all of the applicable booleans for `httpd`, just use `getsebool`:

```
# getsebool -a | grep httpd
httpd_builtin_scripting --> on
httpd_can_check_spam --> off
httpd_can_network_connect --> on
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_memcache --> off
httpd_can_network_relay --> on
httpd_can_sendmail --> on
... and so on ...
```


Toggling booleans is easy with `togglesebool`:

```
# togglesebool httpd_can_network_memcache
httpd_can_network_memcache: active
```


Now `httpd` can talk to `memcache`. You can also use `setsebool` if you want to be specific about your setting (this is good for scripts):

```
# setsebool httpd_can_network_memcache on
```


**Tracking your history of AVC denials**

All of your AVC denals are logged by `auditd` in `/var/log/audit/audit.log` but it's not the easiest file to read and parse. That's where `aureport` comes in:

```
# aureport --avc | tail -n 5
45. 01/24/2012 04:23:29 postdrop unconfined_u:system_r:httpd_t:s0 4 fifo_file getattr system_u:object_r:postfix_public_t:s0 denied 1061
46. 01/24/2012 04:23:29 postdrop unconfined_u:system_r:httpd_t:s0 2 fifo_file write system_u:object_r:postfix_public_t:s0 denied 1062
47. 01/24/2012 04:23:29 postdrop unconfined_u:system_r:httpd_t:s0 2 fifo_file open system_u:object_r:postfix_public_t:s0 denied 1062
48. 01/24/2012 14:01:58 sendmail unconfined_u:system_r:httpd_t:s0 160 process setrlimit unconfined_u:system_r:httpd_t:s0 denied 1123
49. 01/24/2012 14:01:58 postdrop unconfined_u:system_r:httpd_t:s0 4 dir search system_u:object_r:postfix_public_t:s0 denied 1124
```


**Summary**

There's no need to be scared of or be annoyed by SELinux in your server environment. While it takes some getting used to (and what new software doesn't?), you'll have an extra layer of security and access restrictions which should let you sleep a little better at night.

 [1]: https://fedorahosted.org/setroubleshoot/
 [2]: /2011/09/15/receive-e-mail-reports-for-selinux-avc-denials/