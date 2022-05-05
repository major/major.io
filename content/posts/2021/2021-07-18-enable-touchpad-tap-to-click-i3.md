---
author: Major Hayden
categories:
- Blog Posts
date: '2021-07-18'
summary: >-
    Enable tap-to-click on your laptop's touchpad in i3 with one of two methods. 💻
images:
- images/2021-07-18-touchpad-tapping-i3.jpg
slug: tray-icons-in-i3
tags:
- fedora
- i3
- linux
title: Enable touchpad tap to click in i3
type: post
---

{{< figure src="/images/2021-07-18-touchpad-tapping-i3.jpg" alt="Fog in a forest near a stream" position="center" >}}

One of the first things I look for on a fresh installation of a laptop is how to
enable tap-to-click automatically. Most window managers and desktop environments
make this easy with a control panel that has toggles or drop-down menus.

However, this requires a little more effort in i3. Fortunately, there are two
routes to get it enabled: in xorg's configuration or via your i3 configuration.

## Via the i3 configuration

The advantage of this method is that it's easy to configure and test out
quickly. On the other hand, this configuration change will only affect i3 on
your system. (Other window managers won't be affected.)

Start with the `xinput` command to determine which devices are on your system.
If you're on Fedora, just run `dnf install xinput` to install it.

Here's the output on my Lenovo ThinkPad T490:

```console
➜ xinput
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad              	id=12	[slave  pointer  (2)]
⎜   ↳ TPPS/2 Elan TrackPoint                  	id=13	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Sleep Button                            	id=8	[slave  keyboard (3)]
    ↳ Integrated Camera: Integrated C         	id=9	[slave  keyboard (3)]
    ↳ Integrated Camera: Integrated I         	id=10	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=11	[slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                  	id=14	[slave  keyboard (3)]
```

My touchpad is the second entry in the first group: _SynPS/2 Synaptics
TouchPad_. Now we can list all the properties of this device using the id number
(12 in my case) or the full name:

```console
➜ xinput list-props "SynPS/2 Synaptics TouchPad"
Device 'SynPS/2 Synaptics TouchPad':
	Device Enabled (187):	1
	Coordinate Transformation Matrix (189):	1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
	libinput Tapping Enabled (322):	0
	libinput Tapping Enabled Default (323):	0
	libinput Tapping Drag Enabled (324):	1
	libinput Tapping Drag Enabled Default (325):	1
	libinput Tapping Drag Lock Enabled (326):	0
	libinput Tapping Drag Lock Enabled Default (327):	0
	libinput Tapping Button Mapping Enabled (328):	1, 0
	libinput Tapping Button Mapping Default (329):	1, 0
	libinput Natural Scrolling Enabled (330):	0
	libinput Natural Scrolling Enabled Default (331):	0
	libinput Disable While Typing Enabled (332):	1
	libinput Disable While Typing Enabled Default (333):	1
	libinput Scroll Methods Available (334):	1, 1, 0
	libinput Scroll Method Enabled (335):	1, 0, 0
	libinput Scroll Method Enabled Default (336):	1, 0, 0
	libinput Click Methods Available (337):	1, 1
	libinput Click Method Enabled (338):	1, 0
	libinput Click Method Enabled Default (339):	1, 0
	libinput Middle Emulation Enabled (340):	0
	libinput Middle Emulation Enabled Default (341):	0
	libinput Accel Speed (342):	0.000000
	libinput Accel Speed Default (343):	0.000000
	libinput Accel Profiles Available (344):	1, 1
	libinput Accel Profile Enabled (345):	1, 0
	libinput Accel Profile Enabled Default (346):	1, 0
	libinput Left Handed Enabled (347):	0
	libinput Left Handed Enabled Default (348):	0
	libinput Send Events Modes Available (307):	1, 1
	libinput Send Events Mode Enabled (308):	0, 0
	libinput Send Events Mode Enabled Default (309):	0, 0
	Device Node (310):	"/dev/input/event4"
	Device Product ID (311):	2, 7
	libinput Drag Lock Buttons (349):	<no items>
	libinput Horizontal Scroll Enabled (350):	1
```

The important line in the output is this one:

```console
libinput Tapping Enabled (322):	0
```

Let's turn on tap-to-click for the touchpad:

```console
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
```

Your tap-to-click should now work! If it doesn't, go back to the list of input
devices and double check that there isn't another touchpad. Some laptops show
multiple touchpads even though there's only one in the system. This is due to
extra buttons being labeled as a touchpad on some laptops.

Let's make it permanent in the i3 configuration. Open up `~/.config/i3/config`
and add a line:

```text
exec xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
```

You're all set!

## Via the xorg configuration method

This method affects all window managers on your machine, so keep that in mind.
Make a new file at `/etc/X11/xorg.conf.d/touchpad-tap.conf` and add the
following:

```text
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
```

We're telling xorg to apply this configuration to any libinput touchpad on the
system (but you could use the specific name of the device here if you want), and
we're enabling the tapping option.

You can make this change effective immediately with:

```console
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
```

The xorg configuration change takes effect when you log out of your X session or
you reboot your computer.

*Photo credit: [pine watt on Unsplash](https://unsplash.com/photos/2Hzmz15wGik)*
