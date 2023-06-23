---
aliases:
- /2011/06/16/keep-all-old-kernels-when-upgrading-via-yum/
author: Major Hayden
date: 2011-06-16 12:50:46
dsq_thread_id:
- 3642806585
tags:
- command line
- fedora
- kernel
- linux
- red hat
- sysadmin
- yum
title: Keep all old kernels when upgrading via yum
---

Some might call me paranoid, but I get nervous when my package manager automatically removes a kernel. I logged into my Fedora 15 VM this morning and found this:

```
================================================================================
 Package        Arch           Version                   Repository        Size
================================================================================
Installing:
 kernel         x86_64         2.6.35.13-92.fc14         updates           22 M
Removing:
 kernel         x86_64         2.6.35.11-83.fc14         @updates         104 M

Transaction Summary
================================================================================
Install       1 Package(s)
Remove        1 Package(s)
```


Fedora 15's default behavior is to keep three kernels: the latest one and the two previous versions. However, this behavior may be counter-productive if you compile your own modules, or if you have compatibility issues with subsequent kernel versions.

You can change how yum handles kernel packages with some simple changes to your `/etc/yum.conf`. The `installonly_limit` option controls how many old packages are kept:

> **installonly_limit** Number of packages listed in installonlypkgs to keep installed at the same time. Setting to 0 disables this feature. Default is '0'.

I disabled the functionality altogether by setting `installonly_limit` to 0:

```
#installonly_limit=3
installonly_limit=0
```


It's important to keep in mind that you will need to purge these packages from your system yourself now. Kernel packages can occupy a fair amount of disk space, so make a note to go back and clean them up when you no longer need them.