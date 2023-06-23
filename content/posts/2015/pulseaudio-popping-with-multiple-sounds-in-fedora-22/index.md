---
aliases:
- /2015/06/08/pulseaudio-popping-with-multiple-sounds-in-fedora-22/
author: Major Hayden
date: 2015-06-08 13:37:24
dsq_thread_id:
- 3831330407
tags:
- fedora
- pulseaudio
title: PulseAudio popping with multiple sounds in Fedora 22
---

![1]

My transition from Fedora 21 to 22 on the ThinkPad X1 Carbon was fairly uneventful even with over 2,400 packages involved in the upgrade. The only problem I dealt with on reboot was that my icons on the GNOME 3 desktop were way too large. That's a pretty easy problem to fix.

However, something else cropped up after a while. I started listening to music in Chrome and a Pidgin notification sound came through. There was a quiet pop before the Pidgin sound and a loud pop on the end. Thunderbird's notifications sounded the same. The pops at the end of the sound were sometimes **very** loud and hurt my ears.

I started running PulseAudio in debug mode within a terminal:

```
pulseaudio -k
pulseaudio --start
```


There were some messages about buffer underruns and latency issues but they were all very minimal. I loaded up [pavucontrol][2] and couldn't find anything unusual when multiple sounds played. I gave [pavumeter][3] a try and found something very interesting.

When Chrome was playing audio, the meters in pavumeter were at 80-90%. That seems to make sense because I keep Chrome as one of the loudest applications on my laptop. My logic there is that I don't want to get blasted by a notification tone that is drastically louder than my music.

However, if I received a Pidgin or Thunderbird notification while Chrome was playing music, the pavumeter showed the volume levels dropping to 30% or less. As soon as the sound was over, the meters snapped back to 80-90% and there was a big popping sound. I lowered Chrome's volume so that it showed up at the 30% level in pavumeter and forced a new Pidgin notification sound - the pops were still there.

I started searching in Google and stumbled upon [ArchLinux's PulseAudio documentation][4]. (Their documentation is really awesome.) There's a mention of the _flat-volumes_ PulseAudio configuration option. If it's set to _no_, you get the older ALSA functionality where volumes can be set independently per application. The default is _yes_ and that default comes with a warning in the documentation:

> Warning: The default behavior can sometimes be confusing and some applications, unaware of this feature, can set their volume to 100% at startup, potentially blowing your speakers or your ears. To restore the classic (ALSA) behavior set this to no.

As a test, I switched _flat-volumes_ to _no_ in `/etc/pulse/daemon.conf`. I restarted PulseAudio with the new setting:

```
pulseaudio -k
pulseaudio --start
```


I started music in Chrome and sent myself an IM in Pidgin. No pops! An email came through and Thunderbird and a notification sound played. No pops there, either!

GNOME 3 was a bit unhappy at my PulseAudio tinkering and the volume control disappeared from the menu at the top right. I logged out of my GNOME session and logged back in to find the volume control working again.

_Photo Credit: [Our Thrift Apt.][5] via [Compfight][6] [cc][7]_

 [1]: /wp-content/uploads/2015/06/8346700794_a9c0475bd8_b-e1433770480154.jpg
 [2]: http://freedesktop.org/software/pulseaudio/pavucontrol/
 [3]: http://0pointer.de/lennart/projects/pavumeter/
 [4]: https://wiki.archlinux.org/index.php/PulseAudio#Configuration_files
 [5]: https://www.flickr.com/photos/75638411@N05/8346700794/
 [6]: http://compfight.com
 [7]: https://www.flickr.com/help/general/#147