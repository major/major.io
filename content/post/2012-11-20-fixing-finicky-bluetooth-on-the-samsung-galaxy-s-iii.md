---
title: Fixing finicky Bluetooth on the Samsung Galaxy S III
author: Major Hayden
type: post
date: 2012-11-20T13:47:51+00:00
url: /2012/11/20/fixing-finicky-bluetooth-on-the-samsung-galaxy-s-iii/
dsq_thread_id:
  - 3659845406
categories:
  - Blog Posts

---
The biggest gripe I have about my Android phone is that the Bluetooth connectivity is very finicky with my car. Sometimes the phone and car won't connect automatically when I start my car and there are other times where the initial connection is fine but then the car loses the connection to the phone while I'm driving. The problem crops up in multiple cars and the biggest suspect I've found so far is the Galaxy S III's use of [Bluetooth Low Energy (BLE)][1].

I stumbled upon an application in the Google Play Store called [Bluetooth Keepalive][2] and decided to spend $1.50 to see if it could fix my problem. The application itself is quite simple:

[<img src="http://rackerhacker.com/wp-content/uploads/2012/11/bluetooth_keepalive.jpg" alt="" title="bluetooth_keepalive" width="236" height="419" class="aligncenter size-full wp-image-3834" />][3]

I configured it to start at boot and run as a background service via the configuration menu. After two days of using the application, I haven't had any weird Bluetooth issues in the car. My phone connects as soon as I start my car and it stays connected throughout my trip. There were some situations where my phone used to think it was connected to my car even when I was miles away and those problems are gone as well. Battery life seems to be unaffected by the change.

I'm currently running CyanogenMod 10 Nightly w/Android 4.1.2 on an AT&T Galaxy S III (SGH-I747). Your mileage might vary on other ROM's and models.

 [1]: http://en.wikipedia.org/wiki/Bluetooth_low_energy
 [2]: https://play.google.com/store/apps/details?id=org.floodping.BluetoothKeepalive&hl=en
 [3]: http://rackerhacker.com/wp-content/uploads/2012/11/bluetooth_keepalive.jpg
