---
aliases:
- /2018/12/18/disable-autoplay-for-videos-in-firefox-65/
author: Major Hayden
date: '2018-12-18'
tags:
- firefox
- security
title: Disable autoplay for videos in Firefox 65
---

Firefox has some great features, but one of my favorites is the ability to
disable autoplay for videos. We've all had one of those moments: your
speakers are turned up and you browse to a website with an annoying
advertisement that plays immediately.

![2018-12-18-just-want-it-to-stop.gif](2018-12-18-just-want-it-to-stop.gif "I just want it to stop")

This feature stopped working for me somewhere in the Firefox 65 beta
releases. Also, the usual setting in the preference page (under *Privacy &
Security*) seems to be missing.

Luckily we can edit Firefox's configuration directly to get this feature
working again. Open up a new browser tab, go to `about:config`, and adjust
these settings:

* Set `media.autoplay.default` to `1` to disable video autoplay for all sites

* Set `media.autoplay.allow-muted` to `false` to disable video autoplay *even for muted videos*

Those changes take effect for any new pages that you open after making the change.