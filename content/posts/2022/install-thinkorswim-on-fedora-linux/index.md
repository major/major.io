---
author: Major Hayden
date: '2022-03-31'
summary: >-
  Learn how to install TD Ameritrade's ThinkOrSwim desktop application on Linux and
  get everything working. 💸
tags:
  - fedora
  - finance
  - java
  - options
  - sound
  - stocks
title: Install ThinkOrSwim on Fedora Linux
---

_Photo credit: [Robert Linder](https://unsplash.com/photos/YzNehPDLAa8)_

Over the past two years, I picked up stock trading and general finance knowledge as a
hobby. There are plenty of things I enjoy here: complex math, understanding trends, and
making educated guesses on what happens next. Getting the right tools makes this job a
little bit easier.

I use [TD Ameritrade] for the majority of my trading and learning. They offer a desktop
application with a great name: [ThinkOrSwim]. Using it feels a bit like flying the Space
Shuttle at first, but it delivers tons of information and analysis in a small package.

This post isn't about stock trading -- it's about how to wrestle ThinkOrSwim onto a
Fedora Linux machine and get everything working as it should. 🐧

[TD Ameritrade]: https://www.tdameritrade.com/
[ThinkOrSwim]: https://www.tdameritrade.com/tools-and-platforms/thinkorswim.html

## Getting (the right) Java

[ThinkOrSwim's download page] mentions installing Zulu OpenJDK 11 first. This is a
special certified release of the JDK that is well-tested with ThinkOrSwim.

Visit the [RPM-based Linux] page for Azul's OpenJDK and follow the steps they provide:

```console
$ sudo dnf install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm
$ sudo dnf install zulu11-jdk
```

If you already have a JDK installed, you'll need to switch to the Azul JDK as the
primary one. I have some other Java applications on my desktop and they seem to work
just fine with this JDK. We will use the `alternatives` script to manage the symlinks
for our default JDK:

```console
$ sudo alternatives --config java

There are 2 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
*+ 1           java-17-openjdk.x86_64 (/usr/lib/jvm/java-17-openjdk-17.0.2.0.8-7.fc36.x86_64/bin/java)
   2           /usr/lib/jvm/zulu11/bin/java

Enter to keep the current selection[+], or type selection number:
```

Press `2` here and then press ENTER. Double check that the Azul JDK is the primary:

```console
$ java --version
openjdk 11.0.14.1 2022-02-08 LTS
OpenJDK Runtime Environment Zulu11.54+25-CA (build 11.0.14.1+1-LTS)
OpenJDK 64-Bit Server VM Zulu11.54+25-CA (build 11.0.14.1+1-LTS, mixed mode)
```

[RPM-based Linux]: https://docs.azul.com/core/zulu-openjdk/install/rpm-based-linux

## Adding ALSA support

Yes, we are going back in time and getting ThinkOrSwim talking with ALSA. We will need
`libasound_module_pcm_pulse.so` on the system:

```console
$ sudo dnf whatprovides '*/libasound_module_pcm_pulse.so'
Last metadata expiration check: 3:09:00 ago on Thu 31 Mar 2022 11:14:57 AM CDT.
alsa-plugins-pulseaudio-1.2.6-2.fc36.i686 : Alsa to PulseAudio backend
Repo        : fedora
Matched from:
Filename    : /usr/lib/alsa-lib/libasound_module_pcm_pulse.so

alsa-plugins-pulseaudio-1.2.6-2.fc36.x86_64 : Alsa to PulseAudio backend
Repo        : @System
Matched from:
Filename    : /usr/lib64/alsa-lib/libasound_module_pcm_pulse.so

alsa-plugins-pulseaudio-1.2.6-2.fc36.x86_64 : Alsa to PulseAudio backend
Repo        : fedora
Matched from:
Filename    : /usr/lib64/alsa-lib/libasound_module_pcm_pulse.so

$ sudo dnf install alsa-plugins-pulseaudio
```

Now that we have ALSA support, let's move on to configuring the JDK to use it properly.
Keith Packard [ran into sound problems in Ubuntu] and fixed it with a small change to
his `sound.properties` file:

```properties
#javax.sound.sampled.Clip=org.classpath.icedtea.pulseaudio.PulseAudioMixerProvider
#javax.sound.sampled.Port=org.classpath.icedtea.pulseaudio.PulseAudioMixerProvider
#javax.sound.sampled.SourceDataLine=org.classpath.icedtea.pulseaudio.PulseAudioMixerProvider
#javax.sound.sampled.TargetDataLine=org.classpath.icedtea.pulseaudio.PulseAudioMixerProvider

javax.sound.sampled.Clip=com.sun.media.sound.DirectAudioDeviceProvider
javax.sound.sampled.Port=com.sun.media.sound.PortMixerProvider
javax.sound.sampled.SourceDataLine=com.sun.media.sound.DirectAudioDeviceProvider
javax.sound.sampled.TargetDataLine=com.sun.media.sound.DirectAudioDeviceProvider
```

Let's double check that this will work for the Azul JDK. We need to see if these
`com.sun.media.sound` import paths exists for us:

```console
$ find /usr/lib/j* |grep -i sound
/usr/lib/jvm/java-17-openjdk-17.0.2.0.8-7.fc36.x86_64/lib/libjsound.so
/usr/lib/jvm/zulu11-ca/conf/sound.properties
/usr/lib/jvm/zulu11-ca/lib/libjsound.so

$ strings /usr/lib/jvm/zulu11-ca/lib/libjsound.so | grep DirectAudioDeviceProvider
Java_com_sun_media_sound_DirectAudioDeviceProvider_nNewDirectAudioDeviceInfo
Java_com_sun_media_sound_DirectAudioDeviceProvider_nGetNumDevices
?com/sun/media/sound/DirectAudioDeviceProvider$DirectAudioDeviceInfo
Java_com_sun_media_sound_DirectAudioDeviceProvider_nNewDirectAudioDeviceInfo
Java_com_sun_media_sound_DirectAudioDeviceProvider_nGetNumDevices
```

Awesome! Those paths match up exactly! 🎉

Let's find our `sound.properties` file and make the same modifications:

```console
$ find /usr/lib/jvm -name sound.properties
/usr/lib/jvm/zulu11-ca/conf/sound.properties
```

Open `/usr/lib/jvm/zulu11-ca/conf/sound.properties` in your favorite editor and add on
Keith's four lines at the end:

```
# /usr/lib/jvm/zulu11-ca/conf/sound.properties
javax.sound.sampled.Clip=com.sun.media.sound.DirectAudioDeviceProvider
javax.sound.sampled.Port=com.sun.media.sound.PortMixerProvider
javax.sound.sampled.SourceDataLine=com.sun.media.sound.DirectAudioDeviceProvider
javax.sound.sampled.TargetDataLine=com.sun.media.sound.DirectAudioDeviceProvider
```

[ran into sound problems in Ubuntu]: https://keithp.com/blogs/Java-Sound-on-Linux/

## Installing ThinkOrSwim

Head over to [ThinkOrSwim's download page] to download the installer. It's a big
installer bundled up inside a shell script (ugly, I know). Run the script with
`/bin/bash thinkorswim_installer.sh` and follow the prompts. I choose to install it only
for my user so that it installs in my home directory.

I use i3wm and the installer doesn't put a desktop file in the right place for me.
Here's what I drop into `~/.local/share/applications/thinkorswim.desktop`:

```ini
# ~/.local/share/applications/thinkorswim.desktop
[Desktop Entry]
Name=ThinkOrSwim
Comment=ThinkOrSwim Desktop
Exec=/home/major/thinkorswim/thinkorswim
Type=Application
Categories=Finance
```

Of course, if you aren't running as the user `major` or if you installed ThinkOrSwim in
a different location, be sure to change the `Exec=` line above. 😉

Start up ThinkOrSwim using your desktop launcher and enjoy trading on Linux! 🎉

[ThinkOrSwim's download page]: https://www.tdameritrade.com/tools-and-platforms/thinkorswim/desktop/download.html
