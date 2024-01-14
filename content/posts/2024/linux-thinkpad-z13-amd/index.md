---
author: Major Hayden
date: '2024-01-14'
summary: |
  Now that AMD's Zen 4 CPUs landed in lots of laptops, I picked up a ThinkPad Z13 G2
  with an AMD Ryzen CPU. Did I put Linux on it? Of course I did. 🐧
tags: 
  - amd
  - fedora
  - laptop
  - linux
  - sway
  - thinkpad
title: Linux on the AMD ThinkPad Z13 G2
coverAlt: A brown highland cow with the sun behind it
coverCaption: |
  [Dylan Leagh](https://unsplash.com/photos/brown-yak-on-green-grass-field-during-daytime-UG3L8WAQLBs)
  via Unsplash
---

AMD's new [Zen 4 processors](https://en.wikipedia.org/wiki/Zen_4) started rolling out in 2022 and I've been watching for the mobile CPUs to reach laptops.
I like where AMD is going with these chips and how they provide lots of CPU power without eating up the battery.

I recently ordered a [ThinkPad Z13 Gen 2](https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpadz/thinkpad-z13-gen-2-(13-inch-amd)/len101t0073) with an AMD Ryzen 7.
As you might expect, I loaded it up with Fedora Linux and set out to ensure that everything works.

This post includes all of the configurations and changes I added along the way.

# Power management

I removed the power profiles daemon that comes with Fedora by default. and replaced it with [tlp](https://linrunner.de/tlp/index.html).
This is a great package for ThinkPad laptops as it takes care of most of the power management configuration for you with sane defaults.
It also offers an easy to read configuration file where you can make adjustments.

The defaults seem to be working well so far, but my only complaint is that the power management for `amdgpu` seems to be _really aggressive_.
Graphics performance on battery power is _okay_, but I'm told this improves in kernel 6.7.
I'm on 6.6.11 in Fedora 39 right now.

I'll wait to see if this new kernel makes any improvements.

# Touchpad

The ELAN touchpad in the Z13 is a bit different.
It's a *haptic* touchpad.
It doesn't push down with a click like the other thinkpads.
It provides haptic feedback, much like a mobile phone does when you tap on the screen.
(I usually turn this off on my phone, but it feels good on the laptop.)

The touchpad works right out of the box without any additional configuration.
I made a basic Sway configuration stanza to get it configured with my preferences:

```ini
# ThinkPad Z13 Gen 2 AMD Touchpad
input "11311:40:SNSL0028:00_2C2F:0028_Touchpad" {
  drag disabled
  tap enabled
  dwt enabled
  natural_scroll disabled
}
```

The configuration above enables tap to click and dragging with taps.
I like the old school scrolling style and I've disabled the natural scroll.

You can always get a list of your input devices in Sway with `swaymsg`:

```console
swaymsg -t get_inputs
```

# Display

The display worked right out of the box but the UI elements were scaled up far too large for me.
I typically value screen real estate over all other aspects, but my usual default of scaling to 1.0 made the UI far too small.

I set my output scaling to 1.2:

```ini
# Disable HiDPI
output * scale 1.2
```

I also enabled the [RPM Fusion repos](https://rpmfusion.org/Howto/Multimedia) to get the freeworld AMD Mesa drivers:

```console
sudo dnf install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
```

# Audio

Sound worked right out of the box, but I found that the loudness preset from [easyeffects](https://github.com/wwmm/easyeffects) made the speakers sound a little bit better:

```console
sudo dnf install easyeffects
```

# Everything else

Everything else just worked!

I'm really pleased with the performance and the battery life so far.
My only complaint is that the OLED screen can be a battery hog at times.

For more details, check out the [Arch Linux wiki page for the Z13](https://wiki.archlinux.org/title/Lenovo_ThinkPad_Z13).
They documented lots of the function keys if you want to create keyboard shortcuts and they link to some downloadable monitor profiles.