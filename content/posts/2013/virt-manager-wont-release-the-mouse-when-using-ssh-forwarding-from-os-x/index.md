---
aliases:
- /2013/03/20/virt-manager-wont-release-the-mouse-when-using-ssh-forwarding-from-os-x/
author: Major Hayden
date: 2013-03-20 05:26:56
dsq_thread_id:
- 3642807155
tags:
- centos
- fedora
- mac
- ssh
- virt-manager
- virtualization
title: virt-manager won’t release the mouse when using ssh forwarding from OS X
---

The latest versions of [virt-manager][1] don't release the mouse pointer when you're doing X forwarding to a machine running OS X. This can lead to a rather frustrating user experience since your mouse pointer is totally stuck in the window. Although this didn't affect me with CentOS 6 hosts, Fedora 18 hosts were a problem.

There's a [relatively elegant fix from btm.geek][2] that solved it for me. On your Mac, exit X11/Xquartz and create an `~/.Xmodmap` file containing this:

```
clear Mod1
keycode 66 = Alt_L
keycode 69 = Alt_R
add Mod1 = Alt_L
add Mod1 = Alt_R
```


Start X11/Xquartz once more and virt-manager should release your mouse pointer if you hold the left control key and left option at the same time.

 [1]: http://virt-manager.org/
 [2]: http://blog.loftninjas.org/2010/11/17/virt-manager-keymaps-on-os-x/