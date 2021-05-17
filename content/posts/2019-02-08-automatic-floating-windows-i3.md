---
author: Major Hayden
categories:
- Blog Posts
date: '2019-02-08'
images:
- images/2019-02-08-floating-leaf.jpg
slug: automatic-floating-windows-in-i3
tags:
- linux
- i3
- fedora
title: Automatic floating windows in i3
type: post
---

![floating leaf]

The [i3 window manager] is a fast window manager that helps you keep all of
your applications in the right place. It automatically tiles windows and can
manage those tiles across multiple virtual desktops.

However, there are certain applications that I really prefer in a floating
window. Floating windows do not get tiled and they can easily be dragged
around with your mouse. They're the type of windows you expect to see on
other non-tiling desktops such as GNOME or KDE.

## Convert a window to floating temporarily

If you have an existing window that you prefer to float, select that window
and press *Mod + Shift + Space bar*. The window will pop up in front of the
tiled windows and you can easily move it with your mouse.

Depending on your configuration, you may be able to resize it by grabbing a
corner of the window with your mouse. You can also assign a key combination
for resizing in your i3 configuration file (usually `~/.config/i3/config`):

```text
# resize window (you can also use the mouse for that)
mode "resize" {
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "default"
}
bindsym $mod+r mode "resize"
```

With this configuration, simply press *Mod + r* and use the arrow keys to
grow or shrink the window's borders.

## Always float certain windows

For those windows that you always want to be floating no matter what, i3 has
a solution for that, too. Just tell i3 how to identify your windows and
ensure `floating enable` appears in the i3 config:

```text
for_window [window_role="About"] floating enable
for_window [class="vlc"] floating enable
for_window [title="Authy"] floating enable
```

In the example above, I have a few windows always set to be floating:

* `[window_role="About"]` - Any of the "About" windows in various applications
  that are normally opened by *Help -> About*.
* `[class="vlc"]` - The VLC media player can be a good one to float if you
  need to stuff it away in a corner.
* `[title="Authy"]` - Authy's chrome extension looks downright silly as a
  tiled window.

Any time these windows are spawned, they will automatically appear as
floating windows. You can always switch them back to tiled manually by
pressing *Mod + Shift + Space bar*.

## Identifying windows

Identifying windows in the way that i3 cares about can be challenging.
Knowing when to use `window_role` or `class` for a window isn't very
intuitive. Fortunately, there's a great script from an [archived i3 faq
thread] that makes this easy:

<script src="https://gist.github.com/major/ff11ccdd73941109abb4ac2d35c976eb.js"></script>

Download this script to your system, make it executable (`chmod +x
i3-get-window-criteria`), and run it. As soon as you do that, a plus (+) icon
will replace your normal mouse cursor. Click on the window you care about and
look for the output in your terminal where you ran the
`i3-get-window-criteria` script.

On my system, clicking on a terminator terminal window gives me:

```text
[class="Terminator" id=37748743 instance="terminator" title="major@indium:~"]
```

If I wanted to float all terminator windows, I could add this to my i3
configuration file:

```text
for_window [class="Terminator"] floating enable
```

## Float in a specific workspace

Do you need a window to always float on a specific workspace? i3 can do that,
too!

Let's go back to the example with VLC. Let's consider that we have a really
nice 4K display where we always want to watch movies and that's where
workspace 2 lives. We can tell i3 to always float the VLC window on workspace
2 with this configuration:

```text
set $ws1 "1: main"
set $ws2 "2: 4kdisplay"
for_window [class="vlc"] floating enable
for_window [class="vlc"] move to workspace $ws2
```

Restart i3 to pick up the new changes (usually *Mod + Shift + R*) and start
VLC. It should appear on workspace 2 as a floating window!

*[Photo source]*

[floating leaf]: /images/2019-02-08-floating-leaf.jpg
[i3 window manager]: https://i3wm.org/
[archived i3 faq thread]: https://faq.i3wm.org/question/2172/how-do-i-find-the-criteria-for-use-with-i3-config-commands-like-for_window-eg-to-force-splashscreens-and-dialogs-to-show-in-floating-mode.1.html
[Photo source]: https://www.maxpixel.net/Floating-Sea-Leaf-Water-Cute-Leaf-Floating-2438419