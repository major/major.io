---
aktt_notify_twitter:
- false
aliases:
- /2010/03/26/adjusting-ttys-in-fedora-13-with-upstart/
author: Major Hayden
date: 2010-03-26 14:09:13
tags:
- command line
- fedora
- tty
- upstart
title: Adjusting tty’s in Fedora 13 with upstart
---

Fedora 13 has quite a few changes related to [upstart][1], and one of the biggest ones is how terminals are configured.  Most distributions tuck the tty configuration away in `/etc/inittab`, `/etc/event.d/` or `/etc/init/`.  If you want to adjust the number of tty's in Fedora 13, you'll need to look in `/etc/sysconfig/init`:

```
 new RH6.0 bootup
# verbose => old-style bootup
# anything else => new style bootup without ANSI colors or positioning
BOOTUP=color
# column to start "[  OK  ]" label in
RES_COL=60
# terminal sequence to move to that column. You could change this
# to something like "tput hpa ${RES_COL}" if your terminal supports it
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
# terminal sequence to set color to a 'success' color (currently: green)
SETCOLOR_SUCCESS="echo -en \\033[0;32m"
# terminal sequence to set color to a 'failure' color (currently: red)
SETCOLOR_FAILURE="echo -en \\033[0;31m"
# terminal sequence to set color to a 'warning' color (currently: yellow)
SETCOLOR_WARNING="echo -en \\033[0;33m"
# terminal sequence to reset to the default color.
SETCOLOR_NORMAL="echo -en \\033[0;39m"
# default kernel loglevel on boot (syslog will reset this)
LOGLEVEL=3
# Set to anything other than 'no' to allow hotkey interactive startup...
PROMPT=yes
# Set to 'yes' to allow probing for devices with swap signatures
AUTOSWAP=no
# What ttys should gettys be started on?
ACTIVE_CONSOLES=/dev/tty[1-6]
```


The very last line controls the number of tty's that are kept alive on your system. If you need more tty's, simply increase the 6 to a higher number. If you only want one terminal (which is usually what I want in Xen), just make this adjustment:

```
# What ttys should gettys be started on?
ACTIVE_CONSOLES=/dev/tty1
```


A normal `telinit q` doesn't seem to adjust the terminals on the fly as it did before upstart was involved. I'm not sure if this is a bug or an intended feature. Either way, a reboot solves the problem and you should see the changes afterwards.

 [1]: http://en.wikipedia.org/wiki/Upstart