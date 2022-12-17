---
author: Major Hayden
date: '2022-05-24'
summary: >-
  Reload your sway config without disrupting Firefox. 🔥
tags:
  - fedora
  - firefox
  - sway
  - wayland
title: Sway reload causes a Firefox crash
---

My workday takes me from email to terminals to browsers to documents. I love tiling
window managers because they keep me organized and less distracted. Many are less
resource-intensive as well.

Although [i3] has graced my displays for years now (and I've [written many posts about
it]), I recently picked up an AMD graphics card and made my way to [sway].

The biggest difference between the two is that sway runs on [Wayland] rather than X.
Sway has control over how nearly everything works, such as input devices, displays,
backgrounds, and more. If you were frustrated with lots of hacks in i3 for various
X-related things, you might enjoy sway.

[i3]: https://i3wm.org/
[written many posts about it]: /tags/i3/
[sway]: https://swaywm.org
[Wayland]: https://wayland.freedesktop.org/

# But then stuff breaks

Much of my early experience with sway involves this process:

1. Change a configuration in sway 1.7.1
2. Reload the configuration live
3. Scrunch my face and say "Well, that's not quite right."
4. Read the docs
5. Go to step #1 😉

Fortunately, sway puts up with my constant reloads of the configuration until one day
when I changed lots of configuration items and suddenly every reload caused Firefox to
crash. My primary version of Firefox is the [Developer Edition] (currently 101.0b9), but
I also keep a stable version of Firefox (version 100) around that Fedora provides.

I started up the default Fedora version of Firefox, reloaded the configuration in sway,
and the stable Firefox crashed, too. 🔥

Nothing appeared on the screen when Firefox crashed. The window just disappeared and my
terminal filled up the screen where Firefox was. I could reproduce the crash multiple
times with both versions of Firefox. The crash kept occurring even after a reboot.

When I ran either version of Firefox from the command line, I finally got some error
output:

```console
Lost connection to Wayland compositor.
Exiting due to channel error.
Exiting due to channel error.
Exiting due to channel error.
Exiting due to channel error.
Exiting due to channel error.
Exiting due to channel error.
Exiting due to channel error.
Exiting due to channel error.
```

Hmm, it looks like Firefox can't talk to Sway for a moment and that might cause the
crash. But why did this suddenly start happening?

[Developer Edition]: https://www.mozilla.org/en-US/firefox/developer/

# Working backwards

I gradually backed out the recent sway configuration changes and finally found
the configuration involved in the crash:

```conf
input * {
    # Enable numlock when sway starts.
    xkb_numlock enable
    # Set up compose keys.
    xkb_options compose:rctrl
}
```

If I removed that section, Firefox stopped crashing on sway config reloads. If I put it
back in, Firefox crashed.

I tried removing only the `xkb_numlock` line. Firefox crashed. The same thing happened
when I removed only the `xkb_options` line.

Sway's documentation notes that you can [apply input configuration to all devices] with
`input *`, so the configuration was valid.

[apply input configuration to all devices]: https://github.com/swaywm/sway/wiki#key-bindings-on-a-dual-usrussian-layout

# Search time

Armed with an error message and a method for reproducing my crash, I set off to use the
most powerful system administrator tool on the market: Google. 😜

I landed on [Mozilla Bug 1652820] where other Firefox users noted that sway config
reloads caused crashes for them, too. A user noted [further down in the bug] that if
they removed the `*` from their `input` configuration and specified the actual device
identifier, the problem went away.

# Fixing the crash

I ran back and looked at my problematic configuration:

```conf
input * {
    xkb_numlock enable
    xkb_options compose:rctrl
}
```

Now the big question: how do I identify my keyboard? 🤔

As I mentioned before, sway controls everything, including input devices. You can query
about things that sway knows by using `swaymsg` and it automatically dumps data in JSON
format if you use a pipe:

```console
$ swaymsg -t get_inputs | jq -r '.[].identifier' | grep -i keyboard
1241:662:USB-HID_Keyboard
1241:662:USB-HID_Keyboard_Mouse
1241:662:USB-HID_Keyboard_Consumer_Control
1241:662:USB-HID_Keyboard_System_Control
1241:662:USB-HID_Keyboard
```

My keyboard is identified as `1241:662:USB-HID_Keyboard` according to sway. I updated my
input configuration to specify the exact device:

```conf
input "1241:662:USB-HID_Keyboard" {
  xkb_numlock enable
  xkb_options compose:rctrl
}
```

I reloaded the sway configuration, started Firefox, reloaded the configuration once
more, and **Firefox was still running**. 🎉

> 🐙 *Have multiple keyboards or input devices?* Other users noted in the bug report
that the crash will happen again (even with specific identifiers) if you have two
keyboards and both keyboards are connected. If you run into this problem, another user
[shared their workaround] using `swaymsg` called via `exec`.

[Mozilla Bug 1652820]: https://bugzilla.mozilla.org/show_bug.cgi?id=1652820
[further down in the bug]: https://bugzilla.mozilla.org/show_bug.cgi?id=1652820#c28
[shared their workaround]: https://bugzilla.mozilla.org/show_bug.cgi?id=1652820#c51
