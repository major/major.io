---
title: Upgrading from Fedora 10 (Cambridge) to Fedora 11 (Leonidas)
author: Major Hayden
type: post
date: 2009-06-11T17:48:39+00:00
url: /2009/06/11/upgrading-from-fedora-10-cambridge-to-fedora-11-leonidas/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805630
categories:
  - Blog Posts
tags:
  - fedora
  - rpm
  - yum

---
There are two main ways to upgrade Fedora 10 (Cambridge) to Fedora 11 (Leonidas):

**&raquo; What the Fedora developers suggest:**

```
yum -y upgrade
yum -y install preupgrade
yum clean all
preupgrade-cli "Fedora 11 (Leonidas)"</pre>

Of course, if you're doing this on a Fedora desktop, you can use `preupgrade` (rather than _preupgrade-cli_) to upgrade with a GUI.

**&raquo; The method I prefer (and it works properly on [Slicehost][1]):**

```
yum -y upgrade
yum clean all
wget http://download.fedora.redhat.com/pub/fedora/linux/releases/11/Fedora/x86_64/os/Packages/fedora-release-11-1.noarch.rpm
rpm -Uvh fedora-release-11-1.noarch.rpm</pre>

At this point, you would normally just start upgrading packages, but the Fedora developers threw us a curveball. Since yum in Fedora 10 doesn't support metalinks, your upgrades will fail with something like this:

```
# yum -y upgrade
YumRepo Error: All mirror URLs are not using ftp, http[s] or file.
 Eg. /
removing mirrorlist with no valid mirrors: //var/cache/yum/updates/mirrorlist.txt
Error: Cannot retrieve repository metadata (repomd.xml) for repository: updates. Please verify its path and try again</pre>

It's easily fixed, however. Open up `/etc/yum.repos.d/fedora.repo` and `/etc/yum.repos.d/fedora-updates.repo` in your favorite text editor and change the `mirrorlist` URL's like so:

**Fedora Repository**

```
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch</pre>

**Fedora Updates Repository**

```
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f$releasever&arch=$basearch
mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
```


Once you make those changes, finish out the upgrade:

```


This process will take a little while to complete, but there shouldn't be any interaction required. Once it's done, change the `mirrorlist` lines back to the original values so you can benefit from the speedups provided by the metalink format.

 [1]: http://slicehost.com/
