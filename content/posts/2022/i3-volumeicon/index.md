---
author: Major Hayden
date: '2022-11-27'
summary: Simplify your i3 configuration and monitor sound levels with volumeicon in your tray with the i3 window manager. 🔈 
tags:
  - i3
  - sound
title: Manage sound volume with volumeicon in i3 
---

Now that [Fedora 37] launched, I decided to wipe my main laptop and do a clean installation.
I made some poor configuration choices while in a hurry over the past year and the mess finally caught up with me.

The latest version of the [i3 spin] caught my eye and I used it for the installation.
Once my laptop booted up, I noticed a volume icon in my system tray that appeared automatically.
I've normally used [pasystray] for this task, but [volumeicon] came with the i3 spin.

The volumeicon tray icon has a few handy features:

  * Notifications via libnotify (or GTK) when something sound-related changes
  * Quick access to muting and unmuting a sound device via clicking the icon
  * Access to sound mixers and preferences via a right click

However, it also catches key presses from my volume keys on my laptop.
Catching the volume keys is disabled by default but you can change that via its configuration file.

Normally, I would have an i3 configuration snippet like this one:

```text
# Use pactl to adjust volume in PulseAudio.
set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status
```

That works fine, but volumeicon can handle this for us.
Here's my current volumeicon configuration in `~/.config/volumeicon/volumeicon`:

```ini
[Alsa]
card=default

[Notification]
show_notification=true
notification_type=0

[StatusIcon]
stepsize=5
onclick=pavucontrol
theme=Default
use_panel_specific_icons=false
lmb_slider=false
mmb_mute=false
use_horizontal_slider=false
show_sound_level=true
use_transparent_background=false

[Hotkeys]
up_enabled=true
down_enabled=true
mute_enabled=true
up=XF86AudioRaiseVolume
down=XF86AudioLowerVolume
mute=XF86AudioMute
```

I've changed a few things from the defaults:

  * Enabled notifications via GTK _(libnotify notifications didn't look great)_
  * Enabled the volume keys in the `[Hotkeys]` section

i3 takes care of starting the icon for me with `exec`:

```text
exec --no-startup-id volumeicon
```

Log out and log in again to test the changes.

[Fedora 37]: https://fedoramagazine.org/announcing-fedora-37/
[i3 spin]: https://spins.fedoraproject.org/en/i3/
[pasystray]: https://github.com/christophgysin/pasystray
[volumeicon]: https://github.com/Maato/volumeicon

_This is post 2 of 100 in the [#100DaysToOffload](/p/100-days-to-offload/) challenge._
