---
aliases:
- /2014/07/03/avc-denied-dyntransition-from-sshd/
author: Major Hayden
date: 2014-07-03 19:52:51
dsq_thread_id:
- 3646864438
tags:
- fedora
- security
- selinux
title: 'AVC: denied dyntransition from sshd'
---

I've been working with some Fedora environments in chroots and I ran into a peculiar SELinux AVC denial a short while ago:

```
avc:  denied  { dyntransition } for  pid=809 comm="sshd" scontext=system_u:system_r:kernel_t:s0 tcontext=system_u:system_r:sshd_net_t:s0 tclass=process
```


The ssh daemon is running on a non-standard port but I verified that the port is allowed with `semanage port -l`. The target context of _sshd\_net\_t_ from the AVC seems sensible for the ssh daemon. I started to wonder if a context wasn't applied correctly to the sshd excutable itself, so I checked within the chroot:

```
# ls -alZ /usr/sbin/sshd
-rwxr-xr-x. 1 root root system_u:object_r:sshd_exec_t:SystemLow 652816 May 15 03:56 /usr/sbin/sshd
```


That's what it should be. I double-checked my running server (which booted a squashfs containing the chroot) and saw something wrong:

```
# ls -alZ /usr/sbin/sshd
-rwxr-xr-x. root root system_u:object_r:file_t:s0      /usr/sbin/sshd
```


How did _file_t_ get there? It turns out that I was using rsync to drag data out of the chroot and I forgot to use the `--xattrs` argument with rsync.