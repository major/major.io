---
title: Upgrading Fedora 13 to Fedora 14 on Slicehost and Rackspace Cloud Servers
author: Major Hayden
type: post
date: 2010-11-03T20:02:45+00:00
url: /2010/11/03/upgrading-fedora-13-to-fedora-14-on-slicehost-and-rackspace-cloud-servers/
dsq_thread_id:
  - 3642806284
categories:
  - Blog Posts
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

---
On most systems, using Fedora's [preupgrade][1] package is the most reliable way to update to the next Fedora release. However, this isn't the case with Slicehost and Rackspace Cloud Servers.

Here are the steps for an upgrade from Fedora 13 to Fedora 14 via yum:

```
yum -y upgrade
wget http://mirror.rackspace.com/fedora/releases/14/Fedora/x86_64/os/Packages/fedora-release-14-1.noarch.rpm
rpm -Uvh fedora-release-14-1.noarch.rpm
yum -y install yum
yum -y upgrade</pre>

If you happen to be upgrading a 32-bit instance on Slicehost, simply replace `x86_64` with `i386` in the url shown above.

 [1]: http://fedoraproject.org/wiki/PreUpgrade
