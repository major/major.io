---
author: Major Hayden
date: '2022-12-05'
summary: Setting up the multimedia keys on Ducky One keyboards lets you manage your music quickly. ⌨ 
tags:
  - i3
  - keyboard
  - multimedia
  - sway
title: Configure multimedia keys on a Ducky One keyboard 
---

My Ducky One 2 keyboard arrived around two years ago and I love it.
I type more accurately and that clackety sound gives me that old computer feeling.
_(I went with Cherry MX Blue switches.)_

Although it proviees some basic controls for media, such as muting and adjusting volume, there are no buttons for pausing music or switching to different tracks.
That function exists, but it takes some configuration to work.

## Handling media keys

For those of you running a large desktop environment like GNOME or KDE, you likely have built-in multimedia key handling in the environment.
However, I use sway and i3 and there's no native handling there.

There's a great utility called [playerctl](https://github.com/altdesktop/playerctl) that makes this really easy.
If you're on Fedora, run `dnf install playerctl` to get started.

Next, you'll need some hotkeys in i3/sway:

```text
bindsym XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous
```

Press `Mod+Shift+c` to reload your Sway/i3 configuration.

These are the standard multimedia keys that many keyboards have, but my Ducky keyboard doesn't have them.
The keyboard does have the ability to send these keystrokes through, but we need to set up a macro for them!
_Skip to the next section for that._

But before we go, playerctl handles all kinds of different multimedia players on your system:

```console
$ playerctl -l
firefox.instance4056
spotify
```

I tend to use my media keys for Spotify most often, so I updated my Sway/i3 configuration to this:

```console
bindsym XF86AudioPlay exec playerctl -p spotify play-pause
bindsym XF86AudioNext exec playerctl -p spotify next
bindsym XF86AudioPrev exec playerctl -p spotify previous
```

This ensures that my media keys won't interfere with something in Firefox and will always control my Spotify media. 😉

🚨 **Before going any further, check that `playerctl` works!** 🚨

Run `playerctl -p spotify play-pause` one time and your music should play if it wasn't playing before, or it should pause if it was already playing.
Run it one more time to ensure it does the opposite the second time.
Use a different player or remove the `-p` argument entirely to test it with other players.

## RTEM (Read the excellent manual)

The Ducky One 2 has a [helpful manual](https://duckychannel.net/download/user_manual/2020/Ducky_One_One2_10in1_usermanual_ol.pdf) in English and Chinese.
We need a macro to get the multimedia keys working and that process isn't easy to follow as it spans multiple pages.

📚 _If you need a manual for a different Ducky keyboard, their [support page](https://www.duckychannel.com.tw/en/Support) has a wizard that helps you find the exact manual for your keyboard._

The good stuff starts at page 41 in my manual:

{{< figure src="manual-page-41.png" alt="Manual page explaining how to switch between profiles" default=true >}}

First, determine which profile you want to use.
In my case, I chose profile 2.

Next, we need to know which multimedia function keys are hidden away in the keyboard's firmware:

{{< figure src="manual-page-43.png" alt="Manual page covering multimedia keys" default=true >}}

For each key combination, we need to know which keys we want to press to trigger the multimedia key (letters above).
I'm most interested in play/pause, previous track, and next track, so I'm building out my configuration like this:

* Play/Pause: `Fn+End` (key `D`)
* Previous track: `Fn+PgUp` (key `G`)
* Next track: `Fn+PgDown` (key `F`)

## Making macros

Now we're ready to record a macro.

Switch to profile 2 with `Fn+2`.
The LED underneath the *2* should blink briefly.

Enter macro mode by holding down `Fn` and `Ctrl` for three seconds (press `Fn` first, though).
The keyboard indicators at the top right of the keyboard should be blinking slowly.

Carefully set the macro:

1. Hold down `Fn` and `Ctrl` for three seconds. Indicator lights should blink slowly.
2. Hold `Fn` and press `End`.
3. Hold `Fn`, then hold the Windows key, then press `D` (for play/pause). Release all keys after pressing `D`.
4. Exit macro recording mode by holding `Fn` and pressing `Ctrl`. Release all keys.

Repeat for previous track:

1. Hold down `Fn` and `Ctrl` for three seconds. Indicator lights should blink slowly.
2. Hold `Fn` and press `PgUp`.
2. Hold `Fn`, then hold the Windows key, then press `G` (for previous track). Release all keys after pressing `D`.
3. Exit macro recording mode by holding `Fn` and pressing `Ctrl`. Release all keys.

Finally for next track:

1. Hold down `Fn` and `Ctrl` for three seconds. Indicator lights should blink slowly.
2. Hold `Fn` and press `PgDn`.
2. Hold `Fn`, then hold the Windows key, then press `F` (for next track). Release all keys after pressing `D`.
3. Exit macro recording mode by holding `Fn` and pressing `Ctrl`. Release all keys.

## Testing

You did test `playerctl` by itself earlier, right? 😜
If you didn't, go back to the first section and save yourself some frustration.

Press `Fn+End` and your music should toggle between playing and paused.
Press `Fn+End` once more and it should toggle again.

If `playerctl` works on the command line, but doesn't work via the keyboard macro, you can go back through the macro setting steps above.
You can also clear a macro from a key by holding `Fn+Ctrl` for three seconds, tapping the misconfigured key, tapping the same key again, and pressing `Fn+Ctrl`.

Enjoy your quick access to multimedia keys! ⌨ 🎶

----
_This is post 5 of 100 in the [#100DaysToOffload](/p/100-days-to-offload/) challenge._
