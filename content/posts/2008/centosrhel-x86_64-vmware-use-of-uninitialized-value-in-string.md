---
aliases:
- /2008/09/03/centosrhel-x86_64-vmware-use-of-uninitialized-value-in-string/
author: Major Hayden
date: 2008-09-03 17:06:20
dsq_thread_id:
- 3642771926
tags:
- perl
- vmware
title: 'CentOS/RHEL x86_64 + VMWare: Use of uninitialized value in string'
---

I was working with a CentOS 5 x86_64 installation running VMWare server last week when I stumbled upon this error:

```
Use of uninitialized value in string eq at
/usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/VMware/VmPerl.pm line 114.
```

You can run the vmware-cmd application with this error (it's not a fatal error) and keep going with your normal business. However, if you want to remove the error, comment out lines 114 and 115 in the Perl module referenced by the error:

    die "Perl API Version does not match dynamic library version."
        unless (version() eq $VERSION);

Commenting out these lines does not affect the VMWare server in any way.