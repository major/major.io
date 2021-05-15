---
title: Efficient emojis with rofimoji
author: Major Hayden
type: post
date: "2021-05-15"
slug: efficient-emojis-with-rofimoji
twitter:
  card: "summary_large_image"
  site: "@majorhayden"
  title: efficient-emojis-with-rofimoji
  description: >-
    Emojis brighten up any message or document. 🌻 Search, select, and use
    emojis quickly on Linux with rofimoji. 🤗
  image: images/2021-05-15-efficient-emojis-with-rofimoji.jpg
categories:
  - Blog Posts
tags:
  - emojis
  - fedora
  - linux
  - python
  - rpm
---

{{< figure src="/images/2021-05-15-efficient-emojis-with-rofimoji.jpg" alt="Soft emoji items hanging on a rack" position="center" >}}

Emojis brighten up any message or document. They also serve as excellent methods
for testing whether your application handles strings appropriately. _(This can
be a lot of fun.)_ 🤭

I constantly obsess with efficiency and shortening the time and effort required
to get my work done. I noticed that I could type short text emoticons like _:)_
and _;)_ so much faster than I could use emojis. This simply would not do. 😉

## First attempts

[Emoji Copy] was my first try at getting the emojis I needed quickly. The site
also offers a native emoji mode which allows you to see if your system is
handling emojis correctly. The site loads quickly and the search find emojis in
a flash, but it was annoying to open a browser tab just to find an emoji. 🤦🏻‍♂️

The GNOME Extension called [Emoji Selector] made the selection process faster,
but I moved from GNOME to i3 and lost my GNOME extensions. 🤷🏻‍♂️

Other methods, such as the [Emoji input method] and the [ibus-typing-booster],
also worked, but I knew there had to be something more efficient than those. 🤔

[Emoji Copy]: https://www.emojicopy.com/
[Emoji Selector]: https://extensions.gnome.org/extension/1162/emoji-selector/
[Emoji input method]: https://fedoramagazine.org/boost-typing-emoji-fedora-28-workstation/
[ibus-typing-booster]: https://mike-fabian.github.io/ibus-typing-booster/

## Enter rofimoji

The [rofi] launcher quickly become part of my core workflow in i3 (replacing
[dmenu]) and I was pleasantly surprised to find [rofimoji] in GitHub. 🤗

The rofimoji launcher follows in rofi's footsteps and gives you quick access to
emojis. Using rofimoji is easy:

1. Bind a key combination to run `rofimoji` _(I use Mod+E)_
2. Type in a search term to find the perfect emoji
3. Press enter to input it directly in the active window or shift+enter to copy
   it to the clipboard
4. 🎉

Depending on the application you're using, you might need to mess around with
roflmoji's `--action` parameter. Some applications will take the emoji directly
as if you typed it from a keyboard, but most of the ones I use seem to like a
copy/paste method via the clipboard. 📋

I use the `--action clipboard` parameter and it works well across browsers and
terminals. Here's the line from the i3 configuration file:

```text
bindsym $mod+e exec --no-startup-id rofimoji --skin-tone light --action clipboard --rofi-args='-theme solarized -font "hack 12" -width 800'
```

[rofi]: https://github.com/davatorium/rofi
[dmenu]: https://tools.suckless.org/dmenu/
[rofimoji]: https://github.com/fdw/rofimoji

## RPMs for Fedora, CentOS, and RHEL

At the moment, rofimoji is not packaged for Fedora, CentOS, or Red Hat
Enterprise Linux (RHEL). However, you can install it from my [COPR packages
repository]:

```text
sudo dnf copr enable mhayden/packages
sudo dnf install python3-rofimoji
```

Enjoy! 🍰

[COPR packages repository]: https://copr.fedorainfracloud.org/coprs/mhayden/packages/

*Photo credit: [Kelvin Yan on Unsplash](https://unsplash.com/photos/dGrfSEcwK74)*
