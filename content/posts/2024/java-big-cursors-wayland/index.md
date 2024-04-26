---
author: Major Hayden
date: '2024-04-26'
summary: |
  Java applications under Wayland seemed to have all different sizes of cursors, but
  some were way, way, too big. 🐘
tags: 
  - fedora
  - java
  - linux
  - sway
  - systemd
  - wayland
title: Fix big cursors in Java applications in Wayland
coverAlt: Lights hanging in a tree
coverCaption: |
  [Hendrik Cornelissen](https://unsplash.com/photos/black-elephant-BaFAfMR6kF0) via Unsplash
---

Scroll through the list of [Wayland posts](/tags/wayland/) posts on the blog and you'll see that I've solved plenty of weird problems with Wayland and the [Sway](https://swaywm.org/) compositor.
Most are pretty easy to fix but some are a bit trickier.

Java applications are notoriously unpredictable and Wayland takes unpredictability to the next level.
One particular application on my desktop always seems to start with massive cursors.

This post is about how I fixed and then discovered something interesting along the way.

## Fixing big cursors

I recently moved some investment and trading accounts from TD Ameritrade to [Tastytrade](https://tastytrade.com/).
Both offer Java applications that make trading easier, but Tastytrade's application always started with massive cursors.

To make matters worse, sometimes the cursor looked lined up on the screen but then the click landed on the wrong buttons in the application!
Errors are annoying.
Errors that cost you money and time must be fixed. 😜

Some web searches eventually led me to Arch Linux's excellent [Wayland wiki page](https://wiki.archlinux.org/title/Wayland).
None of the adjustments or environment variables there had any effect on my cursors.

I eventually landed on a page that suggested setting `XCURSOR_SIZE`.
I don't remember ever setting that, but it was being set by _something_:

```console
$ echo $XCURSOR_SIZE
24
```

One of the suggestions was to decrease it, so I decided to give `20` a try.
That was too big, but `16` was perfect and it matched all of my other applications:

```console
$ export XCURSOR_SIZE=20
# /opt/tastytrade/bin/tastytrade
```

That works fine when I start my application via the terminal, but how do I set it for the application when I start it from ulauncher in sway? 🤔

## Desktop file

The Tastytade RPM comes with a `.desktop` file for launching the application.
I copied that over to my local applications directory:

```shell
cp /opt/tastytrade/lib/tastytrade-tastytrade.desktop \
    ~/.local/share/applications/
```

Then I opened the copied `~/.local/share/applications/tastytrade-tastytrade.desktop` file in a text editor:

```ini
[Desktop Entry]
Name=tastytrade
Comment=tastytrade
Exec=/opt/tastytrade/bin/tastytrade
Icon=/opt/tastytrade/lib/tastytrade.png
Terminal=false
Type=Application
Categories=tastyworks
MimeType=
```

I changed the `Exec` line to be:

```ini
Exec=env XCURSOR_SIZE=16 /opt/tastytrade/bin/tastytrade
```

I launched the application again after making that change, but the cursors were still huge!
There has to be another way. 🤔

## systemd does everything 😆

After more searching and digging, I discovered that systemd has a capability to [set environment variables for user sessions](https://www.freedesktop.org/software/systemd/man/latest/environment.d.html):

> Configuration files in the environment.d/ directories contain lists of environment variable assignments passed to services started by the systemd user instance. systemd-environment-d-generator(8) parses them and updates the environment exported by the systemd user instance. See below for an discussion of which processes inherit those variables.
>
> It is recommended to use numerical prefixes for file names to simplify ordering.
>
> For backwards compatibility, a symlink to /etc/environment is installed, so this file is also parsed.

Let's give that a try:

```console
$ mkdir -p ~/.config/environment.d/
$ vim ~/.config/environment.d/wayland.conf
```

In the file, I added one line with a comment (because you will soon forget why you added it 😄):

```shell
# Fix big cursors in Java apps in Wayland
XCURSOR_SIZE=16
```

**After a reboot, I launched my Java application and boom -- the cursors were perfect!** 🎉

I went back and cleaned up some other hacks I had applied and added them to that `wayland.conf` file:

```shell
# This was important at some point but I'm afraid to remove it.
# Note to self: make detailed comments when adding lines here.
SDL_VIDEODRIVER=wayland
QT_QPA_PLATFORM=wayland

# Reduce window decorations for VLC
QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

# Fix weird window handling when Java apps do certain pop-ups
_JAVA_AWT_WM_NONREPARENTING=1

# Ensure Firefox is using Wayland code (not needed any more)
MOZ_ENABLE_WAYLAND=1

# Disable HiDPI
GDK_SCALE=1

# Fix big cursors in Java apps in Wayland
XCURSOR_SIZE=16
```

I'm told there are some caveats with this solution, especially if your Wayland desktop doesn't use systemd to start.
This is working for me with GDM launching Sway on Fedora 40.