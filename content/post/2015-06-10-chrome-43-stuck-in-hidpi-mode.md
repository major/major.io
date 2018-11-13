---
title: Chrome 43 stuck in HiDPI mode
author: Major Hayden
type: post
date: 2015-06-10T12:36:03+00:00
url: /2015/06/10/chrome-43-stuck-in-hidpi-mode/
featured_image: /wp-content/uploads/2015/06/Google_Chrome_icon_2011.png
dsq_thread_id:
  - 3837065488
categories:
  - Blog Posts
tags:
  - chrome
  - fedora
  - gnome

---
[<img src="/wp-content/uploads/2015/06/Google_Chrome_icon_2011-300x300.png" alt="Google Chrome icon" width="300" height="300" class="alignright size-medium wp-image-5642" srcset="/wp-content/uploads/2015/06/Google_Chrome_icon_2011-300x300.png 300w, /wp-content/uploads/2015/06/Google_Chrome_icon_2011-150x150.png 150w, /wp-content/uploads/2015/06/Google_Chrome_icon_2011.png 512w" sizes="(max-width: 300px) 100vw, 300px" />][1]I ran some package updates last night and ended up with a new version of Google Chrome from the stable branch. After restarting Chrome, everything in the interface was **huge**. The icons in the bookmark bar, the text, the padding - all of it looked enormous.

After a little searching, I found a [helpful line][2] in the ArchLinux HiDPI documentation:

> Full HiDPI support in Chrome is now available in the main branch google-chromeAUR as of version 43.0.2357.2-1 and works out of the box as tested with Gnome and Cinnamon.

It looks like there was a [flag available][3] for quite some time to test the feature but it disappeared sometime in March. I scoured my list of flags as well as my Chrome configuration directories and couldn't find any trace of it.

### Temporary Workaround

While I search for a fix, my current workaround is to manually edit the `.desktop` file that comes with the Chrome RPM. On my Fedora system, that file is `/usr/share/applications/google-chrome.desktop`. If you open that file, look for a line that starts with `Exec`:

```
Exec=/usr/bin/google-chrome-stable %U
```


Change that line so that it includes `--force-device-scale-factor=1` to disable HiDPI support:

```
Exec=/usr/bin/google-chrome-stable --force-device-scale-factor=1 %U
```


Depending on your display manager, you might need to do something to refresh the `.desktop` files. If you're using GNOME 3, just press Alt-F2, type `r`, and press enter. Your screen will flicker a lot and GNOME will restart in place. Try starting Chrome once more and you should be back to normal.

### Still having problems?

If you don't see a change after doing all of that, ensure that you _fully_ exited Chrome. Depending on your configuration, Chrome might still be running in your taskbar even if you close all of the browser windows. If that's the case, completely exit Chrome using the taskbar menu or `pkill -f google-chrome`. Start Chrome again and you should be all set.

 [1]: /wp-content/uploads/2015/06/Google_Chrome_icon_2011.png
 [2]: https://wiki.archlinux.org/index.php/HiDPI#Chromium_.2F_Google_Chrome
 [3]: https://plus.google.com/+CraigTumblison/posts/NtW36w6yxiq
