---
author: Major Hayden
date: '2020-02-13'
summary: Making an effort to use diacritics is always a good idea, but how can
  you make it easier in Linux?
images:
- images/2020-02-13-diacritics-on-license-plate.jpg
slug: make-diacritics-easy-in-linux
tags:
- fedora
- language
- linux
title: Make diacritics easy in Linux
---

{{< figure src="/images/2020-02-13-diacritics-on-license-plate.jpg" alt="Brno skyline" position="center" >}}

[Diacritics] are all of the small things that are added on, above, or below
certain characters in various languages. Some examples include tildes (ñ),
accents (á), or other marks (š). These marks are little hints that help you
know how to pronounce a word properly (and they sometimes change the
definition of a word entirely).

They are often skipped by non-native language speakers, and sometimes even by
native speakers, but I have done my best to make a habit of including them
when I can.

Pronounciation can change drastically with a certain mark. For example, a
common Czech name is Tomaš. The š on the end makes a *sh* sound insead of a
the normal *sss* sound.

In Spanish, the word for Spain is España. The ñ has a *n* sound followed by a
*yah* sound. If you leave off the ñ, you end up with a sound like *ana* on the
end instead of *an-yah*.

Leaving out diacritics can also lead to terrible results, such as a famous
Spanish mistake:

* Mi papá tiene cincuenta años *(My Dad is fifty years old)*
* Mi papa tiene cincuenta anos *(My potato has fifty anuses)*

This could **obviously** lead to some confusion. 🤭

## First attempts (failures)

At first, I found myself going to [online character maps] and I would
copy/paste the character I wanted. Typing in Spanish quickly became painful
with the constant back and forth to copy certain characters.

I knew there had to be a better way.

## AltGr

After some research, I found that there are some keyboards with a special Alt
key on the right side of the space bar called the [AltGr] key. It's a special
modifier key that lets you type characters that are not easy with your
keyboard layout.

Luckily, you can tell your computer to pretend like you have an AltGr key to
the right of the keyboard and you get access to all of the international
characters via key combinations.

For Linux, you can run this in any terminal:

```text
setxkbmap us -variant altgr-intl
```

I add this command in my `~/.config/i3/config` for i3:

```text
exec_always --no-startup-id "setxkbmap us -variant altgr-intl"
```

Most window managers give you the option to change the keyboard layout for
your session in the window manager settings.

In GNOME, open *Settings*, click *Region & Language*, and click the plus (+)
below the list of layouts. Choose *English* and then choose *English (US, alt.
intl.)* from the list. You can switch from layout to layout in GNOME, but
AltGr works well for me as a default.

## Trying it out

Once you have AltGr enabled, here are some quick things to try:

* AltGr + Shift + ~, release keys, press n: `ñ`
* AltGr + ', release keys, press a: `á`
* AltGr + Shift + ., release keys, press s: `š`
* AltGr + s: `ß`

Take a look at [AltGr] on Wikipedia for lots more combinations.

[Diacritics]: https://en.wikipedia.org/wiki/Diacritic
[online character maps]: https://www.online-toolz.com/tools/character-map.php
[AltGr]: https://en.wikipedia.org/wiki/AltGr_key

*Photo credit: naleag_deco on [Flickr](https://www.flickr.com/photos/53088812@N00/1304824528/)*
