---
aliases:
- /2019/09/22/customize-gnome-from-i3/
author: Major Hayden
date: '2019-09-22'
images:
- images/2019-09-22-wrenches.jpg
summary: All of your GNOME and gtk applications are configured in i3 with a few simple
  tricks.
tags:
- fedora
- i3
- linux
title: Customize GNOME from i3
---

![wrenches]

i3 has been my window manager of choice for a while and I really enjoy its
simplicity and ease of use. I use plenty of gtk applications, such as Firefox
and Evolution, and configuring them within i3 can be confusing.

This post covers a few methods to change configurations for GNOME and gtk
applications from i3.

## lxappearance

Almost all of the gtk theming settings are available in [lxappearance]. You can
change fonts, mouse cursors, icons, and colors. The application makes the
changes easy to preview and you can install more icon sets if you wish.

Fedora already has lxappearance packaged and ready to go:

```
$ sudo dnf install lxappearance
$ lxappearance
```

Although style changes are immediately applied in lxappearance, you need to
restart all gtk applications to see the style changes there.

lxappearance writes GTK 2.0 and GTK 3.0 configuration files:

* GTK 2.0: `~/.gtkrc-2.0`
* GTK 3.0: `~/.config/gtk-3.0/settings.ini`

## gnome-control-center

Recent versions of GNOME bundle all of the system settings into a single
application called `gnome-control-center`. This normally starts right up in
GNOME, but i3 is a little trickier since it doesn't have some of the same
environment variables set:

```
$ gnome-control-center
**
ERROR:../shell/cc-shell-model.c:458:cc_shell_model_set_panel_visibility: assertion failed: (valid)
[1]    837 abort (core dumped)  gnome-control-center
```

The problem is a missing environment variable: `XDG_CURRENT_DESKTOP`. We can
set that on the command line and everything works:

```
env XDG_CURRENT_DESKTOP=GNOME gnome-control-center
```

## gnome-tweaks

The `gnome-tweaks` application has been around for a long time and it works
well from i3. Install it in Fedora and run it:

```
$ sudo dnf install gnome-tweaks
$ gnome-tweaks
```

Although many of the configurations inside gnome-tweaks match up with
lxappearance, gnome-tweaks offers an added benefit: it changes the
configuration inside GNOME's key-based configuration system (dconf). This is
required for some applications, such as Firefox.

You can also open up `dconf-editor` and make these changes manually in
`/org/gnome/desktop/interface`, but gnome-tweaks has a much more user-friendly
interface.

*Photo credit: [Julia Manzerova]*

[wrenches]: /images/2019-09-22-wrenches.jpg
[lxappearance]: https://wiki.lxde.org/en/LXAppearance
[Julia Manzerova]: https://www.flickr.com/photos/julia_manzerova/932055546