---
aliases:
- /2015/03/30/review-lenovo-x1-carbon-3rd-generation-and-linux/
author: Major Hayden
date: 2015-03-30 14:15:52
dsq_thread_id:
- 3642808074
tags:
- fedora
- general advice
- kernel
- laptop
- lenovo
title: 'Review: Lenovo X1 Carbon 3rd generation and Linux'
---

![1]

After a [boatload of challenges][2] with what I thought would be my favorite Linux laptop, the [Dell XPS 13 9343][3], I decided to take the plunge on a new [Lenovo X1 Carbon (3rd gen)][4]. My late-2013 MacBook Pro Retina (MacbookPro11,1) had plenty of quirks when running Linux and I was eager to find a better platform.

<!--more-->

### Display & Screen

I opted for the model with the i5-5300U, 8GB RAM, 256GB SSD, and the 2560&#215;1440 display. The high resolution display comes in two flavors: touch (glossy) and non-touch (matte). I went with the matte and I've been very pleased with it so far. It comes up a bit short on pixels when you compare it with the XPS 13's 3200&#215;1800 display but it's still very good. I run GNOME 3 with HIDPI disabled and having a few less pixels makes it much easier to read while still being **very detailed**.

The display is plenty bright and also very readable when set to very low brightness. Reducing the brightness also extends the battery life by quite a bit (more on that later). Gaming performance isn't good but you wouldn't want this laptop as a gaming rig, anyway.

### Storage

You can get the PCI-e storage option with 512GB but the high price tag hurts. The 256GB m2 SATA drive in my X1 is plenty fast. The drive in my laptop is a Samsung and it's a big improvement over some of the Sandisk drives I've had in other Lenovo laptops.

### Network

The wireless card is an [Intel 7265][5] and is supported out of the box with the [iwlwifi][6] module in the upstream kernel. It also provides Bluetooth and it works like a charm. I've paired up with many devices easily and transferred data as I'd expect.

There's no full size ethernet port on this laptop (obviously). However, you can use the Lenovo proprietary ethernet dongle provided with the laptop and use the built-in [Intel I218-LM][7] ethernet card. It uses the e1000 driver and works out of the box.

### Input devices

The island-style keyboard takes a little getting used to when you're coming from the chiclets on the MacBook Pro. It feels great and the key travel is quite nice when compared with other laptops. The Dell XPS 13's key travel is poor in comparison.

The touchpad at the front of the laptop works quite well and the little trough right in front of the bottom of the pad is handy for click and drag gestures. The synaptics driver for X works right out of the box and libinput works, too.

The trackpoint (also called &#8220;keyboard nipple&#8221;) is fine but I can't use it worth a darn. I'm downright horrible at it. That's not Lenovo's fault &#8212; my brain is probably dysfunctional. The trackpoint buttons (below the space bar) are hooked up to the touchpad and this has caused some problems. There's a fix to get the left and middle buttons working in Linux 4.0 and you'll [find that patch backported][8] in some other distributions, like Arch and Fedora. I don't use those buttons much but I could see how some people might want to do some two-handed click and drag gestures with them.

All of the keys on the keyboard work as expected, but you'll need to load up the **thinkpad_acpi** module to get the brightness buttons working. In my case, I had to force the module to load since the module didn't recognize my embedded controller:

```
modprobe thinkpad_acpi force_load=1
```

Another nice benefit of the module is that you can control some of the LED's on the laptop programmatically. For example, you could blink the power button to signify your own custom alerts. You could also disable it entirely.

**Battery life**

Broadwell was supposed to bring some good power benefits and it's obvious that the X1 Carbon benefits from that CPU. I've been off battery for about two hours while writing this post, handling email and updating some packages. GNOME says there is 84% of my battery left and it's estimating about 7 hours and 45 minutes remaining. I've yet to see this laptop actually empty out entirely. I've gone for 10 hour stretches with it and it still has one or two hours left.

I'm not using any [powertop][10] tweaks, but I did install [tlp][11] and I'm using it on startup. Some folks have tweaked a few additional things from powertop and they've messed with the i915 module's refresh rate. That might give you another 5-10% on the battery but I'm already very pleased with my current battery life.

**Linux compatibility**

There are two main issues:

  * Trackpoint left/middle buttons don't work (fixed in 4.0 and backported in many distros)
  * Brightness and display switch keys don't work (load the **thinkpad_acpi** module for that)

Considering that the fix for the first issue is widely available in most distributions and the second one is only a modprobe away, I'd say this laptop is pretty darned Linux compatible. I'm currently running Fedora 21 without any problems.

### Wrap up

Thanks for reading this far! Let me know if I've missed anything and I'll be glad to update the post.

 [1]: https://major.io/wp-content/uploads/2015/03/ThinkPad-Carbon-X1.jpg
 [2]: /2015/02/03/linux-support-dell-xps-13-9343-2015-model/
 [3]: http://www.dell.com/us/p/xps-13-9343-laptop/pd
 [4]: http://shop.lenovo.com/us/en/laptops/thinkpad/x-series/x1-carbon/
 [5]: http://www.intel.com/content/www/us/en/wireless-products/dual-band-wireless-ac-7265.html
 [6]: http://www.intel.com/support/wireless/wlan/sb/CS-034398.htm
 [7]: http://ark.intel.com/products/71307/Intel-Ethernet-Connection-I218-LM
 [8]: https://bugzilla.redhat.com/show_bug.cgi?id=1200778
 [10]: http://en.wikipedia.org/wiki/PowerTOP
 [11]: https://wiki.archlinux.org/index.php/TLP