---
author: Major Hayden
date: '2024-01-09'
summary: |
  Dark mode lovers rejoice! It's possible to get (most) applications to show up
  in dark mode in the Sway window manager. 😎
tags: 
  - gnome
  - firefox
  - kde
  - linux
  - sway
title: Dark mode in Sway
coverAlt: Industrial area at night
coverCaption: |
  [mos design](https://unsplash.com/photos/a-dark-street-with-a-large-industrial-building-in-the-background-ZrY7oJFUP3Y)
  via Unsplash
---

Ah, dark mode!
I savor my dark terminals, window decorations, and desktop wallpapers.
It's so much easier on my eyes on those long work days. 😎

However, I think the author [Mary Oliver](https://en.wikipedia.org/wiki/Mary_Oliver) said it best:

> Someone I loved once gave me a box full of darkness.
> It took me years to understand that this too, was a gift.

In most window managers, such as GNOME or KDE, switching to dark mode involves a simple trip to the settings panels and clicking different themes.
Sway doesn't offer us those types of comforts, but we can get dark mode there, too!

![sunglasses-wiggle.gif](sunglasses-wiggle.gif)

# GTK applications

If you happen to have GNOME on your system alongside sway, go into **Settings**, then **Appearance** and select _Dark_.
You can also get dark mode by applying a setting in `~/.config/gtk-3.0/settings.ini`:

```ini
[Settings]
gtk-application-prefer-dark-theme=1
```

Restart whichever application you were using and it should pick up the new configuration.

Firefox, for example, ships with an automatic appearance setting that follows the OS.
That should be reflected immediately upon restart.
If not, go into Firefox's settings, and look for dark mode under the **Language and Appearance** section of the general settings.

# QT applications

Most of my applications are GTK-based, but I have one or two which use QT.
Again, just like the GTK example, if you have KDE installed along side Sway, you can configure dark mode there easily.
Just open the system settings and look for _Breeze Dark_ in the **Plasma Style** section.

You don't have KDE?
Don't worry!
There are a couple of commands which should work:

```shell
# This should work for all QT/KDE apps
# if you have the Breeze Dark theme installed.
lookandfeeltool -platform offscreen \
    --apply "org.kde.breezedark.desktop"

# You can set the theme for GTK apps here as well
# if you run into problems.
dbus-send --session --dest=org.kde.GtkConfig \
    --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme \
    "string:Breeze-dark-gtk"
```

# Alternate dark mode based on time

Many window managers offer a method for adjusting dark and light modes based on the time of day.
For example, some people love brighter interfaces during the day and darker ones at night.
There's a great tool called [darkman](https://gitlab.com/WhyNotHugo/darkman) that makes this easier. 🤓

The darkman service runs in the background and runs various commands to change dark mode settings for all kinds of window managers.
It also speaks to dbus directly to set the configurations if needed.

It also has a [directory full of user contributed scripts](https://gitlab.com/WhyNotHugo/darkman/-/tree/main/examples/dark-mode.d?ref_type=heads) to change dark and light modes for various environments.
You might be able to pull some commands from these files to test which configurations might work best on your system.

