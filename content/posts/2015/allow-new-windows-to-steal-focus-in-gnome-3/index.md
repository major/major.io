---
aliases:
- /2015/07/06/allow-new-windows-to-steal-focus-in-gnome-3/
author: Major Hayden
date: 2015-07-06 12:36:05
dsq_thread_id:
- 3909180756
tags:
- centos
- fedora
- gnome
- red hat
title: Allow new windows to steal focus in GNOME 3
---

GNOME 3 generally works well for me but it has some quirks. One of those quirks is that new windows don't actually pop up on the screen with focus as they do in Windows and OS X. When opening a new window, you get a &#8220;[Windowname] is ready&#8221; notification:

![1]

My preference is for new windows to pop in front and steal focus. I can see why that's not the default since it might cause you to type something in another window where you weren't expecting to. Fortunately, you can enable what GNOME calls _strict_ window focus with a quick trip to `dconf-editor`.

Installing `dconf-editor` is easy:

```
# RHEL/CentOS 7 and Fedora 21
yum -y install dconf-editor
# Fedora 22
dnf -y install dconf-editor
```

Open `dconf-editor` and navigate to **org -> gnome -> desktop -> wm -> preferences**.

Once you're there, look for _focus-new-windows_. The default setting is _smart_ which will keep new windows in the background and alert you via a notification. If you click on _smart_, a drop down will appear and you can select _strict_. That will enable functionality similar to OS X and Windows where new windows will pop up in the front and steal your focus.

The new setting takes effect immediately and there's no need to logout or close and reopen windows.

**UPDATE:** If you'd like to avoid installing `dconf-editor`, use Alexander's suggestion below and simply run:

```
gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'strict'
```

 [1]: https://major.io/wp-content/uploads/2015/07/hangouts_is_ready.png