---
author: Major Hayden
date: '2022-12-04'
summary: Have family or coworkers in multiple time zones? Get multiple clocks with i3status. ⌚ 
tags:
  - 100DaysToOffload
  - i3
  - i3status
  - timezones
title: Clocks in multiple time zones with i3status 
---

Many of my coworkers are on Central European Time (CET) and they're seven hours ahead of me _(most of the time)_.
Then there are those weird times of year where they move their clocks for Daylight Savings Time before we do in the USA.

I have a handy clock in my [i3status](https://i3wm.org/i3status/) bar, but I'd like to track my coworkers' timezones in addition to my own.

## Configuration

By default, i3status looks for its configuration file in `~/.config/i3status/config`.
Open up the configuration file in your favorite editor and add two pieces.

I'm most interested in CET, so I'll use Berlin for my extra clock.
First, add two `tztime` lines near the top:

```text
order += "tztime berlin"
order += "tztime local"
```

Then add the corresponding sections at the end of the configuration file:

```text
tztime local {
        format = "%Y-%m-%d %H:%M:%S 🇺🇸"
}

tztime berlin {
        format = "%H:%M 🇩🇪"
        timezone = "Europe/Berlin"
        hide_if_equals_localtime = true
}
```

The `hide_if_equals_localtime` configuration ensures that I only see one clock if my local timezone switches to CET.
Emoji flags add a little bit of flair to the clocks in the status bar. 😉

## Apply the change

Reload the i3 configuration with `Mod+Shift+c` and restart i3 with `Mod+Shift+r`.

----
_This is post 4 of 100 in the [#100DaysToOffload](/p/100-days-to-offload/) challenge._
