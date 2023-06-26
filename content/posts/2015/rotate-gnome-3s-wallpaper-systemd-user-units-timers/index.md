---
aliases:
- /2015/02/11/rotate-gnome-3s-wallpaper-systemd-user-units-timers/
author: Major Hayden
date: 2015-02-11 14:23:03
tags:
- bash
- fedora
- gnome
- script
- systemd
title: Rotate GNOME 3’s wallpaper with systemd user units and timers
---

_NOTE: This works in Fedora 21, but not in Fedora 22. Review [this post][1] for the fixes._

[GNOME 3][2] has improved by leaps and bounds since its original release and it's my daily driver window manager on my Linux laptop. Even with all of these improvements, there's still no built-in way to rotate wallpaper (that I've found).

There are some extensions, like [BackSlide][3], that enable background rotation on a time interval. Fedora 21 uses GNOME 3.14 and the current BackSlide version is incompatible. BackSlide's interface is fairly useful but I wanted something different.

One of systemd's handy features is the ability to set up [systemd][4] unit files on a per-user basis. Every user can create unit files in their home directory and tell systemd to begin using those.

### Getting started

We first need a script that can rotate the background based on files in a particular directory. All of my wallpaper images are in `~/Pictures/wallpapers`. I adjusted this script that I found on GitHub so that it searches through files in my wallpaper directory and picks one at random to use:

```shell
#!/bin/bash

walls_dir=$HOME/Pictures/Wallpapers
selection=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$selection"
```

I tossed this script into `~/bin/rotate_bg.sh` and made it executable with `chmod +x ~/bin/rotate_bg.sh`. Before you go any further, run the script manually in a terminal to verify that your background rotates to another image.

### Preparing the systemd service unit file

You'll need to create a user-level systemd service file directory if it doesn't exist already:

```
mkdir ~/.config/systemd/user/
```

Drop this file into `~/.config/systemd/user/gnome-background-change.service`:

```ini
[Unit]
Description=Rotate GNOME background

[Service]
Type=oneshot
Environment=DISPLAY=:0
ExecStart=/usr/bin/bash /home/[USERNAME]/bin/rotate_bg.sh

[Install]
WantedBy=basic.target
```

This unit file tells systemd that we have a oneshot script that will exit when it's finished. In addition, we also give the environment details to systemd so that it's aware of our existing X session.

Don't enable or start the service file yet. We will let our timer handle that part.

### Setting a timer

Systemd's concept of [timers][5] is pretty detailed. You have plenty of control over how and when you want a particular service to run. We need a simple calendar-based timer (much like cron) that will start up our service from the previous step.

Drop this into `~/.config/systemd/user/gnome-background-change.timer`:

```ini
[Unit]
Description=Rotate GNOME wallpaper timer

[Timer]
OnCalendar=*:0/5
Persistent=true
Unit=gnome-background-change.service

[Install]
WantedBy=gnome-background-change.service
```

We're telling systemd that we want this timer to run every five minutes and we want to start our service unit file from the previous step. The `Persistent` line tells systemd that we want this unit file run if the last run was missed. For example, if you log in at 7:02AM, we don't want to wait until 7:05AM to rotate the background. We can rotate it immediately after login.

If you'd like a different interval, be sure to review systemd's [time syntax][6] for the `OnCalendar` line. It's a little quirky if you're used to working with crontabs but it's very powerful once you understand it.

Now we can enable and start the timer:

```
systemctl --user enable gnome-background-change.timer
systemctl --user start gnome-background-change.timer
```

### Checking our work

You can use systemctl to query the timer we just activated:

```
$ systemctl --user list-timers
NEXT                         LEFT          LAST                         PASSED  UNIT                          ACTIVATES
Wed 2015-02-11 08:15:00 CST  3min 53s left Wed 2015-02-11 08:10:49 CST  16s ago gnome-background-change.timer gnome-background-change.service
```

In my case, this shows that the background rotation service last ran 16 seconds ago. It will run again in just under four minutes. If you find that the service runs but your wallpaper doesn't change, try running `journalctl -xe` to see if your service is throwing any errors.

### Additional reading

This is just the tip of the iceberg of what systemd can do with user unit files and timers. the Arch Linux wiki has some awesome documentation about [user unit files][7] and [timers][8]. Check out the other timers that already exist on your system for more ideas.

 [1]: /2015/06/23/fedora-22-and-rotating-gnome-wallpaper-with-systemd-timers/
 [2]: http://www.gnome.org/gnome-3/
 [3]: https://extensions.gnome.org/extension/543/backslide/
 [4]: http://www.freedesktop.org/wiki/Software/systemd/
 [5]: http://www.freedesktop.org/software/systemd/man/systemd.timer.html
 [6]: http://www.freedesktop.org/software/systemd/man/systemd.time.html
 [7]: https://wiki.archlinux.org/index.php/Systemd/User
 [8]: https://wiki.archlinux.org/index.php/Systemd/Timers