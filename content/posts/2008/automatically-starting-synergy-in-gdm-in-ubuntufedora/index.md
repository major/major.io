---
aktt_notify_twitter:
- false
aliases:
- /2008/07/30/automatically-starting-synergy-in-gdm-in-ubuntufedora/
author: Major Hayden
date: 2008-07-30 17:00:09
dsq_thread_id:
- 3642772155
tags:
- desktop
- synergy
title: Automatically starting synergy in GDM in Ubuntu/Fedora
---

**Before you follow this guide,** be sure to [read about the issue][1] I had in Fedora 12 with this strategy.

At work, I have a Mac Mini as my main workstation with one monitor. There's another monitor to the right which is connected to my Linux box. I run a synergy server on the Mac, and I run a synergy client in Linux. However, I was getting pretty frustrated when I'd have to manually start the synergy client on the Linux box with another keyboard.

After a bit of Google searching, I found a solution that will enable synergy at the GDM login as well as after the login (when the window manager starts). Here's the process:

Open **/etc/gdm/Init/Default** in your editor of choice and go to the bottom of the file. Just before `exit 0`, add the following:

```
/usr/bin/killall synergyc
sleep 1
/usr/bin/synergyc 111.222.333.444
```


Next, you can create the **/etc/gdm/PostLogin/Default** file as an empty file, or you can copy over the template file from **/etc/gdm/PostLogin/Default.sample** to **/etc/gdm/PostLogin/Default**. Either way, add the following to that file:

```
/usr/bin/killall synergyc
sleep 1
```


Finally, edit the **/etc/gdm/Presession/Default** file and add in the following before `exit 0`:

```
/usr/bin/killall synergyc
sleep 1
/usr/bin/synergyc 111.222.333.444
```


Once that's done, you can log out and log back in to see the changes. You can also reboot your Linux desktop or switch to runlevel 3 and back to 5 (if your OS supports runlevel changes).

 [1]: http://rackerhacker.com/2010/03/03/sticky-shift-key-with-synergy-in-fedora-12/