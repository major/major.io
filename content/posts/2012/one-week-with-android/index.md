---
aliases:
- /2012/09/06/one-week-with-android/
author: Major Hayden
date: 2012-09-07 03:53:42
dsq_thread_id:
- 3642807056
tags:
- android
- apple
- linux
- networking
title: One week with Android
---

After getting Android-envy at [LinuxCon][1], I decided to push myself out of my comfort zone and ditch my iPhone 4 for a [Samsung Galaxy S III][2]. It surprised a lot of people I know since I've been a big iPhone fan since the original model was released in 2007. I've carried the original iPhone, the 3GS, and then the 4. There have been good times and bad times, but the devices have served me pretty well overall.

**The Good Stuff**

![3]

One of my coworkers summed up Android devices pretty succinctly: "This will be the first phone that feels like _your_ phone." That's what I like about it the most. I have so much more control over what my phone does and when it does it. It seems like there's a checkbox or option list for almost every possible setting on the phone. Everything feels customizable (to a reasonable point). Even trivial things like configuring home screens and adjusting Wi-Fi settings seem to be more user-friendly.

The raw performance of the S3 handset is impressive. All of the menus are responsive and I rarely find myself waiting on the phone to do something. 4G LTE is extremely fast (but it does chow down on your battery) and it's hard to tell when I'm on Wi-Fi and when I'm not. Photo adjustments are instantaneous and moving around in Chrome is snappy.

Another big benefit is that applications can harness the power of the Linux system under the hood (although some may require getting root access on your phone). Using rsync, ssh, FTP, and samba makes transferring data and managing the device much easier. It also allows you to set up automated backups to remote locations or to another SD card in your phone.

**The Not-So-Good Stuff**

If you've ever used a Mac along with Apple's music devices, you know that the integration is tight and well planned. Moving over to Android has been really rough for me and the ways that I manage music. I gave [DoubleTwist][4] and [AirSync][5] a try but then I found that all of my music was being transcoded on the fly from AAC to another format. Syncing music took forever, quality was reduced, and the DoubleTwist music player on the phone was difficult to use. I downloaded [SongBird][6] and then tried to use [Google Play Music][7] but both felt inefficient and confusing.

Eventually, I found [SSHDroid][8] and started transferring music via ssh. That worked out well but then I couldn't find any of the music I uploaded on my phone. A friend recommended [SDRescan][9] since it forces the device to scan itself for any new media files. My current work flow involves uploading the music via ssh, rescanning for media files, and then listening to the new files with Apollo (from [CyanogenMod][10], more on that later).

Battery life on the S3 is well below what I expected but it sounds like it might be more the shortfall of the device rather than the software. The screen is large and it's very bright even on the lowest settings. The battery settings panel on the phone regularly shows the screen as the largest consumer of energy on the phone. I did make some adjustments, like allowing Wi-Fi to switch off when the phone is asleep, which has helped with battery life. Disabling push email or IMAP IDLE has helped but it's prevented me from getting some of the functionality I want.

Finally, the pre-installed Samsung software was absolutely terrible. There were background processes running that were eating the battery and the interface was hard to use. I'm not sure what their target audience is, but it made coming over from the iPhone pretty difficult.

![11]

**To Flash or Not To Flash**

Voiding the warranty and flashing the phone had me pretty nervous, but then again, I had quite a few coworkers who were experienced in the process and they had rarely experienced problems. Luckily, [there is a great wiki page][12] that walks you through the process. It's a bit technical but I found it reasonably straightforward to follow. One of the nightly builds caused some problems with the GPS functionality on the phone but that was corrected in a day or two with another nightly build.

Upgrading to new nightly ROMs is unbelievably simple. You can download them manually to your phone and then reboot into recovery mode to flash the phone or you can load up an application on the phone itself which will download the ROM images and install the new image after a quick reboot with one key press. Don't forget to make backups just in case something goes wrong, though.

<br style="clear:both;" />

**My Application List**

Here are my favorite applications so far:

  * [1Password Reader][13]
  * [ConnectBot][14]
  * [ES File Explorer][15]
  * [Google Authenticator][16]
  * [GPS Test][17]
  * [K-9 Mail][18]
  * [Notify My Android][19]
  * [RunKeeper][20]
  * [SDRescan][9]
  * [SSHDroid][8]
  * [Titanium Backup][21]
  * [TouchDown][22]
  * [Wifi Analyzer][23]

**More Changes**

I'm waiting on my new ThinkPad T430s to ship and I'm told that Android phones are a bit easier to use within Linux than they are on a Mac. Not having the integrated USB support on the Mac is pretty frustrating. I'll probably amend this post or write another one once I'm running Linux on my laptop and using my Android with it regularly.

 [1]: http://events.linuxfoundation.org/events/linuxcon
 [2]: http://www.samsung.com/global/galaxys3/
 [3]: /wp-content/uploads/2012/09/41621v6-max-250x250.jpg
 [4]: https://play.google.com/store/apps/details?id=com.doubleTwist.androidPlayer&feature=nav_result
 [5]: https://play.google.com/store/apps/details?id=com.doubleTwist.androidPlayerProKey
 [6]: https://play.google.com/store/apps/details?id=com.songbirdnest.mediaplayer
 [7]: https://play.google.com/store/apps/details?id=com.google.android.music
 [8]: https://play.google.com/store/apps/details?id=berserker.android.apps.sshdroid
 [9]: https://play.google.com/store/apps/details?id=com.bero.sdrescan
 [10]: http://www.cyanogenmod.com/
 [11]: /wp-content/uploads/2012/09/cm7_logo.png
 [12]: http://wiki.cyanogenmod.com/wiki/Samsung_Galaxy_S_III_(AT%26T):_Full_Update_Guide
 [13]: https://play.google.com/store/apps/details?id=com.onepassword.passwordmanager
 [14]: https://play.google.com/store/apps/details?id=org.connectbot
 [15]: https://play.google.com/store/apps/details?id=com.estrongs.android.pop
 [16]: https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2
 [17]: https://play.google.com/store/apps/details?id=com.chartcross.gpstest
 [18]: https://play.google.com/store/apps/details?id=com.fsck.k9
 [19]: https://play.google.com/store/apps/details?id=com.usk.app.notifymyandroid
 [20]: https://play.google.com/store/apps/details?id=com.fitnesskeeper.runkeeper.pro
 [21]: https://play.google.com/store/apps/details?id=com.keramidas.TitaniumBackup
 [22]: https://play.google.com/store/apps/details?id=com.nitrodesk.droid20.nitroid
 [23]: https://play.google.com/store/apps/details?id=com.farproc.wifi.analyzer