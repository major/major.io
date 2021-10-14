---
author: Major Hayden
categories:
- Blog Posts
date: '2021-10-14'
description: >-
    Adjust the LED backlight on your laptop quickly in i3 on Linux. 💡
images:
- images/2021-10-14-window-blinds-curtains.jpg
slug: forwarding-ports-with-firewalld
tags:
- fedora
- i3
- laptop
- linux
title: Backlight control with i3
type: post
---

{{< figure src="/images/2021-10-14-window-blinds-curtains.jpg" alt="Light shining through blinds and a curtain against a wall" position="center" >}}

Controlling the LED backlight brightness on a laptop in Linux used to be a
chore, but most window managers automatically configure the brightness buttons
on your laptop. However, everything is much more customizable in i3 and it
requires a little more configuration.

## Controlling the light

First off, we need something that allows us to control the brightness. There's a
perfectly named project called [light] that does exactly this task! In Fedora,
install it via:

```console
$ sudo dnf -y install light
```

You can query the current brightness:

```console
$ light -G
5.00
```

On my laptop, 5% is *very dim*. Now we can increase the brightness using a simple
command:

```console
$ light -A 5
$ light -G
9.99
```

And we can bring it right back down:

```console
$ light -U 5
$ light -G
5.00
```

## Setting up hotkeys

Open your i3 configuration (usually `~/.config/i3/config`) and add the hotkey
configuration:

```text
# Handle backlight.
bindsym XF86MonBrightnessUp exec light -A 5
bindsym XF86MonBrightnessDown exec light -U 5
```

Refresh the i3 configuration with `$mod + shift + r`.


Each time you press the brightness up button on your laptop, the brightness
level goes up by 5%. The brightness down button lowers it by 5%.
This is a good setup for me since I normally only need to adjust it by a few
stops depending on ambient light.

However, if your lighting changes drastically from time to time, you can set up
a different keybinding for a much more aggressive change:

```text
# Handle backlight.
bindsym XF86MonBrightnessUp exec light -A 5
bindsym XF86MonBrightnessDown exec light -U 5
bindsym shift+XF86MonBrightnessUp exec light -A 25
bindsym shift+XF86MonBrightnessDown exec light -U 25
```

Hold shift and press brightness up or down. Now you are moving up and down by
25% brightness each time. Enjoy! 💡

[light]: https://haikarainen.github.io/light/

*Photo credit: [Ariel on Unsplash](https://unsplash.com/photos/UIjcuxmoiZw)*
