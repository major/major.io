---
title: Keep old kernels with yum and dnf
author: Major Hayden
date: 2015-05-18T14:22:56+00:00
url: /2015/05/18/keep-old-kernels-with-yum-and-dnf/
dsq_thread_id:
  - 3774046868
tags:
  - centos
  - dnf
  - fedora
  - kernel
  - red hat
  - yum

---
When you upgrade packages on Red Hat, CentOS and Fedora systems, the newer package replaces the older package. That means that files managed by RPM from the old package are removed and replaced with files from the newer package.

There's one exception here: kernel packages.

Upgrading a kernel package with yum and dnf leaves the older kernel package on the system just in case you need it again. This is handy if the new kernel introduces a bug on your system or if you need to work through a compile of a custom kernel module.

However, yum and dnf will clean up older kernels once you have more than three. The oldest kernel will be removed from the system and the newest three will remain. In some situations, you may want more than three to stay on your system.

To change the setting, simply open up `/etc/yum.conf` or `/etc/dnf/dnf.conf` in your favorite text editor. Look for this line:

```
installonly_limit=3
```


To keep five kernels, simply replace the 3 with a 5. If you'd like to keep every old kernel on the system forever, just change the 3 to a 0. A zero means you never want "installonly" packages (like kernels) to ever be removed from your system.
