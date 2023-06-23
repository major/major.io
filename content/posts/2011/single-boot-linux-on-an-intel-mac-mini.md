---
aliases:
- /2011/01/26/single-boot-linux-on-an-intel-mac-mini/
author: Major Hayden
date: 2011-01-26 13:32:53
dsq_thread_id:
- 3642806490
tags:
- apple
- command line
- linux
title: Single boot Linux on an Intel Mac Mini
---

After reading the title of this post, you might wonder &#8220;Why would someone pay for a Mac Mini and then not use OS X with it?&#8221; Well, if you have a somewhat older Mac Mini you want to use as a server with Linux, these instructions will come in handy.

To get started, you'll need a few things:

  * Mac OS X Install Disc
  * Your [favorite][1] Linux distribution's install or live CD/DVD
  * A CD with [refit][2] on it

First off, boot the Mac into your normal OS X installation first and mute the sound. This will get rid of the Mac chime on bootup. It's really difficult to get this done properly outside of OS X, so take the time to do it now. Put your Linux CD/DVD in the drive and reboot. While it's rebooting, hold down the Option key (alt key if you're using a PC keyboard) and you'll have the option to boot from the disc when it boots up. The boot screen might say &#8220;Windows&#8221; for the Linux CD/DVD, but choose it anyway.

When I installed Fedora, I had to switch the hard drive's partition table from GPT to a plain old &#8220;msdos&#8221; partition table. Hop into a terminal, start `parted` on your main hard disk and type `mklabel msdos`. This will instantly erase the hard drive &#8212; make sure you're ready for this step. If you're using an anaconda-based installation, you can get to a root shell by pressing CTRL-ALT-F2. When you're done with `parted` in that terminal, switch back to anaconda with CTRL-ALT-F6.

At this point, you shouldn't have any partitions on your disk and you'll be ready to install your Linux distribution normally. I generally put everything in one giant partition as it makes the &#8220;bless&#8221; step a little easier later on.

Eject the Linux CD/DVD once the installation is complete and toss in the refit CD that you burned previously. Reboot the Mini again while holding Option (or alt key) and choose the disc again at bootup. When refit appears, choose the second icon from the left in the bottom row and press enter. It might say that your GPT partition is empty &#8212; that's okay.

Reboot again, but hold down the Eject key (or F12 on PC keyboards) during boot to eject the refit disc. Pop in the OS X install disc (may need to reboot again to get it to boot) and open a terminal once the install disc fully boots. Once you're in the terminal, run `diskutil list` to figure out which partition is your boot partition. If you did one giant partition, this should be `/dev/disk0s1`. Just &#8220;bless&#8221; the partition to make it valid for booting:

<pre lang="html">bless --device /dev/disk0s1 --setBoot --legacy --verbose</pre>

Reboot again while holding Eject (or F12) to get the OS X disc out of the drive. At this point, you should be ready to go for hands-off booting. My Mac Mini went through about 10-20 seconds of wild screen flickering from grey to black to grey to black but then I saw the familiar Fedora framebuffer.

If you intend to run the Mac Mini headless with Linux, you're going to run into a problem. The legacy BIOS used to boot Linux requires a monitor to be attached, but there are [some workarounds][3]. Also, if you want the Mini to power back on in case of a power failure, just run this at each boot:

<pre lang="html">setpci -s 0:1f.0 0xa4.b=0</pre>

Helpful resources:

<http://mac.linux.be/content/single-boot-linux-without-delay>

<http://www.alphatek.info/2009/07/22/natively-run-fedora-11-on-an-intel-mac/>

 [1]: http://mirror.rackspace.com/fedora/releases/
 [2]: http://refit.sourceforge.net/
 [3]: http://soledadpenades.com/2009/02/10/mac-mini-as-a-headless-server/