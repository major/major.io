---
author: Major Hayden
date: '2022-12-09'
summary: Automatically switch your system audio to your bluetooth headset as soon as they connect. 🎧 
tags:
  - audio
  - bluetooth
  - fedora
  - linux
title: Switch audio to bluetooth headphones automatically 
---

Working remotely involves lots of meetings in challenging home conditions and I love noise-canceling bluetooth headphones for meetings and music.
It really helps me focus.
However, as anyone knows who works with multiple audio devices on the same machine, getting all of the inputs and outputs working properly for each application is tedious. 😅

The last thing I want to wrestle with (as a scramble to a meeting) is redirecting audio from my speakers to my headphones in PulseAudio. 😱

Luckily, there's a pulseaudio module for that!

# Goal

Here's what I want:

* Headphones turn on, connect via Bluetooth, and the default audio sink (output) should switch to the headphones
* The input (source) should not change (I have a separate microphone on the desk)
* When the headphones turn off and disconnect, the audio should shift back to the original default

# Enabling the module

This was working really well on my desktop, but I recently switched to [Fedora Silverblue](https://silverblue.fedoraproject.org/).
I forgot how I dealt with this before.

A quick search led to an [Arch Linux forum post](https://bbs.archlinux.org/viewtopic.php?id=271850).
The pulseaudio module [module-switch-on-connect](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-switch-on-connect) handles this automatically without extra configuration.

Start some music, disconnect the bluetooth headphones, and load the module:

```text
$ pactl load-module module-switch-on-connect
```

Power on your headphones and wait for the connection.
Audio should switch to your bluetooth headset automatically.
Power off the bluetooth headphones and audio should shift back to the original source (perhaps your computer speakers).

If that didn't work, you might need to tinker with your default audio sinks or add some udev rules to ensure your bluetooth headphones come up with the right sink.
The [Arch Linux pipewire docs](https://wiki.archlinux.org/title/PipeWire#Sound_does_not_automatically_switch_to_Bluetooth_headphones) provide a few options.

# Make it persistent

Loading the module with `pactl` only works until pulseaudio is restarted or the machine reboots.
You can make it persistent by adding it to your window manager's startup scripts.

I use i3/sway, so my configuration line looks like this:

```text
exec_always --no-startup-id pactl load-module module-switch-on-connect
```
