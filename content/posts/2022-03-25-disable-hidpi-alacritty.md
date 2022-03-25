---
author: Major Hayden
categories:
  - Blog Posts
date: '2022-03-25'
description: >-
  The alacritty terminal on Fedora enables HiDPI mode by default. Break out your
  magnifying glasses as we disable HiDPI. 👓
images:
  - images/2022-03-25-reflection-mountains.jpg
slug: disable-hidpi-alacritty
tags:
  - alacritty
  - fedora
  - hidpi
  - i3
  - linux
  - terminal
title: Disable HiDPI in alacritty
type: post
---

{{< figure src="/images/2022-03-25-reflection-mountains.jpg" alt="Mountains reflected in a lake" position="center" >}}

The [alacritty] terminal remains my favorite terminal because of its simple
configuration, regular expression hints, and incredible performance. It's written in
Rust and it uses OpenGL to accelerate the terminal output.

I also like high DPI displays. My desktop has two 4K monitors (3840x2160) and my [X1
Nano] (2160x1350) crams plenty of pixels into a small display. With Linux, you get two
options:

1. Use HiDPI with larger fonts for a clear, crisp display. It really does look pretty.
2. Disable HiDPI and get a lot more screen real estate with smaller fonts. Prepare to
   squint. 🥸

I prefer more screen real estate (and I wear glasses), so I usually disable HiDPI on
most of my machines. After wiping my laptop and starting over recently, I realized my
alacritty terminals had massive fonts again. If only I had written down how I fixed it.
🤔

Lucky for you, I'm writing about those options here:

## Disable HiDPI just for alacritty

You might be saying "just lower the font size in the alacritty configuration" and call
it a day. Well, that method leaves you with smaller fonts, sure, but then there are gaps
in spacing between character and lines. It just looks clunky.

There's an environment variable we can use: `WINIT_X11_SCALE_FACTOR`. To disable HiDPI
and use pixels at a 1:1 ratio, set the following option in your alacritty configuration
file (usually `~/.config/alacritty/alacritty.yml`):

```yaml
env:
  WINIT_X11_SCALE_FACTOR: "1"
```

Close all of your alacritty terminals and open a new one. You should now see smaller
fonts and a terminal with HiDPI disabled.

## Disable HiDPI across the board

In many of the full-featured window manager, such as GNOME or KDE, you can disable HiDPI
within the system settings. The i3 window manager requires some manual work (as you
might expect).

From the old days of X comes `.Xresources`! These [X resources] set all kinds of
configuration options for all applications running under X. Here's my current
`~/.Xresources` file:

```
Xft.dpi: 96
Xft.autohint: 0
Xft.lcdfilter: lcddefault
Xft.hintstyle: hintmedium
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
```

The first line sets the DPI to 96 (which is my preference). Increasing that number will
take you closer to a HiDPI setting and potentially make text crisper, but larger.
Lowering it will make text smaller and sometimes a bit ugly if you go below 85.

To use X resources, you first need `xrdb`. On Fedora, install it, load your current
configuration, and query it:

```console
$ dnf install /usr/bin/xrdb
$ xrdb -merge ~/.Xresources
$ xrdb -query -all
Xft.antialias:	1
Xft.autohint:	0
Xft.dpi:	96
Xft.hinting:	1
Xft.hintstyle:	hintmedium
Xft.lcdfilter:	lcddefault
Xft.rgba:	rgb
```

You need to quit most applications and start them again before you can see the DPI
changes. In some situations, I needed to reboot to get the changes in place for all
applications.

[alacritty]: https://alacritty.org/
[X1 Nano]: /2021/10/23/thinkpad-x1-nano-gen1-review/
[X Resources]: https://wiki.archlinux.org/title/X_resources

_Photo credit: [Tim Stief](https://unsplash.com/photos/YFFGkE3y4F8)_
