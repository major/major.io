---
title: Upgrading Fedora 11 to 12 using yum
author: Major Hayden
date: 2009-12-08T02:28:06+00:00
url: /2009/12/07/upgrading-fedora-11-to-12-using-yum/
dsq_thread_id:
  - 3646629767
tags:
  - fedora
  - rpm
  - upgrade
  - yum

---
As with the [Fedora 10 to 11 upgrade][1], you can upgrade Fedora 11 to Fedora 12 using yum. I find this to be the easiest and most reliable way to upgrade a Fedora installation whether you use it as a server or desktop.

To reduce the total data downloaded, I'd recommend installing the `yum-presto` package first. It downloads delta RPM's and builds them on the fly, which allows you to upgrade packages without having to download the entire RPM's.

<pre lang="html">yum install yum-presto</pre>

Now, upgrade your current system to the latest packages and clean up yum's metadata:

<pre lang="html">yum upgrade
yum clean all</pre>

Get the latest `fedora-release` package and install it (replace **x86_64** with **x86** if you're using a 32-bit system):

<pre lang="html">wget ftp://download.fedora.redhat.com/pub/fedora/linux/releases/12/Fedora/x86_64/os/Packages/fedora-release-*.noarch.rpm
rpm -Uvh fedora-release-*.rpm</pre>

Now, upgrade your system to Fedora 12:

<pre lang="html">yum upgrade</pre>

> For detailed documentation on the entire process, refer to [Fedora using yum][2] on the FedoraProject Wiki.

 [1]: /2009/06/11/upgrading-from-fedora-10-cambridge-to-fedora-11-leonidas/
 [2]: http://fedoraproject.org/wiki/YumUpgradeFaq
