---
title: Handy settings for the touchpad/clickpad in the Lenovo X1 Carbon
author: Major Hayden
type: post
date: 2012-12-28T16:15:42+00:00
url: /2012/12/28/handy-settings-for-the-touchpadclickpad-in-the-lenovo-x1-carbon/
dsq_thread_id:
  - 3642807115
categories:
  - Blog Posts
tags:
  - fedora
  - lenovo
  - linux
  - synaptics
  - xorg

---
_<strong style="color: #D42020;">UPDATE:</strong> I've found a better configuration via another X1 Carbon user and there's a [new post with all the details][1]._

* * *

The Lenovo X1 Carbon comes with a pretty useful clickpad just below the keyboard, but the default synaptics settings in X from a Fedora 17 installation aren't the best for this particular laptop. I found some tips about managing clickpads in a [Github Gist about the Samsung Series 9][2] and I adjusted the values for the X1. To get my configuration, just create `/etc/X11/xorg.conf.d/10-synaptics.conf` and toss this data in there:

```
Section "InputClass"
  Identifier "touchpad catchall"
  Driver "synaptics"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Option "TapButton1" "1"
  Option "TapButton2" "3"
  Option "TapButton3" "2"
  Option "VertTwoFingerScroll" "on"
  Option "HorizTwoFingerScroll" "on"
  Option "HorizHysteresis" "50"
  Option "VertHysteresis" "50"
  Option "PalmDetect"    "1"
  Option "PalmMinWidth"  "5"
  Option "PalmMinZ"      "40"
EndSection
```

There are a few important settings here to note:

  * **TapButtonX** &#8211; this sets up the single, double and triple taps to match up to left, right and middle mouse clicks respectively
  * **Vert/HorizHysteresis** &#8211; reduces movement during and between taps
  * **Palm*** &#8211; enables palm detection while you're typing with some reasonable settings

You will need to restart X (or reboot) to apply these settings from the configuration file. If you want to test the settings before restarting, you can apply individual adjustments with `synclient` without any restarts:

```
synclient "HorizHysteresis=50"
```

 [1]: /2013/08/24/get-a-rock-solid-linux-touchpad-configuration-for-the-lenovo-x1-carbon/
 [2]: https://gist.github.com/2382480
