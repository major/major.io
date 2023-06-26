---
aliases:
- /2017/01/11/icc-color-profile-lenovo-thinkpad-x1-carbon-4th-generation/
author: Major Hayden
date: 2017-01-11 18:42:26
tags:
- fedora
- gnome
- hardware
- linux
- thinkpad
title: ICC color profile for Lenovo ThinkPad X1 Carbon 4th generation
---

My new ThinkPad arrived this week and it is working well! The Fedora 25 installation was easy and all of the hardware was recognized immediately.

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    Hooray! <a href="https://t.co/OiPSHREMLo">pic.twitter.com/OiPSHREMLo</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/818490272036298753">January 9, 2017</a>
  </p>
</blockquote>



However, there was a downside. The display looked washed out and had a strange tint. It seemed to be more pale than the previous ThinkPad. The default [ICC profile][1] in GNOME didn't help much.

There's a [helpful review over at NotebookCheck][2] that has a link to an [ICC profile generated][3] from a 4th generation ThinkPad X1 Carbon. This profile was marginally better than GNOME's default, but it still looked a bit more washed out than what it should be.

I picked up a [ColorMunki Display][4] and went through a fast calibration in [GNOME's Color Manager][5]. The low quality run finished in under 10 minutes and the improvement was definitely noticeable. Colors look much deeper and less washed out. The display looks _very_ similar to the previous generation ThinkPad X1 Carbon.

 [1]: https://en.wikipedia.org/wiki/ICC_profile
 [2]: http://www.notebookcheck.net/Lenovo-ThinkPad-X1-Carbon-2016-Core-i7-WQHD-Ultrabook-Review.162631.0.html
 [3]: http://www.notebookcheck.net/uploads/tx_nbc2/X1_Carbon_WQHD_VVX14T058J00.icm
 [4]: http://www.xrite.com/categories/calibration-profiling/colormunki-display
 [5]: https://help.gnome.org/users/gnome-help/3.14/color.html.en