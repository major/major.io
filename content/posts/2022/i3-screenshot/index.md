---
author: Major Hayden
date: '2022-11-29'
summary: Take quick screenshots and send them to the clipboard in i3 with maim. 📸 
tags:
  - clipboard
  - i3
  - maim
  - screenshot
title: Make screenshots quickly in i3 with maim and xclip 
---

My daily workflow includes taking tons of screenshots.
I'm constantly relaying views of different data or results of various work between different chat systems and emails.
As with all things that I do often, I look for ways to optimize them as much as possible.

_(I'm that guy who wrote a post on an [efficient emoji workflow in Wayland](/p/efficient-emoji-experience-wayland/).)_ 😂

# Goals

Screenshots must be easy to take and share, period.
Modern versions of Firefox make this extremely easy with the built-in screenshot mechanism.

Right click an element on a web page, choose **Take Screenshot** from the pop-up and screenshot a whole page or just a single DOM element.
From there, you can copy it directly to the clipboard and paste it elsewhere or save it to a file.

I want something as close to that for the i3 desktop environment.

# The maim game

Fortunately, there's a piece of software called [maim](https://github.com/naelstrof/maim)![^maimname]
The README in the repository contains lots of helpful examples for basic screenshots all the way up to fancy conversions with drop shadows. ✨

My use case is quite simple.
I want to press a key, get a selection crosshair, make my selection, and get my screenshot copied to the clipboard.

Here's how I do it in i3:

```text
bindsym Print exec maim -s -u | xclip -selection clipboard -t image/png -i
```

Let's break this down:

* First, we use `bindsym` to bind the Print Screen (`Print`) key
* Hitting Print Screen runs `maim` and pops a selection crosshair (`-s`) and hides the cursor (`u`)
* Once the selection is made, the image pipes straight into `xclip`
* `xclip` stores the image in the clipboard with the `image/png` mime type

I'm able to go to my favorite application or browser window with Slack, Discord, or Mastodon open and simply paste the image into my message. 🏁

[^maimname]: Before you get upset with the name, keep in mind that it's the shortened version of **make image**. 😉
