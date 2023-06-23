---
aliases:
- /2018/09/05/make-alt-arrow-keys-work-with-terminator-and-weechat/
author: Major Hayden
date: 2018-09-06 03:43:30
tags:
- irc
- linux
- terminator
- weechat
title: Make alt-arrow keys work with terminator and weechat
---

As I make the move from the world of GNOME to i3, I found myself digging deeper into the [terminator][2] preferences to make it work more like [gnome-terminal][3].

<!--more-->

I kept running into an issue where I couldn't move up and down between buffers using alt and arrow keys. My workaround was to call the buffer directly with alt-8 (for buffer #8) or alt-j 18 (buffer #18). However, that became tedious. Sometimes I just wanted to quickly hop up or down one or two buffers.

To fix this problem, right click anywhere inside the terminal and choose _Preferences_. Click on the _Keybindings_ tab and look for `go_up` and `go_down`. These are almost always set to _Alt-Up_ and _Alt-Down_ by default. That's the root of the problem: terminator is grabbing those keystrokes before they can make it down into weechat.

Unfortunately, it's not possible to clear a keybinding within the preferences dialog. Close the window and open `~/.config/terminator/config` in a terminal.

If you're new to terminator, you might not have a `[keybindings]` section in your configuration file. If that's the case, add the whole section below the `[global_config]` section. Otherwise, just ensure your `[keybindings]` section contains these lines:

```ini
[keybindings]
  go_down = None
  go_up = None
```

Close _all_ of the terminator windows (on all of your workspaces). **This is a critical step!** Terminator only loads the config file when it is first started, not when additional terminals are opened.

Open a terminator terminal, start weechat, and test your alt-arrow keys! You should be moving up and down between buffers easily. If that doesn't work, check your window manager's settings to ensure that another application hasn't stolen that keybinding from your terminals.

 [2]: https://terminator-gtk3.readthedocs.io/en/latest/
 [3]: https://help.gnome.org/users/gnome-terminal/stable/