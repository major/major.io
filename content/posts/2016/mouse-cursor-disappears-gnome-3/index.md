---
aliases:
- /2016/03/11/mouse-cursor-disappears-gnome-3/
author: Major Hayden
date: 2016-03-11 15:36:25
tags:
- desktop
- fedora
- gnome
- linux
title: Mouse cursor disappears in GNOME 3
---

![mouse_photo]

**UPDATE:** The fixed version of mutter is now in the Fedora updates repository. You should be able to update the package with `dnf`:

```
dnf -y upgrade mutter
```


* * *

GNOME 3 has been rock solid for the last few months but something cropped up this week that derailed me for a short while. Whenever I moved my mouse cursor to the top bar (where the clock and status icons reside), the mouse cursor disappeared. The same thing happened if I pressed the Mod/Windows key to hop into the Activities display.

If I wiggled the mouse a bit, I could see the highlight move around to different windows and icons. The mouse cursor never appeared.

Lots of Google results led to dead ends. I stumbled onto a [GNOME bug for gnome-shell][1] from early 2015 that seemed to cover the same problem. After adding in my comments, I created a [Fedora bug][2] to track the problem.

Around that time, Florian Müllner replied in the GNOME bug about trying `mutter-3.18.3-2`. My laptop was running `mutter-3.18.3-1` at the time. The [new version of mutter][3] was still in the _pending_ state in Fedora's packaging infrastructure, so I pulled it down with `koji`:

```
koji download-build --arch x86_64 mutter-3.18.3-2.fc23
sudo dnf install mutter-3.18.3-2.fc23.x86_64.rpm
```


After a reboot, everything was back to normal! The cursor appears reliably in the top bar, Activities screen, and other overlays. In addition, some of the transient cursor weirdness I had with some applications seems to be gone.

**UPDATE:** [Jiří Eischmann][4] tweeted yesterday about this problem:

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    <a href="https://twitter.com/majorhayden">@majorhayden</a> I was hit by that too. But it only occurs when 0:0's not visible, when left monitor is below the right, so not so many ppl impt
  </p>

  <p>
    &mdash; Jiří Eischmann (@Sesivany) <a href="https://twitter.com/Sesivany/status/708320143730933760">March 11, 2016</a>
  </p>
</blockquote>



In my particular case, my "left" monitor is my laptop screen and my "right" monitor is my external display. I configure the external monitor to be _above_ my laptop monitor physically and logically, which is why the problem appears for me. Thanks for the clarification, Jiří!

_Photo Credit: [Perfectance][5] via [Compfight][6] [cc][7]_

 [1]: https://bugzilla.gnome.org/show_bug.cgi?id=746594
 [2]: https://bugzilla.redhat.com/show_bug.cgi?id=1316957
 [3]: https://bodhi.fedoraproject.org/updates/FEDORA-2016-30ef48bcb6
 [4]: https://twitter.com/Sesivany
 [5]: https://www.flickr.com/photos/77395664@N00/7575830232/
 [6]: http://compfight.com
 [7]: https://creativecommons.org/licenses/by-nc-sa/2.0/
 [mouse_photo]: /wp-content/uploads/2016/03/7575830232_19678e9d5c_b-e1457710296562.jpg