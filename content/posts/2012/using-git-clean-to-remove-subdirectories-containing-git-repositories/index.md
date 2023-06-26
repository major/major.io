---
aliases:
- /2012/10/24/using-git-clean-to-remove-subdirectories-containing-git-repositories/
author: Major Hayden
date: 2012-10-24 20:44:59
tags:
- development
- git
- sysadmin
title: Using git clean to remove subdirectories containing git repositories
---

I had a peculiar situation today where I cloned a repository into a directory which was inside another repository. Here's what I was doing:

```
$ git clone git://gitserver/repo1.git repo1
$ cd repo1
$ git clone git://gitserver/repo2.git repo2
$ git clean -fxd
Removing repo2/
$ ls -d repo2
repo2
```


The second repository existed even after a `git clean -fxd`. I [stumbled upon a GitHub page][1] within the capistrano project that explained the problem - an extra `-f` was required:

```
$ git clean -ffxd
Removing repo2/
$ ls -d repo2
ls: cannot access repo2: No such file or directory
```


 [1]: https://github.com/capistrano/capistrano/issues/135