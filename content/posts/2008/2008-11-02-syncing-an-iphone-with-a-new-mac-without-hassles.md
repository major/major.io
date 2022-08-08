---
title: Syncing an iPhone with a new Mac without hassles
author: Major Hayden
date: 2008-11-02T16:56:23+00:00
url: /2008/11/02/syncing-an-iphone-with-a-new-mac-without-hassles/
dsq_thread_id:
  - 3642805302
tags:
  - apple
  - iphone
  - itunes
  - mac

---
I know I usually talk about Linux server related topics on this blog, but I'm pretty proud of what I've figured out this morning on my Mac. As you know, the iPhone can really only fully sync with one machine, and if you want to connect it to a new Mac that you've purchased, you have to fully erase the iPhone and start over. (Of course, if you used the Migration Assistant to set up your new Mac, this won't be necessary.)

Here are the steps to migrate your iTunes data from one Mac to another without having to erase and re-sync your iPhone:

  * **Make sure that iTunes is not running on _both_ Macs.**
  * **Disconnect your iPhone/iPod from _both_ Macs.**
  * Copy your iTunes folder.
    `/Users/username/Music/iTunes`
  * Copy your iPhone/iPod backups.
    `/Users/username/Library/Application Support/MobileSync`
  * Copy your iTunes configuration files.
    `/Users/username/Library/Preferences/com.apple.iTunes*`
  * Open iTunes on your new Mac and verify that _Applications_ and _Ringtones_ appear.
  * Connect your iPhone/iPod to the new Mac and accept any new authorizations.
  * Use iTunes on your old Mac to de-authorize the computer.

If you choose to keep your MP3's separate from iTunes (and not in the library), this will only copy over the references to the MP3 files themselves.
