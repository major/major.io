---
aliases:
- /2013/08/24/get-a-rock-solid-linux-touchpad-configuration-for-the-lenovo-x1-carbon/
author: Major Hayden
date: 2013-08-24 20:28:35
tags:
- fedora
- thinkpad
title: Get a rock-solid Linux touchpad configuration for the Lenovo X1 Carbon
---

[<img src="https://major.io/wp-content/uploads/2013/08/X1_closed-300x200.jpg" alt="Lenovo ThinkPad X1 Carbon" width="300" height="200" class="alignright size-medium wp-image-4546" srcset="/wp-content/uploads/2013/08/X1_closed-300x200.jpg 300w, /wp-content/uploads/2013/08/X1_closed-1024x682.jpg 1024w, /wp-content/uploads/2013/08/X1_closed.jpg 1348w" sizes="(max-width: 300px) 100vw, 300px" />][1]The X1 Carbon's touchpad has been my nemesis in Linux for quite some time because of its high sensitivity. I'd often find the cursor jumping over a few pixels each time I tried to tap to click. This was aggravating at first, but then I found myself closing windows when I wanted them minimized or confirming something in a dialog that I didn't want to confirm.

Last December, [I wrote a post about some fixes][2]. However, as I force myself to migrate to Linux (no turning back this time) again, my fixes didn't work well enough. I [stumbled upon a post][3] about the X1's touchpad and how an Ubuntu user found a configuration file that seemed to work well.

Just as a timesaver, I've reposted his configuration here:

```
# softlink this file into:
# /usr/share/X11/xorg.conf.d

# and prevent the settings app from overwriting our settings:
# gsettings set org.gnome.settings-daemon.plugins.mouse active false


Section "InputClass"
    Identifier "nathan touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "synaptics"

    # three fingers for the middle button
    Option "TapButton3" "2"
    # drag lock
    Option "LockedDrags" "1"
    # accurate tap-to-click!
    Option "FingerLow" "50"
    Option "FingerHigh" "55"

    # prevents too many intentional clicks
    Option "PalmDetect" "0"

    # "natural" vertical and horizontal scrolling
    Option "VertTwoFingerScroll" "1"
    Option "VertScrollDelta" "-75"
    Option "HorizTwoFingerScroll" "1"
    Option "HorizScrollDelta" "-75"

    Option "MinSpeed" "1"
    Option "MaxSpeed" "1"

    Option "AccelerationProfile" "2"
    Option "ConstantDeceleration" "4"
EndSection
```


Many many thanks to [Nathan Hamblen][4] for assembling this configuration and offering it out to the masses on his blog.

 [1]: https://major.io/wp-content/uploads/2013/08/X1_closed.jpg
 [2]: /2012/12/28/handy-settings-for-the-touchpadclickpad-in-the-lenovo-x1-carbon/
 [3]: https://code.technically.us/post/50837506478/senistive-touchpads-and-ubuntu
 [4]: https://twitter.com/n8han
