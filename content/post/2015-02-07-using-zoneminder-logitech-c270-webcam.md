---
title: Using ZoneMinder with a Logitech C270 webcam
author: Major Hayden
type: post
date: 2015-02-08T04:04:08+00:00
url: /2015/02/07/using-zoneminder-logitech-c270-webcam/
dsq_thread_id:
  - 3644031901
categories:
  - Blog Posts
tags:
  - command line
  - linux
  - video
  - web

---
For those of you in the market for a cheap webcam for videoconferencing or home surveillance, the [Logitech C270][1] is hard to beat at about $20-25 USD. It can record video at 1280&#215;960 and it's fairly good at low light levels. The white balance gets a bit off when it's bright in the room but hey &#8212; this camera is cheap.

[ZoneMinder][2] can monitor multiple cameras connected via USB or network. Setting up the C270 with ZoneMinder is relatively straightforward. (Getting ZoneMinder installed and running is well outside the scope of this post.)

## Adjust groups

If a user wants to access the webcam in Linux, they must be in the video group. On my system, ZoneMinder runs as the apache user. I needed to add the apache user to the video group:

```
usermod -G video apache
```

## Configuring the C270

After clicking **Add New Monitor**, here's the data for each tab:

General Tab:

* Source Type: Local
* Function: Modect

Source:

* Device Path: /dev/video0
* Capture Method: Video For Linux version2
* Device Format: PAL
* Capture Palette: YUYV
* Capture Width: 1280
* Capture Height: 960

The width and height settings are suggestions. You can crank them down to something like 640&#215;480 if you'd like to save disk space or get a higher frame rate.

Once you save the configuration and the window disappears, you should see **/dev/video0 (0)** turn green in the ZoneMinder web interface. If it's red, there may be a different permissions issue to solve or your ZoneMinder instance might be running as a different user than you expected. If the text is yellow/orange, go back and check your camera configuration settings in the ZoneMinder interface.

 [1]: http://www.logitech.com/en-us/product/hd-webcam-c270
 [2]: http://www.zoneminder.com/
