---
aliases:
- /2016/07/05/bring-back-two-three-finger-taps-fedora-24/
author: Major Hayden
date: 2016-07-06 04:54:13
tags:
- fedora
- gnome
- linux
- xinput
- xorg
title: Bring back two and three finger taps in Fedora 24
---

[<img src="/wp-content/uploads/2012/01/fedorainfinity.png" alt="Fedora Infinity Logo" width="105" height="102" class="alignright size-full wp-image-2712" />][1]Most of the recent Fedora upgrades have been quite smooth. There were definitely some rough spots back in Fedora 15 and Fedora 17 with the `/bin` migration and the switch to systemd. The upgrade from Fedora 23 to Fedora 24 has been really easy except for one minor quirk: my two and three finger taps don't seem to work on the touchpad.

I use a [Lenovo ThinkPad X1 Carbon (3rd gen)][2] and it has a clickpad along with physical buttons across the top. I use the two finger taps (to do a secondary click) frequently. After the Fedora 24 upgrade, I can still do _clicks_ with one, two or three fingers, but the _taps_ don't work.

After a little digging in `xinput`, I began to narrow down the problem:

```
[major@arsenic ~]$ xinput list
⎡ Virtual core pointer                      id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad                id=11   [slave  pointer  (2)]
⎜   ↳ TPPS/2 IBM TrackPoint                     id=12   [slave  pointer  (2)]
⎣ Virtual core keyboard                     id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Sleep Button                              id=8    [slave  keyboard (3)]
    ↳ Integrated Camera                         id=9    [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=10   [slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                    id=13   [slave  keyboard (3)]
[major@arsenic ~]$ xinput list-props 11 | grep Tap
    Synaptics Tap Time (271):   180
    Synaptics Tap Move (272):   252
    Synaptics Tap Durations (273):  180, 100, 100
    Synaptics Tap Action (285): 0, 0, 0, 0, 1, 0, 0
```


## Hunting for a fix

It seems like this `Synaptics Tap Action (285)` is what I need to adjust. What do those numbers mean, anyway?

After some searching, I found the answer in some [Synaptics documentation][3]:

```
Synaptics Tap Action
8 bit, up to MAX_TAP values (see synaptics.h), 0 disables an element. order: RT, RB, LT, LB, F1, F2, F3.
```


This seems like what I want, but what do those abbreviations mean at the end? I scrolled up on the page and found something useful:

```
Option "RTCornerButton" "integer"
Which mouse button is reported on a right top corner tap. Set to 0 to disable. Property: "Synaptics Tap Action"
Option "RBCornerButton" "integer"
Which mouse button is reported on a right bottom corner tap. Set to 0 to disable. Property: "Synaptics Tap Action"
Option "LTCornerButton" "integer"
Which mouse button is reported on a left top corner tap. Set to 0 to disable. Property: "Synaptics Tap Action"
Option "LBCornerButton" "integer"
Which mouse button is reported on a left bottom corner tap. Set to 0 to disable. Property: "Synaptics Tap Action"
Option "TapButton1" "integer"
Which mouse button is reported on a non-corner one-finger tap. Set to 0 to disable. Property: "Synaptics Tap Action"
Option "TapButton2" "integer"
Which mouse button is reported on a non-corner two-finger tap. Set to 0 to disable. Property: "Synaptics Tap Action"
Option "TapButton3" "integer"
Which mouse button is reported on a non-corner three-finger tap. Set to 0 to disable. Property: "Synaptics Tap Action"
```


The last three are the ones I care about. Then the abbreviations made sense:

  * F1: TapButton1
  * F2: TapButton2
  * F3: TapButton3

The `TapButton1` setting was already set to _1_, which means a primary tap. I need `TapButton2` set to _3_ (two fingers for a secondary button tap) and `TapButton3` set to _2_ (three fingers for a middle button tap). Let's try with `xinput` directly first:

```
xinput set-prop 11 "Synaptics Tap Action" 0 0 0 0 1 3 2
```


**SUCCESS!** The secondary and middle taps have returned!

## Making it stick

Let's make the setting permanent. You could add this to a `~/.xprofile` or some other file that the display manager runs, but this isn't helpful if you have a touchpad that could be removed or re-added (like a USB touchpad). For this, we need an extra X configuration file.

I created a file called `/etc/X11/xorg.conf.d/99-xinput-fix-multi-finger-taps.conf` and added some configuration:

```
Section "InputClass"
       Identifier "tap-by-default"
       MatchIsTouchpad "on"
       Option "TapButton1" "1"
       Option "TapButton2" "3"
       Option "TapButton3" "2"
EndSection
```


The configuration file specifies what we want to occur when one, two or three fingers tap on the pad. We're also being careful here to match only on touchpads to avoid tinkering with a mouse or other pointer device.

Log out of your X session and log in again. Your two and three finger taps should still be working!

 [1]: /wp-content/uploads/2012/01/fedorainfinity.png
 [2]: /2015/03/30/review-lenovo-x1-carbon-3rd-generation-and-linux/
 [3]: ftp://www.x.org/pub/X11R7.5/doc/man/man4/synaptics.4.html