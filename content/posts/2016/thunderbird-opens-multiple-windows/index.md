---
aliases:
- /2016/04/20/thunderbird-opens-multiple-windows/
author: Major Hayden
date: 2016-04-20 13:31:56
tags:
- fedora
- mail
- thunderbird
title: Thunderbird opens multiple windows
---

When I started [Thunderbird][1] today, it opened three windows. Each window was identical. I closed two of them and then quit Thunderbird.

As soon as I started Thunderbird, I had **three windows again**.

[<img src="/wp-content/uploads/2016/04/ugh.gif" alt="Ugh thunderbird!" width="480" height="270" class="aligncenter size-full wp-image-6157" />][2]

I found a [Mozilla bug report from 2015][3] that had some tips for getting the additional windows closed.

Choose one of the open Thunderbird windows and select **Close** from the **File** menu. **Do not** use ALT-F4 or CTRL-W to close the window. Keep doing that until all of the windows are closed except for one. Then choose **Quit** from the hamburger menu drop down.

At that point, start Thunderbird again and you should have only one open window.

_Note: You may find that one window does not respond to clicking **Close** - that's your root Thunderbird window and it cannot be closed. Be sure to close all of the others._

 [1]: https://www.mozilla.org/en-US/thunderbird/
 [2]: /wp-content/uploads/2016/04/ugh.gif
 [3]: https://bugzilla.mozilla.org/show_bug.cgi?id=531588#c12