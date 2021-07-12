---
author: Major Hayden
categories:
- Blog Posts
date: '2021-07-12'
description: >-
    Get your system tray looking great and displayed on the correct monitor with
    a simple script and some i3 configuration. 📥
images:
- images/2021-07-12-ship-wheel.jpg
slug: tray-icons-in-i3
tags:
- fedora
- i3
- linux
title: Tray icons in i3
type: post
---

{{< figure src="/images/2021-07-12-ship-wheel.jpg" alt="Hill in Derbyshire, UK" position="center" >}}

The i3 window manager delivers a lot of what I like: simplicity, speed, and
configurability. Some things, like tray icons, magically appear in other window
managers. These items require a bit more configuration within i3 to get them set
up well.

In this post, I'll explain how I handle tray icons in i3.

## Basic configuration

The tray icon configuration is within the `bar` configuration for i3. You
control it via [`tray_output`]. Here's an excerpt from my bar configuration in
`~/.config/i3/config`:

```
bar {
    status_command i3status
    position bottom
    tray_output DP-2
    font pango: Hack, Font Awesome 5 Free Regular 10
    separator_symbol "  "
    colors {
        background #000000
        statusline #ffffff
        separator #586e75
    }

}
```

In this example, I told i3 that I only want tray icons to appear on my main
display, called `DP-2`. You can get these output names with `xrandr`:

```console
$ xrandr | grep " connected"
DP-2 connected 3840x2160+0+0 (normal left inverted right x axis y axis) 597mm x 336mm
DP-4 connected 3840x2160+3840+0 (normal left inverted right x axis y axis) 597mm x 336mm
```

My desktop has `DP-2` as the primary (left) monitor and `DP-4` is on the right.
If you prefer to look at these graphically, install `arandr` *(GUI frontend for
`xrandr`)*.

You get some other options for `tray_icons`:

* `none`: Don't show the tray icons at all
* `primary`: Let i3 determine your primary display based on `xrandr` settings
* `<output_name>`: Choose a specific output from `xrandr` output

[`tray_output`]: https://i3wm.org/docs/userguide.html#_tray_output

## Filling the tray

The next logical question is: how do I choose which icons and applets appear in
the tray? I wrote a small bash script to take care of this for me:

```bash
#!/bin/bash

pkill -f pasystray
pkill -f blueman-applet
pkill -f nm-applet

pasystray --notify=all &
blueman-applet &
nm-applet --indicator &
```

This script starts by stopping all of the applets and then starts them again.
This may seem unnecessary, but it gets easier to understand once you add the
script to your i3 configuration file in `~/.config/i3/config`:

```
exec_always --no-startup-id "~/.config/i3/tray.sh"
```

The `exec_always` ensures that the tray icons script runs each time i3 starts up
and it also runs when I restart i3 to pick up new configuration changes with
Mod+Shift+R. Each i3 restart causes the tray applets to stop and start again.
This also helps when I do system updates and one of the applets can't find its
daemon after a restart.

*Photo credit: [Joseph Barrientos on Unsplash](https://unsplash.com/photos/eUMEWE-7Ewg)*
