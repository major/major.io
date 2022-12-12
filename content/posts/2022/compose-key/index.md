---
author: Major Hayden
date: '2022-12-12'
summary: Keep your composure with diacritics, symbols, and other characters with the compose key! ⌨ 
tags:
  - i3
  - keyboard
title: Make your mark with the compose key 
---

Much of my work is driven by my keyboard, and I love finding new ways to do complicated actions in a hurry.
That's why I'm drawn towards tiling window managers like [i3](https://i3wm.org/) and [sway](https://swaywm.org/).

My team at work spans the globe and speaks many different languages.
Many of these languages have diacritics (such as accents, tildes, or other marks) that completely change the pronunciation (or even the meaning!)_ of the word.
Sure, I can type Tomas (TOM-oss) quickly, but it's not the same as Tomaš (TOM-osh).

Using diacritics shows respect for someone's name, their language and their culture.
In some situations, it can be the difference between something totally normal and potentially offensive[^potatoes-and-anuses].

# The old way

I wrote about this [way back in 2020](/2020/02/13/make-diacritics-easy-in-linux/) but my main method for getting this done was using the [AltGr key](https://en.wikipedia.org/wiki/AltGr_key).

If you want to type niños (children) in Spanish, you do this:

* Hold down the right Alt key
* Hold down the Shift key
* Press the ~ key
* Press n
* Let go of everything and admire your ñ 😍

This felt so slick and I was off to the races typing all kinds of accents and other marks.
I wrote the blog post, tweeted about it, and waited for others to reply with the same excitement.

The first reply from a European was:

> Nice work, but what's wrong with the compose key?

What's a compose key? 🤔

# Compose key

I stared at my keyboard.
**Where is this mysterious key?**
I've never seen it before!

Wikipedia [held the answer](https://en.wikipedia.org/wiki/Compose_key):

> Because Microsoft Windows and macOS do not support a compose key by default, the key does not exist on most keyboards designed for modern PC hardware.
> When software supports compose key behaviour, some other key is used.
> Common examples are the right-hand Windows key, the AltGr key, or one of the Ctrl keys.
> There is no LED or other indicator that a compose sequence is ongoing. 

I get to choose the key that becomes the compose key!
After asking a few Europeans about what they use on a US keyboard layout, they suggested the right CTRL key.

My previous blog post had an i3 configuration line like this:

```console
exec_always --no-startup-id "setxkbmap us -variant altgr-intl"
```

I figured there would need to be some kind of argument to pass to set the compose key.
The man page for `setxkbmap` says that all of the keyboard sources are in `/usr/share/X11/xkb/rules`:

```console
> $ grep compose /usr/share/X11/xkb/rules/base.xml
          <name>mod_led:compose</name>
          <name>compose:ralt</name>
          <name>compose:lwin</name>
          <name>compose:lwin-altgr</name>
          <name>compose:rwin</name>
          <name>compose:rwin-altgr</name>
          <name>compose:menu</name>
          <name>compose:menu-altgr</name>
          <name>compose:lctrl</name>
          <name>compose:lctrl-altgr</name>
          <name>compose:rctrl</name>
          <name>compose:rctrl-altgr</name>
          <name>compose:caps</name>
          <name>compose:caps-altgr</name>
          <name>compose:102</name>
          <name>compose:102-altgr</name>
          <name>compose:paus</name>
          <name>compose:prsc</name>
          <name>compose:sclk</name>
```

Opening that file shows the specific `rctrl` option:

```xml
<configItem>
  <name>Compose key</name>
  <description>Position of Compose key</description>
</configItem>
<!--- SNIP --->
<option>
  <configItem>
    <name>compose:rctrl</name>
    <description>Right Ctrl</description>
  </configItem>
</option>
```

My new i3 line looks like this:

```console
exec_always --no-startup-id "setxkbmap us -variant altgr-intl -option compose:rctrl"
```

Now I get the best of both worlds:

1. I can still use the Alt+Gr key for muscle memory.
2. The compose key gives me access to more characters with less keypresses!

There's a [long list](https://fsymbols.com/keyboard/linux/compose/) of symbols you can type with your compose key!

[^potatoes-and-anuses]: Just check out [años versus anos](https://www.spanishdict.com/compare/ano/a%C3%B1o) in Español. 😉 🥔
