---
aliases:
- /2010/11/03/upgrading-fedora-13-to-fedora-14-on-slicehost-and-rackspace-cloud-servers/
author: Major Hayden
date: 2010-11-03 20:02:45
tags:
- cloud servers
- command line
- fedora
- rackspace
- rpm
- slicehost
- sysadmin
- xen
- yum
title: Upgrading Fedora 13 to Fedora 14 on Slicehost and Rackspace Cloud Servers
---

On most systems, using Fedora's [preupgrade][1] package is the most reliable way to update to the next Fedora release. However, this isn't the case with Slicehost and Rackspace Cloud Servers.

Here are the steps for an upgrade from Fedora 13 to Fedora 14 via yum:

```
yum -y upgrade
wget http://mirror.rackspace.com/fedora/releases/14/Fedora/x86_64/os/Packages/fedora-release-14-1.noarch.rpm
rpm -Uvh fedora-release-14-1.noarch.rpm
yum -y install yum
yum -y upgrade
```

If you happen to be upgrading a 32-bit instance on Slicehost, simply replace `x86_64` with `i386` in the url shown above.

 [1]: http://fedoraproject.org/wiki/PreUpgrade