---
aktt_notify_twitter:
- false
aliases:
- /2010/03/03/sticky-shift-key-with-synergy-in-fedora-12/
author: Major Hayden
date: 2010-03-04 02:44:12
dsq_thread_id:
- 3642806043
tags:
- fedora
- gdm
- keyboard
- mac
- synergy
title: Sticky shift key with synergy in Fedora 12
---

My synergy setup at work is relatively simple. I have a MacBook Pro running Snow Leopard that acts as a synergy server and a desktop running Fedora 12 as a synergy client. On the Mac, I use SynergyKM to manage the synergy server. The Fedora box uses [my gdm strategy][1] for starting synergy at the login screen and in GNOME.

I kept having an issue where the shift key would become stuck regardless of the settings I set for the client or server. The  `halfDuplexCapsLock` [configuration option][2] had no effect. After installing `xkeycaps`, I found that both shift keys were getting stuck if I brought the mouse back and forth between Mac and Fedora twice.

I decided to run a test. I started the client with the debug argument and moved the mouse to my Fedora box. At that point, I pressed the letter 'a' and saw:

```
DEBUG1: CXWindowsKeyState.cpp,195:   032 (00000000) up
DEBUG1: CXWindowsKeyState.cpp,195:   03e (00000000) up
DEBUG1: CXWindowsKeyState.cpp,195:   026 (00000000) down
DEBUG1: CXWindowsKeyState.cpp,195:   032 (00000000) down
DEBUG1: CXWindowsKeyState.cpp,195:   03e (00000000) down
DEBUG1: CXWindowsKeyState.cpp,195:   026 (00000000) up
```


I brought the mouse back to the Mac and then back to Fedora. I pressed 'a' again and saw:

```
DEBUG1: CXWindowsKeyState.cpp,195:   026 (00000000) down
DEBUG1: CXWindowsKeyState.cpp,195:   026 (00000000) up
DEBUG1: CXWindowsKeyState.cpp,195:   026 (00000000) down
DEBUG1: CXWindowsKeyState.cpp,195:   026 (00000000) up
```


After dumping the keyboard layout with `xmodmap` I found the keys that corresponded with the key numbers:

  * 032 - Left shift
  * 03e - Right shift
  * 026 - a

If I tapped the left shift, I could clear the key press, but I couldn't clear the right shift key (it was stuck down according to Fedora's X server). When I hooked up a physical keyboard and mouse, I was able to use them normally without any keybinding problems.

<span style="font-weight: bold; color: #008000;">The root cause:</span> When synergy started in `/etc/gdm/PreSession/Default` after the gdm login, the keyboard layout wasn't set up properly. The X server was setting up the keyboard layout later in the startup process and this confusion caused the shift keys to get stuck. Fedora 12 uses evdev to probe for keyboards during X's startup and eventually settles on a default layout if none are explicitly defined.

<span style="font-weight: bold; color: #008000;">The fix:</span> I added the synergy startup to the GNOME startup items and it works flawlessly.

 [1]: http://rackerhacker.com/2008/07/30/automatically-starting-synergy-in-gdm-in-ubuntufedora/
 [2]: http://synergy2.sourceforge.net/configuration.html