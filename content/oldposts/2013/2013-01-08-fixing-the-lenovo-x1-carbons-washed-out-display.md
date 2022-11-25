---
title: Fixing the Lenovo X1 Carbon’s washed out display
author: Major Hayden
date: 2013-01-08T16:30:54+00:00
url: /2013/01/08/fixing-the-lenovo-x1-carbons-washed-out-display/
dsq_thread_id:
  - 3642807124
tags:
  - display
  - fedora
  - lenovo
  - linux
  - mint
  - thinkpad

---
Although the X1 Carbon has a [much better looking display than the T430s][1], it still looked a bit washed out when I compared it to other monitors right next to it. The entire display had a weak blue tint and it was difficult to use for extended periods, especially at maximum brightness.

A quick Google search took me to a [LaunchPad entry][2] about a [better ICC profile for the X1 Carbon][3]. After applying the ICC file via GNOME Control Center's Color panel, the display looks fantastic.

Feel free to download a copy of the color profile and try it for yourself:

  * [Original Link][4]

 [1]: /2012/10/21/lenovo-thinkpad-t430s-review/
 [2]: https://answers.launchpad.net/ubuntu-certification/+question/177299
 [3]: http://www.notebookcheck.net/Review-Lenovo-ThinkPad-X1-Subnotebook.55370.0.html
 [4]: http://www.notebookcheck.net/uploads/tx_nbc2/Lenovo_ThinkPad_X1_1366x768_glare_LP133WH2-TLM5.icc
