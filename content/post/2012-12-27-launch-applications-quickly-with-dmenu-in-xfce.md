---
title: Launch applications quickly with dmenu in XFCE
author: Major Hayden
type: post
date: 2012-12-27T21:09:43+00:00
url: /2012/12/27/launch-applications-quickly-with-dmenu-in-xfce/
dsq_thread_id:
  - 3642807110
categories:
  - Blog Posts
tags:
  - linux
  - xfce

---
Ever since I saw [QuickSilver][1] for the first time, I've been hooked on quick application launchers. I've struggled to find a barebones, auto-completing application launcher in Linux for quite some time. My search has ended with [dmenu][2].

I stumbled upon dmenu after trying out the [i3 tiling window manager][3] and I was hooked almost immediately. It's extremely fast, unobtrusive, and the auto-completion is really intuitive. Another added bonus is that there is no daemon or window manager hook required for the launcher to operate.

Installing dmenu on Fedora is as easy as:

```
yum install dmenu
```

XFCE is my desktop environment of choice and the dmenu integration is pretty simple:

* **Applications Menu** > **Settings** > **Keyboard**
* Click the **Application Shortcuts** tab
* Click **Add**
* In the **Command** box, enter `/usr/bin/dmenu` and press **OK**
* On the next screen, enter a key combination to launch dmenu (I use LCTRL-SPACE)
* Click **OK**

From now on, you can press your key combination and start typing the name of any executable application in your path for dmenu to run. If you launch dmenu accidentally, just press ESC to close it.

 [1]: http://en.wikipedia.org/wiki/Quicksilver_(software)
 [2]: http://tools.suckless.org/dmenu/
 [3]: http://i3wm.org/
