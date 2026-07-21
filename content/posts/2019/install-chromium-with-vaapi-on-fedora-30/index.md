---
aliases:
- /2019/10/20/install-chromium-with-vaapi-on-fedora-30/
author: Major Hayden
date: '2019-10-20'
summary: Lower your CPU usage and increase battery life when you watch certain videos
  by using Chromium with VAAPI support.
tags:
- chromium
- fedora
- linux
title: Install Chromium with VAAPI on Fedora 30
---

***UPDATE:*** *The `chromium-vaapi` package is now `chromium-freeworld`.
This post was updated on 2019-11-06 to include the change. See the end of the
post for the update steps.*

If you use a web browser to watch videos on a laptop, you've probably noticed
that some videos play without much impact on the battery. Other videos cause
the fans to spin wildly and your battery life plummets.

Intel designed a specification called [VA API], often called *VAAPI* (without
the space), and it offers up device drivers to applications running on your
system. It provides a pathway for those applications to access certain parts of
the graphics processing hardware directly. This increases performance, lowers
CPU usage, and increases battery life.

In this post, you will learn how to get VAAPI working on your Fedora 30 system
and how to use it along with a Chromium build that has VAAPI patches already
included. There are some DRM-related workarounds as well toward the end.

*Note: Keep in mind that some videos are in formats that are difficult to
accelerate with a GPU and some applications support acceleration with some
formats but not others. You may find that your favorite site still uses the
same amount of CPU as it did before you completed this guide.* 😢

## Getting started with VAAPI

You will need a few packages before you get started, and some of these depend
on the type of GPU that is present in your system. In my case, I'm on a 4th
generation Lenovo X1 Carbon, and it has an Skylake GPU:

```text
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation Skylake GT2 [HD Graphics 520] (rev 07)
```

Fedora 30 has quite a few VAAPI packages available:

```text
$ sudo dnf list all | grep libva | awk '{print $1}'
libva.x86_64
libva-intel-driver.x86_64
libva-intel-hybrid-driver.x86_64
libva-utils.x86_64
libva-vdpau-driver.x86_64
libva.i686
libva-devel.i686
libva-devel.x86_64
libva-intel-driver.i686
libva-intel-hybrid-driver.i686
libva-vdpau-driver.i686
```

My Intel GPU requires these packages:

```text
$ sudo dnf install libva libva-intel-driver \
    libva-vdpau-driver \
    libva-utils
```

At this point, you should be able to run `vainfo` to ensure that everything is
working:

```text
$ vainfo
libva info: VA-API version 1.4.1
libva info: va_getDriverName() returns 0
libva info: Trying to open /usr/lib64/dri/i965_drv_video.so
libva info: Found init function __vaDriverInit_1_4
libva info: va_openDriver() returns 0
vainfo: VA-API version: 1.4 (libva 2.4.1)
vainfo: Driver version: Intel i965 driver for Intel(R) Skylake - 2.3.0
vainfo: Supported profile and entrypoints
      VAProfileMPEG2Simple            :	VAEntrypointVLD
      VAProfileMPEG2Simple            :	VAEntrypointEncSlice
      VAProfileMPEG2Main              :	VAEntrypointVLD
      VAProfileMPEG2Main              :	VAEntrypointEncSlice
      VAProfileH264ConstrainedBaseline:	VAEntrypointVLD
      VAProfileH264ConstrainedBaseline:	VAEntrypointEncSlice
      VAProfileH264ConstrainedBaseline:	VAEntrypointEncSliceLP
      VAProfileH264ConstrainedBaseline:	VAEntrypointFEI
      VAProfileH264ConstrainedBaseline:	VAEntrypointStats
      VAProfileH264Main               :	VAEntrypointVLD
      VAProfileH264Main               :	VAEntrypointEncSlice
      VAProfileH264Main               :	VAEntrypointEncSliceLP
      VAProfileH264Main               :	VAEntrypointFEI
      VAProfileH264Main               :	VAEntrypointStats
      VAProfileH264High               :	VAEntrypointVLD
      VAProfileH264High               :	VAEntrypointEncSlice
      VAProfileH264High               :	VAEntrypointEncSliceLP
      VAProfileH264High               :	VAEntrypointFEI
      VAProfileH264High               :	VAEntrypointStats
      VAProfileH264MultiviewHigh      :	VAEntrypointVLD
      VAProfileH264MultiviewHigh      :	VAEntrypointEncSlice
      VAProfileH264StereoHigh         :	VAEntrypointVLD
      VAProfileH264StereoHigh         :	VAEntrypointEncSlice
      VAProfileVC1Simple              :	VAEntrypointVLD
      VAProfileVC1Main                :	VAEntrypointVLD
      VAProfileVC1Advanced            :	VAEntrypointVLD
      VAProfileNone                   :	VAEntrypointVideoProc
      VAProfileJPEGBaseline           :	VAEntrypointVLD
      VAProfileJPEGBaseline           :	VAEntrypointEncPicture
      VAProfileVP8Version0_3          :	VAEntrypointVLD
      VAProfileVP8Version0_3          :	VAEntrypointEncSlice
      VAProfileHEVCMain               :	VAEntrypointVLD
      VAProfileHEVCMain               :	VAEntrypointEncSlice
      VAProfileVP9Profile0            :	VAEntrypointVLD

```

