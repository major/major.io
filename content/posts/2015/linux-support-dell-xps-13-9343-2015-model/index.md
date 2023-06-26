---
aliases:
- /2015/02/03/linux-support-dell-xps-13-9343-2015-model/
author: Major Hayden
date: 2015-02-03 15:23:24
tags:
- dell
- fedora
- linux
title: Linux support for the Dell XPS 13 9343 (2015 model)
---

![1]

_<span style="color: #D42020;"><b>I'M ALL DONE:</b></span> I'm not working on Linux compatibility for the XPS 13 any longer. I've purchased a Lenovo X1 Carbon (3rd gen) and that's my preferred laptop. More on this change later._

* * *

I've been looking for a good laptop to run Linux for a while now and my new Dell XPS 13 9343 has arrived. It was released at CES in 2015 and it received quite a lot of attention for packing a large amount of pixels into a very small laptop frame with excellent battery life. Ars Technica has a [great overall review][2] of the device.

Linux support has been historically good on the previous generation XPS 13's and a [blog post from Dell][3] suggests that the latest revision will have good support as well. For a deep dive on the hardware inside the laptop, review [this GitHub Gist][4].

After wiping Windows 8.1 off the laptop, I started with the Fedora 21 installation. If you want to run Linux on one of these laptops, here's what you need to know:

## The good

All of the most basic devices work just fine. The display, storage, and peripheral connections (USB, SD card slot, mini DisplayPort) all work out of the box in Linux 3.18.5 with Fedora 21. The display looks great with GNOME 3's default HiDPI settings and it's very readable with the default font sizes without HiDPI (although this is a bit subjective).

The webcam works without any additional configuration the video quality is excellent.

The wireless card in the laptop I received is a BCM4352:

```
02:00.0 Network controller: Broadcom Corporation BCM4352 802.11ac Wireless Network Adapter (rev 03)
```

It's possible to get this card working with the b43 kernel modules but I've had better luck with the binary blob STA drivers from Broadcom. There are [plenty of guides][5] out there to help you install the kernel module for your Fedora kernel. I've had great network performance with the binary driver.

Some users are seeing Intel wireless cards in their Dell XPS 13's, especially in Europe. Opening the laptop for service [isn't terribly difficult][6] and you could replace the bluetooth/wireless card with a different one.

**PRO TIP:** If you're seeing errors in your journald logs about NetworkManager being unable to scan for access points, be sure to hit the wireless switch key on your keyboard (Fn-F12) to enable the card. This had me stumped for about 45 minutes. There's an option in the BIOS to disable the switch and let the OS control the wireless card.

The special keyboard buttons (volume up/down, brightness up/down) all work flawlessly.

## The bad

The touchpad and keyboard are on the I2C bus and this creates some problems. Many users have reported that keys on the keyboard seem to repeat themselves while you're typing and the touchpad has an issue where X stops receiving input from it. However, when the touchpad seems to freeze, the kernel still sees data coming from the device (verified with evtest and evemu-record).

There are some open bugs and discussion about the touchpad issues:

* [Linux Support is Terrible on the New Dell XPS 13 (2015)][7] [Reddit]
* [touchpad does not respond to tap-to-clicks in I2C mode in Ubuntu 15.04 on 2015 XPS 13 (9343)][8] [Launchpad Bug]
* [Dell XPS 13 9343 (2015) touchpad freeze][9] [Red Hat Bug]

You can connect up a mouse and keyboard to the laptop and work around those issues. However, dragging around some big peripherals with such a small laptop isn't a great long-term solution. Some users suggested blacklisting the i2c_hid module so that the touchpad shows up as a plain PS/2 touchpad but I'm still seeing freezes even after making that change.

If you're having one of those &#8220;touchpad on the I2C bus?&#8221; moments like I had, read Synaptics' [brief page about Intertouch][10]. Using the I2C bus saves power, reduces USB port consumption, and allows for more powerful multi-touch gestures.

Oddly enough, the touchscreen is an ELAN Touchscreen and it runs over USB. It suffers from the same freezes that the touchpad does.

## The ugly

Sound is a big problem. The microphone, speakers and headphone port don't work under 3.18.5 and 3.19.0-rc7. The audio device is a ALC3263 from RealTek and it should use the same module as the RT286. However, the probing still fails and the module can't be used. The [module code][11] seems to be correct but the probing still fails.

There's an open bug on Launchpad about the problem:

* [Audio broken on 2015 XPS 13 (9343) in I2S mode in Ubuntu 14.10/15.04][12] [Launchpad bug]
* [No sound on Dell XPS 13 9343 (2015 model)][13] [Red Hat bug]
* [broadwell-audio: rt286 device appears, no sound (Dell XPS 13 9343)][14] [Linux kernel bug]

