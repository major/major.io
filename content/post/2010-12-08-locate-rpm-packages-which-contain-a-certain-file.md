---
title: Locate RPM packages which contain a certain file
author: Major Hayden
type: post
date: 2010-12-09T02:30:00+00:00
url: /2010/12/08/locate-rpm-packages-which-contain-a-certain-file/
dsq_thread_id:
  - 3642806375
categories:
  - Blog Posts
tags:
  - centos
  - fedora
  - red hat
  - rpm
  - sysadmin
  - yum

---
It's not easy remembering which RPM packages contain certain files. If I asked you which files you'd find in packages like `postfix-2.7.1-1.fc14` and `bash-4.1.7-3.fc14`, you would be able to name some obvious executables. However, would you be able to do the same if I mentioned a package like `util-linux-ng-2.18-4.6.fc14`? If the RPM is already installed, you can quickly use `rpm -ql` to list the files within it.

However, what if the RPM isn't installed already? How do you figure out which one to install?

Fedora has well over 20,000 packages in the standard repositories without adding additional repositories like RPM Fusion. Narrowing that list down to find the package you want can be daunting, but you can use yum to help.

Consider this: you're following a guide online and the author says you need to run `deallocvt`:

```
# deallocvt
-bash: deallocvt: command not found
```

Perhaps it's in a package with `deallocvt` in the name:

```
# yum search deallocvt
Warning: No matches found for: deallocvt
No Matches found
```

This is where yum's `whatprovides` (`provides` works in recent yum versions) command works really well:

```
# yum whatprovides */deallocvt
kbd-1.15-11.fc14.x86_64 : Tools for configuring the console
Repo        : fedora
Matched from:
Filename    : /usr/bin/deallocvt
```

From there, you can install the `kbd` RPM package via yum and you'll be on your way.

_Author's note: Regular readers will probably think this is pretty basic, but I often find people who don't know this functionality exists in yum._

**UPDATE:** I forgot to include another handy command in this article (thanks to Jason Gill for reminding me). If you have file on your system already, but you need to know which RPM package it came from, you can do this very quickly:

```
# rpm -qf /usr/bin/free
procps-3.2.8-14.fc14.x86_64
```
