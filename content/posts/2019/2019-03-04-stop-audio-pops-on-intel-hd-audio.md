---
author: Major Hayden
date: '2019-03-04'
images:
- images/2019-03-04-headphones.jpg
slug: stop-audio-pops-on-intel-hd-audio
tags:
- linux
- fedora
- sound
title: Stop audio pops on Intel HD Audio
---

![headphones]

I recently picked up a Dell Optiplex 7060 and I'm using it as my main
workstation now. The Fedora installation was easy, but I noticed a variety of
"pop" or clicking sounds when audio played, especially terminal bells.

If everything was quiet and I triggered a terminal bell, I would hear a loud
pop just before the terminal bell sound. However, if I played music and then
triggered a terminal bell, the pop was gone.

A quick Google search told me that the likely culprit was power saving
settings on my Intel HD Audio chipset:
```
$ lspci | grep Audio
00:1f.3 Audio device: Intel Corporation Cannon Lake PCH cAVS (rev 10)
```

## Fixing it

There's a handy power saving tunable available at
`/sys/module/snd_hda_intel/parameters/power_save` that can be usd to adjust
the timeout or disable power savings entirely. In my case, the delay was set
to one second.

```
$ cat /sys/module/snd_hda_intel/parameters/power_save
1
```

That would be good for a laptop use case, but my workstation is always
plugged in. I disabled it by setting it to zero:

```
# echo 0 > /sys/module/snd_hda_intel/parameters/power_save
$ cat /sys/module/snd_hda_intel/parameters/power_save
0
```

And the pops are gone! My Klipsch speakers have a built in amplifier and it
was likely the abrupt changes in current that was causing the popping noises.

This setting will last until you reboot. You can make it permanent by adding
this text to `/etc/modprobe.d/audio_disable_powersave.conf`:
```
options snd_hda_intel power_save=0
```

If you're a laptop user and you want power savings but fewer pops, you could
increase the delay to a more acceptable number. For example, setting it to
`60` would mean that the card will power down after 60 seconds of silence.
Just remember that you'll get a nice pop when the 60 seconds has passed and a
new sound is played.

## Learning more

Diving into the kernel code reveals the tunable in
`/sound/pci/hda/hda_intel.c`:

```c
static int power_save = CONFIG_SND_HDA_POWER_SAVE_DEFAULT;
module_param(power_save, xint, 0644);
MODULE_PARM_DESC(power_save, "Automatic power-saving timeout "
		 "(in second, 0 = disable).");
```

The default comes from a kernel config option:
`CONFIG_SND_HDA_POWER_SAVE_DEFAULT`. Most kernel packages on most
distributions provide access to the kernel config file that was used to build
the kernel originally. It's often found in `/boot` (named the same as the
kernel version) or it might be available at `/proc/config.gz`.

For Fedora, the kernel config is provided in `/boot` whenever a new kernel is
is installed. I inspected mine and found:

```
$ grep HDA_POWER_SAVE_DEFAULT /boot/config-4.20.13-200.fc29.x86_64
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=1
```

The `power_save` setting is applied in `/sound/pci/hda/hda_codec.c`:

```c
/**
 * snd_hda_set_power_save - reprogram autosuspend for the given delay
 * @bus: HD-audio bus
 * @delay: autosuspend delay in msec, 0 = off
 *
 * Synchronize the runtime PM autosuspend state from the power_save option.
 */
void snd_hda_set_power_save(struct hda_bus *bus, int delay)
{
	struct hda_codec *c;

	list_for_each_codec(c, bus)
		codec_set_power_save(c, delay);
}
EXPORT_SYMBOL_GPL(snd_hda_set_power_save);
```

We can look where `codec_set_power_save` is defined in the same file to learn
more:

```c
#ifdef CONFIG_PM
static void codec_set_power_save(struct hda_codec *codec, int delay)
{
	struct device *dev = hda_codec_dev(codec);

	if (delay == 0 && codec->auto_runtime_pm)
		delay = 3000;

	if (delay > 0) {
		pm_runtime_set_autosuspend_delay(dev, delay);
		pm_runtime_use_autosuspend(dev);
		pm_runtime_allow(dev);
		if (!pm_runtime_suspended(dev))
			pm_runtime_mark_last_busy(dev);
	} else {
		pm_runtime_dont_use_autosuspend(dev);
		pm_runtime_forbid(dev);
	}
}
```

This logic looks to see if `CONFIG_PM` is set to know if power management is
desired at all. From there, it checks if we disabled power saving but there's
a discrete graphics card involved (`codec->auto_runtime_pm`). This check is
important because the discrete graphics card cannot power down unless the HDA
card suspends at the same time.

Next, there's a check to see if the delay is greater than 0. This would be
the case if `CONFIG_SND_HDA_POWER_SAVE_DEFAULT` was set to `1` (Fedora's
default). If so, the proper auto suspend delays are set.

If the delay is 0, then autosuspend is disabled and removed from power
management entirely. This is the option I chose and it's working great.

_Photo source: [Max Pixel](https://www.maxpixel.net/Headphone-Caption-Music-Sound-Listing-Music-2694489)_

[headphones]: /images/2019-03-04-headphones.jpg