I connected up an old Syba USB audio device to the USB port and was able to get sound immediately. This is also a horrible workaround.

## What now?

From what I gather, Dell is extremely eager to make Linux work on the new XPS 13 and we should see some movement on these bugs soon. I'm still doing a bunch of testing on my own with kernel 3.19 and I'll be keeping this page updated as news becomes available.

If you know much about the I2C bus or about the sound devices in this laptop and you have some time available to help, just let me know where to send the beer. ;)

## Latest updates

#### 2015-02-03

Added Red Hat bug link for sound issues.

#### 2015-02-05

The touchpad bug has been reduced to a kernel issue. Recordings from evemu-record look fine when they're played back in X. Users reported in Launchpad and in the Red Hat bug that kernel 3.16 works perfectly but 3.17 doesn't. A kernel bisection will most likely be required to find the patch that broke the touchpad.

Many users find that adding `acpi.os="!Windows 2013"` to the kernel boot line will bring the audio card online after 1-3 reboots. Apparently there is some level of state information stored in memory that requires a few reboots to clear it. I haven't verified this yet.

#### 2015-02-06

Kernel bisect for the touchpad issue is underway. Every 3.16.x kernel I built would keep the trackpad in PS/2 mode and that's not helpful at all. There's no multi-finger taps/clicks/gestures. 3.17.0 works perfectly, however. My gut says something broke down between 3.17.0 and 3.18.0 but it might actually be closer to 3.17.4 since Fedora 21's initial kernel is 3.17.4 (and the touchpad doesn't work well with it).

A post was made on [Barton's Blog][15] yesterday about Dell being aware of the Linux issues. _(Thanks to Chris' comment below!)_

After about 35 kernel builds during the most frustrating git bisect of my life, I found the [problematic patch][16]. The [Red Hat bug][17] is updated now and I'm hoping that someone with a detailed knowledge of this part of the kernel can make sense of it:

```diff
From d1c7e29e8d276c669e8790bb8be9f505ddc48888 Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Thu, 11 Dec 2014 16:02:45 -0800
Subject: HID: i2c-hid: prevent buffer overflow in early IRQ

Before ->start() is called, bufsize size is set to HID_MIN_BUFFER_SIZE,
64 bytes. While processing the IRQ, we were asking to receive up to
wMaxInputLength bytes, which can be bigger than 64 bytes.

Later, when ->start is run, a proper bufsize will be calculated.

Given wMaxInputLength is said to be unreliable in other part of the
code, set to receive only what we can even if it results in truncated
reports.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 747d544..9c014803b4 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -369,7 +369,7 @@ static int i2c_hid_hwreset(struct i2c_client *client)
 static void i2c_hid_get_input(struct i2c_hid *ihid)
 {
 	int ret, ret_size;
-	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
+	int size = ihid->bufsize;

 	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
 	if (ret != size) {
```

I reverted the patch in Linux 3.19-rc7 and built the kernel. The touchpad works flawlessly. However, simply reverting the patch probably isn't the best idea long term. ;)

#### 2015-02-07

The [audio patch][18] mentioned in the [Launchpad bug report][19] didn't work for me on Linux 3.19-rc7.

#### 2015-02-10

Progress is still being made on the touchpad in the [Red Hat bug][17] ticket. If you can live with the pad working as PS/2, you can get sound by adding `acpi_osi="!Windows 2013"` to your kernel command line. Once you do that, you'll need to:

  1. Do a warm reboot
  2. Wait for the OS to boot, then do a full poweroff
  3. Boot the laptop, then do a full poweroff
  4. Sound should now be working

If sound still isn't working, you may need to install `pavucontrol`, the PulseAudio volume controller, and disable the HDMI sound output that is built into the Broadwell chip.

This obviously isn't a long-term solution, but it's a fair workaround.

#### 2015-02-11

There is now a [patch][20] that you can apply to 3.18 or 3.19 kernels that eliminates the trackpad freeze:

```diff
From 2a2aa272447d0ad4340c73db91bd8e995f6a0c3f Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date: Tue, 10 Feb 2015 12:40:13 -0500
Subject: [PATCH] HID: multitouch: force release of touches when i2c
 communication is not reliable

The Dell XPS 13 9343 (2015) shows that from time to time, i2c_hid misses
some reports from the touchpad. This can lead to a freeze of the cursor
in user space when the missing report contains a touch release information.

Win 8 devices should have a contact count reliable, to we can safely
release all touches that has not been seen in the current report.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f65e78b..48b051e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1021,6 +1021,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
 		td->serial_maybe = true;

+	if ((id->group == HID_GROUP_MULTITOUCH_WIN_8) && (hdev->bus == BUS_I2C))
+		/*
+		 * Some i2c sensors are not completely reliable with the i2c
+		 * communication. Force release of unseen touches in a report
+		 * to prevent bad behavior from user space.
+		 */
+		td->mtclass.quirks |= MT_QUIRK_NOT_SEEN_MEANS_UP;
+
 	ret = hid_parse(hdev);
 	if (ret != 0)
 		return ret;
```

