---
author: Major Hayden
date: '2025-12-18'
summary: |
  After coming back from lunch multiple times to a blank locked screen in Hyprland,
  I found a workaround with a DPMS toggle.
tags:
  - fedora
  - linux
  - hyprland
title: Blank lock screen in Hyprland
coverAlt: |
    A peaceful winter evening settles over a snow-covered European village, where warm Christmas lights glow softly against the blue tones of dusk. In the foreground, a historic church tower rises above the rooftops, crowned with snow and a golden weather vane, evoking a timeless holiday spirit. The surrounding hills and forests are blanketed in white, creating a serene alpine Christmas scene full of calm, warmth, and seasonal magic.
coverCaption: |
    Photo by <a href="https://unsplash.com/@debrupas?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Pascal Debrunner</a> on <a href="https://unsplash.com/photos/snowy-town-with-church-steeple-at-dusk-3BmQiYQCQEw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
---

I moved over to Hyprland as my primary desktop environment several months ago after wrestling with some other Wayland desktop environments.
It does plenty of things well and finally allowed me to do screen sharing during meetings without much hassle.

A couple of small utilities, `hyperidle` and `hyprlock`, handle idle time and locking the screen when I step away from my desk.
However, I kept coming back after lunch and found that both of my displays were often unresponsive with a blank screen after unlocking.

# Diagnosing the issue

I ran into this issue when I'd come back from lunch, hit the spacebar, and both monitors remained in power save mode.
The power lights on both monitors were blinking, indicating that they were still in a low-power state.

If I turned off each monitor and turned it back on, the displays would come back on about 80% of the time.
Power cycling the displays was annoying and it became more annoying when I found that my workspaces had migrated between the monitors.
Nothing was in the right place any longer! 😭

I finally got in a situation where one monitor powered up and the other was still off!
Time to run some diagnostic commands!

# Digging in

You can list the monitors in hyprland with `hyprctl monitors all`.
Narrow that down by specifically looking for the DPMS (Display Power Management Signaling) status with this command:

```
$ hyprctl monitors | grep -E "(Monitor|dpms|disabled)")

Monitor DP-1 (ID 0):
	dpmsStatus: 1
	disabled: false
Monitor DP-2 (ID 1):
	dpmsStatus: 1
	disabled: false
```

In my case, the DPMS status for both monitors was `1`, which means both monitors are on.
Neither monitor is disabled.
However, the monitor connected to `DP-1` was still blank!

Even `ddcutil` said the same thing:

```
$ ddcutil detect

Display 1                                          
   I2C bus:  /dev/i2c-9
   DRM_connector:           card1-DP-1
   EDID synopsis:
      Mfg id:               DEL - Dell Inc.
      Model:                DELL U2723QE
      Product code:         17016  (0x4278)
      Serial number:        85P0F34
      Binary serial number: 1128482124 (0x4343454c)
      Manufacture year:     2024,  Week: 38
   VCP version:         2.1

Display 2
   I2C bus:  /dev/i2c-10
   DRM_connector:           card1-DP-2
   EDID synopsis:
      Mfg id:               DEL - Dell Inc.
      Model:                DELL U2723QE
      Product code:         17016  (0x4278)
      Serial number:        55P0F34
      Binary serial number: 1128481356 (0x4343424c)
      Manufacture year:     2024,  Week: 38
   VCP version:         2.1
```

Then I wondered if I could just cycle the DPMS and bring them both back:

```
$ hyprctl dispatch dpms off; sleep 1; hyprctl dispatch dpms on
```

Both monitors turned on and displayed my desktop!
But why?

# Could it be amdgpu?

Checking the system journal with `journalctl` revealed an interesting message:

```
kernel: amdgpu 0000:03:00.0: [drm] REG_WAIT timeout 1us * 100 tries - dcn32_program_compbuf_size line:139
```

This suggests there's some kind of a drm timeout when the AMD GPU driver is trying to do something.

The [Arch Linux wiki](https://wiki.archlinux.org/title/AMDGPU#System_freezes_or_reboots_when_idle) suggests that disabling AMD's low power state, GFXOFF, might help with similar issues.
You can set a kernel parameter such as `amdgpu.ppfeaturemask=0xfffd7fff` to disable it.
I've had bad luck in the past with these `amdgpu` parameters, so I wanted a workaround for now until I could test it more.

# A (sorta) elegant workaround

Hyprland has a key binding system that allows you to execute certain key combinations even when the screen is locked.
I was already using some of these key bindings so that I could adjust my music even with the screen locked[^family]:

```
> grep bindl ~/.config/hypr/hyprland.conf

bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous
```

The normal key bindings in hyprland use `bind`, but `bindl` works even when the screen is locked.
Here's what I added:

```
> grep bindl ~/.config/hypr/hyprland.conf

bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous
bindl = $mainMod SHIFT, D, exec, hyprctl dispatch dpms off && sleep 1 && hyprctl dispatch dpms on
```

Now I can hold down `Mod + Shift + D` when I return to my desk after lunch and both monitors come back on instantly!

I'll let you know if I get around to messing with `amdgpu.ppfeaturemask` to see if that resolves the underlying issue. 🤓

[^family]: This was a family request after I went for a run and left some slightly-too-aggressive music playing by accident. 😅
