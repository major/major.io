---
author: Major Hayden
date: '2022-05-27'
summary: >-
  Because nobody wants an inefficient emoji workflow. 🙈
tags:
  - emoji
  - fedora
  - linux
  - rofimoji
  - swaywm
  - wayland
title: Efficient emoji experience in Wayland
---

I recently moved over to the Sway window manager (as I mentioned in my [last post]) and
it runs on Wayland. That means bidding farewell to X. Although this is a step forward,
it caused some of my workflows to break.

My original post about my [efficient emoji workflow] inspired many people to give it a
try. Everything was great until I moved to Wayland and suddenly [rofimoji] stopped
pasting emojis on demand. 😱

[last post]: /2022/05/24/sway-reload-causes-a-firefox-crash/
[efficient emoji workflow]: /2021/05/15/efficient-emojis-with-rofimoji/
[rofimoji]: https://github.com/fdw/rofimoji
[colorful emoji symbols]: https://www.spinics.net/lists/linux-block/msg68704.html

# So is this a big deal or something?

Well, yes.

Some people would shrug this off and go on about their day. But wait -- emojis are core
to my workflow. Sure, I use them liberally in my communications via chat or email, but I
also sprinkle them in various places to ensure applications handle unicode characters
properly.

When I worked on the Continuous Kernel Integration (CKI) team at Red Hat, we wanted to
send concise and informative emails in plain text. Our team added [colorful emoji
symbols], reduced the length of our emails, and won praise (and some consternation) from
kernel developers. We even named our releases using emojis for a while (the first one
was 🐣). 🤭

# Emojis in wayland

In Fedora, we need some packages:

```console
$ sudo dnf install rofimoji wl-clipboard wtype
```

Why do we need these?

* `rofimoji` pops up an emoji picker in rofi where you can quickly search for emojis
* `wl-clipboard` gives you the `wl-copy` and `wl-paste` tools, similar to `xclip` from X
* `wtype` replaces `xdotool` from X

Sway is *heavily* keyboard driven and that's why I love it. More typing and less mouse.
We need a keyboard shortcut for `rofimoji`. I use MOD-D for regular `rofi`, so I chose
to use MOD-E for `rofimoji`. (*MOD* is likely the key on your keyboard with the Windows
logo on it.)

Open your sway configuration file (usually `~/.config/sway/config`) and add a line:

```conf
bindsym $mod+e exec ~/bin/launch_rofimoji
```

Save the shell script to `~/bin/launch_rofimoji`:

```shell
#!/bin/bash

# Determine which output is currently active (where the mouse pointer is). 🤔
MONITOR_ID=XWAYLAND$(swaymsg -t get_outputs | jq '[.[].focused] | index(true)')

# Let's pick our emojis! 🎉
rofimoji --action type --skin-tone light \
    --selector-args="-theme solarized -font 'Hack 12' -monitor ${MONITOR_ID}"
```

Ensure the script is executable:

```console
$ chmod +x ~/bin/launch_rofimoji
```

At this point, you can reload sway's configuration with MOD+SHIFT-C. After a brief
screen flicker, try the MOD+E keyboard combination and `rofimoji` should appear! Search
for your favorite emoji, press enter, and enjoy! 🍰

# Caveats

This script works well for me terminals, Visual Studio Code, Firefox, and most GTK-based
applications. However, I still have issues using it with Electron based applications
(such as Slack). If I bind a sway key combination to something super simple, like `wtype
banana`, I end up with numbers pasted into Electron applications. That's something I am
still working to solve[^slack-workaround].

If you run into issues where emojis don't appear, or you have unusual carriage returns
after your emojis, you may want to remove `--action type` and try `--action copy` or
`--action clipboard`. These different actions use different methods for copying and
pasting emojis into your applications. You can stack actions separated by spaces, such
as `--action clipboard type`. You may need to experiment with these to figure out what
works on your machine.

Still having trouble? Consider using `clipman`. It's a more robust clipboard for wayland
and you can start it automatically in sway:

```conf
exec wl-paste -t text --watch clipman store --no-persist
```

You can query `clipman` history as well. This could help you determine what's not being
copied across correctly from rofimoji.

[^slack-workaround]: My workaround is to use Slack in Firefox. I'd love to just stop
    using Slack altogether, but I don't have a choice. 😭