I've tested it against 3.19-rc7 as well as Fedora's 3.18.5. However, tapping still doesn't work yet with more than one finger. The touchpad jumps around a bit when you apply two fingers to it.

#### 2015-02-12

Rene commented below that he [found a post in alsa devel with a patch][21] for the &#8220;Dell Dino&#8221; that looks like it might help with the i2c audio issues. Another kernel maintainer replied and asked for some of the code to be rewritten to make it easier to handle audio quirks. UPDATE: Audio patch didn't work.

We've created an IRC channel on Freenode: #xps13.

There's an interesting [kernel patch mentioning &#8220;Dell Dino&#8221;][22] that is line for inclusion in 3.20-rc1. Someone in IRC found &#8220;Dell Dino&#8221; mentioned on a [Dell business purchase page][23]. The board name from dmidecode in the patch is **0144P8** but that doesn't match other known board names. My i5-5200U with touch is **0TM99H** while a user with a non-touch i5 has a board name of **OTRX4F**. Other i5 touch models have the same board name as mine. All BIOS revisions found so far are A00 (the latest on Dell's site).

A probe for the rt286 module looks like it starts to happen and then it fails (skip to line 795):

```
[    4.141189] rt286 i2c-INT343A:00: probe
[    4.141245] i2c i2c-8: master_xfer[0] W, addr=0x1c, len=4
[    4.141246] i2c i2c-8: master_xfer[1] R, addr=0x1c, len=4
[    4.141249] i2c_designware INT3432:00: i2c_dw_xfer: msgs: 2
[    4.141389] i2c_designware INT3432:00: Standard-mode HCNT:LCNT = 432:507
[    4.141391] i2c_designware INT3432:00: Fast-mode HCNT:LCNT = 72:160
[    4.141662] i2c_designware INT3432:00: i2c_dw_isr:  Synopsys DesignWare I2C adapter enabled= 0x1 stat=0x10
[    4.141670] i2c_designware INT3433:00: i2c_dw_isr:  Synopsys DesignWare I2C adapter enabled= 0x1 stat=0x0
[    4.141695] i2c_designware INT3432:00: i2c_dw_isr:  Synopsys DesignWare I2C adapter enabled= 0x1 stat=0x750
[    4.141703] i2c_designware INT3433:00: i2c_dw_isr:  Synopsys DesignWare I2C adapter enabled= 0x1 stat=0x0
[    4.141965] i2c_designware INT3432:00: i2c_dw_handle_tx_abort: slave address not acknowledged (7bit mode)
[    4.141968] rt286 i2c-INT343A:00: Device with ID register 0 is not rt286
[    4.160506] i2c-core: driver [rt286] registered
```

**<a name="2015-02-16">2015-02-16</a>**

I received an email from a Realtek developer about the sound card in the XPS:

> I see &#8220;rt286 i2c-INT343A:00: Device with ID register 0 is not rt286&#8221; in the log. It means there are something wrong when the driver is trying to read the device id of codec. I believe that is due to I2C read/write issue. ALC3263 is a dual mode (I2S and HDA) codec. And BIOS will decide which mode according to OS type. So, if you want to use i2s mode, you need to configure your BIOS to set ALC3263 to I2S mode.

After poring through the [DSDT and other ACPI tables][25] over the weekend (and building way too many kernels with overriden DSDT's), it sounds like a BIOS update may be required for the sound card to function properly. The [sound devices][26] specified in the DSDT that are on the i2c bus are only activated after a BUNCH of checks succeed. One of them is the check of `OSYS`, the system's operating system. Setting `acpi_osi="Windows 2013"` does flip `OSYS` to `0x07DD`, but that's only part of the fix. There are other variables checked, like `CODS` (that shows up very often) that are instantiated early in the DSDT but I can't find them ever being set to a value anywhere in the DSDT code. These variables equal zero by default and that disables critical parts of the sound device.

My take: This laptop is going to need a BIOS update of some sort before we can get sound working properly in Linux with an i2c touchpad. If someone is more skilled with DSDT's than I am, I'll be glad to share all of my work that I've tried so far. As for now, I'm going to be waiting eagerly for some type of firmware update from Dell.

**<a name="2015-02-17">2015-02-17</a>**

There's some progress on the sound card in Linux! After building the latest commits from [linux.git's master branch][27], my XPS started showing a device called &#8220;broadwell-rt286&#8221; in pavucontrol. It showed up as a normal audio device but it had no output support, only input. I tried to enable the microphone but I couldn't record any sound.

I found a [kernel bug][28] from a ThinkPad Helix 2 user with a very similar hardware setup. Their rt286 device is on the I2S bus with a Haswell SoC. Their fix was to copy over the latest firmware binaries from [linux-firmware.git][29] and reboot. I did the same and an output device suddenly showed up in pavucontrol after a reboot.

When I played sounds via aplay, canberra-gtk-play, and rhythmbox, I could see the signal level fluctuating in pavucontrol on the broadwell-rt286 device. However, I couldn't hear the sound through the speakers. I connected headphones and I couldn't hear any sound there either.

There's now a [kernel bug ticket][14] open for the sound issue.

Stay tuned for a BIOS update with a potential keyboard repeat fix. It's already been talked about in IRC as a potential A01 release sssssssssssoon:

> someone asked about the fix for the repeating keypresses. yes, it was traced back to the source and will be fixed on all affected Dell platforms soon

> I just saw that the one for 9343 was promoted to our factories so should be up on support.dell.com any day now as BIOS A01

You can get notifications about driver releases for the XPS on [Dell's site][30].

**<a name="2015-03-04">2015-03-04</a>**

<del datetime="2015-03-09T13:02:22+00:00">Sound on the I2S bus is working in Linux 4.0-rc2!</del> _See note from 2015-03-08 below._ I was too exhausted last night for a full write-up, but here's the gist of what I did:

First off, build 4.0-rc2 with all of the available I2C and ALSA SoC modules. I haven't narrowed down which modules are critical quite yet. Once you've built the kernel and rebooted into it, run `alsamixer` and choose the `broadwell-rt286` card. Hold the right arrow key until you go all the way to the right of the alsamixer display and press M to unmute the last control there. You should now be able to turn up the volume and play some test sounds.

Luckily, no update for linux-firmware is required. Also, there's no need for any ALSA UCM files as I had originally thought.

Stay tuned for a more in-depth write-up soon.

**<a name="2015-03-08">2015-03-08</a>**

After a few more reboots, I can't get sound working again. I'm wondering if I had an errant `acpi_osi` setting somewhere during my testing that brought sound up on the HDA bus. :/

 [1]: https://major.io/wp-content/uploads/2015/02/dellXPS13-9343_2.jpg
 [2]: http://arstechnica.com/gadgets/2015/01/hands-on-dell-xps-13-packs-a-13-inch-screen-into-an-11-inch-laptop/
 [3]: http://en.community.dell.com/techcenter/b/techcenter/archive/2015/01/27/you-asked-for-it-ubuntu-officially-on-the-precision-m3800-worldwide
 [4]: https://gist.github.com/semenko/60015029e13c1de65ff6
 [5]: http://www.cyberciti.biz/faq/fedora-linux-install-broadcom-wl-sta-wireless-driver-for-bcm43228/
 [6]: http://www.myfixguide.com/manual/dell-xps-13-9343-disassembly/
 [7]: http://www.reddit.com/r/linux/comments/2u0jjd/linux_support_is_terrible_on_the_new_dell_xps_13/
 [8]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1416601
 [9]: https://bugzilla.redhat.com/show_bug.cgi?id=1188439
 [10]: http://www.synaptics.com/en/intertouch.php
 [11]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1413446/comments/13
 [12]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1413446
 [13]: https://bugzilla.redhat.com/show_bug.cgi?id=1188741
 [14]: https://bugzilla.kernel.org/show_bug.cgi?id=93361
 [15]: http://bartongeorge.net/2015/02/05/update-dell-xps-13-laptop-developer-edition-sputnik-gen-4/
 [16]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1c7e29e8d276c669e8790bb8be9f505ddc48888
 [17]: https://bugzilla.redhat.com/show_bug.cgi?id=1188439#c25
 [18]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1413446/+attachment/4313687/+files/rt288.patch
 [19]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1413446#30
 [20]: https://bugzilla.redhat.com/attachment.cgi?id=990188
 [21]: http://mailman.alsa-project.org/pipermail/alsa-devel/2015-February/087462.html
 [22]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2cc3f2347022969f00a429951ce489d35a9b4ea8
 [23]: http://www.dell.com/us/business/p/xps-13-9343-laptop/fs
 [25]: https://github.com/major/xps-13-9343-dsdt
 [26]: https://github.com/major/xps-13-9343-dsdt/blob/master/DSDT.dsl#L8700
 [27]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/
 [28]: https://bugzilla.kernel.org/show_bug.cgi?id=92061#c24
 [29]: http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git
 [30]: http://www.dell.com/support/home/us/en/04/product-support/product/xps-13-9343-laptop/drivers