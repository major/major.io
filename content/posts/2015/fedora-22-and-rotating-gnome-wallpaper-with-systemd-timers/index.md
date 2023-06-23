---
aliases:
- /2015/06/23/fedora-22-and-rotating-gnome-wallpaper-with-systemd-timers/
author: Major Hayden
date: 2015-06-23 17:25:02
dsq_thread_id:
- 3872578622
tags:
- dbus
- fedora
- gnome
- systemd
title: Fedora 22 and rotating GNOME wallpaper with systemd timers
---

My [older post][1] about rotating GNOME's wallpaper with systemd timers doesn't seem to work in Fedora 22. The `DISPLAY=:0` environment variable isn't sufficient to allow systemd to use `gsettings`.

Instead, the script run by the systemd timer must know a little bit more about dbus. More specifically, the script needs to know the address of the dbus session so it can communicate on the bus. That's normally kept within the `DBUS_SESSION_BUS_ADDRESS` environment variable.

Open a shell and you can verify that yours is set:

```
$ env | grep ^DBUS_SESSION
DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-xxxxxxxxxx,guid=fa6ff8ded93c1df77eba3fxxxxxxxxxx
```


That is actually set when `gnome-session` starts as your user on your machine. for the script to work, we need to add a few lines at the top:

```shell
#!/bin/bash

# These three lines are new
USER=$(whoami)
PID=$(pgrep -u $USER gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

# These three lines are unchanged from the original script
walls_dir=$HOME/Pictures/Wallpapers
selection=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$selection"
```


Let's look at what the script is doing:

  * First, we get the username of the user running the script
  * We look for the gnome-session process that is running as that user
  * We pull out the dbus environment variable from gnome-session's environment variables when it was first started

Go ahead and adjust your script. Once you're done, test it by simply running the script manually and then using systemd to run it:

```
$ bash ~/bin/rotate_bg.sh
$ systemctl --user start gnome-background-change
```


Both of those commands should now rotate your GNOME wallpaper in Fedora 22.

 [1]: /2015/02/11/rotate-gnome-3s-wallpaper-systemd-user-units-timers/