If you run into a problem like this one, try installing the
`libva-intel-hybrid-driver`:

```text
$ vainfo
libva info: VA-API version 1.4.1
libva info: va_getDriverName() returns 0
libva info: Trying to open /usr/lib64/dri/i965_drv_video.so
libva info: va_openDriver() returns -1
vaInitialize failed with error code -1 (unknown libva error),exit
```

## Installing Chromium with VAAPI support

Now that we have a pathway for applications to talk to our GPU, we can install
Chromium with VAAPI support:

```text
$ sudo dnf -y install chromium-freeworld
```

Run `chromium-freeworld` to ensure Chromium starts properly. Visit
[chrome://flags] in the Chromium browser and search for
`ignore-gpu-blacklist`. Choose **Enabled** in the dropdown and press **Relaunch
Now** in the bottom right corner.

After the relaunch, check some common video sites, like [YouTube] or
[DailyMotion]. The CPU usage may be a bit lower on these, but you can lower it
further by installing the [h264ify] extension. It forces some sites to provide
h264 video rather than other CPU hungry formats.

## Dealing with DRM

The only remaining problem is DRM. Some sites, like Netflix or YouTube TV,
require that the browser can handle DRM content. The `Widevine` DRM module is
required for some of these sites, but it is automatically bundled with Chrome.
The regular Chrome (not Chromium) package contains the module at:
`/opt/google/chrome/libwidevinecdm.so`.

First, ensure Chromium is not running. Then copy that module over to Chromium's
directory:

```text
sudo cp /opt/google/chrome/libwidevinecdm.so /usr/lib64/chromium-freeworld/
```

Start `chromium-freeworld` one more time and try out some DRM-protected sites like
Netflix and they should be working properly.

As I mentioned at the start of the guide, some applications support
acceleration with certain video formats and not others, so your results may
vary.

----

## New package: `chromium-freeworld`

When this post was first written, the chromium package was called
`chromium-vaapi`. It now `chromium-freeworld`. The upgrade is seamless since
the new package obsoletes the old one, but you need one extra step to bring
over the DRM module to the new chromium library directory:

```text
sudo cp /usr/lib64/chromium-vaapi/libwidevinecdm.so /usr/lib64/chromium-freeworld
```

Restart `chromium-freeworld` and you're good to go again.

[VA API]: https://en.wikipedia.org/wiki/Video_Acceleration_API
[chrome://flags]: chrome://flags
[YouTube]: https://youtube.com/
[DailyMotion]: http://dailymotion.com
[h264ify]: https://github.com/erkserkserks/h264ify
[Widefine]: https://www.widevine.com/
