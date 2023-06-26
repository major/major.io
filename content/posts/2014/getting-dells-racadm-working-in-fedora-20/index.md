---
aliases:
- /2014/06/20/getting-dells-racadm-working-in-fedora-20/
author: Major Hayden
date: 2014-06-20 14:39:19
tags:
- centos
- dell
- fedora
- red hat
title: Getting Dell’s racadm working in Fedora 20
---

Dell provides the `racadm` software on Linux that allows you to manage Dell hardware from a Linux system. Getting it installed on a very modern distribution like Fedora 20 isn't supported, but here are some steps that might help you along the way:

First off, go to Dell's site and review the [racadm download instructions][1]. I'd recommend following the _Remote RACADM_ instructions so that you can manage multiple systems from your Fedora installation. You'll be looking for a download with the text _Linux Remote Access Utilities_ in the name. At the time of this post's writing, the filename is `OM-MgmtStat-Dell-Web-LX-7.4.0-866_A00.tar.gz`.

Un-tar the file and you'll get two directories dumped out into your working directory: _docs_ and _linux_:

```
tar xvzf OM-MgmtStat-Dell-Web-LX-7.4.0-866_A00.tar.gz
cd linux/rac/RHEL6/x86_64/
yum localinstall *.rpm
```


That should install all of the software you need. There weren't any dependencies to install on my Fedora workstation but yum should take care of these for you if you have a more minimal installation.

Once that's done, close your shell and re-open it. You should be able to run `racadm` from your terminal. You'll probably get an error like this if you run it:

```
ERROR: Failed to initialize transport
```


Running `strace` reveals that racadm is looking for libssl.so but can't find it. Fix that by installing `openssl-devel`:

```
yum -y install openssl-devel
```


Now you should be able to run `racadm` and configure your servers!

 [1]: http://en.community.dell.com/techcenter/systems-management/w/wiki/3205.racadm-command-line-interface-for-drac.aspx