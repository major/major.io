---
author: Major Hayden
date: '2023-04-19'
summary: |
  1Password has a handy quick access launcher and you can bring it on screen for fast
  access to passwords and two factor codes in Sway. 🔐
tags:
  - 1password
  - fedora
  - security
  - sway
title: 1Password quick access in Sway
coverAlt: Reflective box in the grass
coverCaption: |
  [Parker Coffman](https://unsplash.com/photos/LuS0JpIGGbw)
---

[1Password](https://1password.com/downloads/linux/) remains a core part of my
authentication workflow for password, two factor authentication, and even ssh keys. It
uses Linux system authentication to authenticate access from various command line tools
and that's quite helpful for automation.

Sometimes I need a quick copy of a particular password or two factor code while I'm in
another application.  That's where 1Password's [quick
access](https://support.1password.com/quick-access/) menu comes in very handy.

It creates a pop-up in the middle of the screen that you can use immediately to search
your vault. Once you find what you need, you can press various hot keys to get the right
data into your clipboard.

Press the right arrow key once the right credential is highlighted and you'll get
instructions on which key combinations to press:

* `ctrl-c` copies the username
* `ctrl-shift-c` copies the password
* `ctrl-alt-c` copies the two factor authentication code

In most window managers, 1Password handles the keybinding for launching the quick access
menu, which is `ctrl-shift-space` by default. You can probably guess by the title of
this post that it doesn't work out of the box with Sway. 😉

# Integrating with Sway

Start by adding a keybinding for the quick access menu. I added mine in
`~/.config/sway/config.d/launcher.conf`:

```text
# Start 1Password Quick Access
bindsym Control+Shift+Space exec /usr/bin/1password --quick-access
```

Save the file and reload Sway's configuration with `mod+shift+c` _(mod is usually your
Windows key unless you changed it)_. Now press `ctrl-shift-space` and the quick access
menu should appear!