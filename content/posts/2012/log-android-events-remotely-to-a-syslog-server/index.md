---
aliases:
- /2012/11/04/log-android-events-remotely-to-a-syslog-server/
author: Major Hayden
date: 2012-11-04 20:47:39
tags:
- android
- bluetooth
- centos
- fedora
- red hat
- syslog
title: Log Android events remotely to a syslog server
---

I'm still quite pleased with my Samsung Galaxy SIII but there are some finicky Bluetooth issues with my car that I simply can't figure out. [After discovering logcat][1], I wondered if there was a way to get logs sent from an Android device to a remote syslog server. It's certainly possible and it actually works quite well.

My phone is currently rooted with CyanogenMod 10 installed. Some of these steps **will require rooting your device.** Be sure to fully understand the implications of gaining root access on your particular device **before** trying it.

Get started by installing [Titanium Backup][2] and [Logcat to UDP][3]. Once they're installed, you'll need to enable USB debugging by accessing **Settings > Developer Options**:

![4]

Now, run Titanium Backup and click the **Backup/Restore** tab at the top. Find the &#8220;Logcat to UDP 0.5&#8221; application and hold your finger on it for a few seconds. Press **Convert to system app** and wait for that to complete:

![5]

Now, run the **Logcat to UDP** application and configure it. Put in a server IP address for the remote syslog server and choose a remote port where your syslog server is listening. Be sure to check the **Filter log messages** box and put in a reasonable set of things to watch. My standard filter is:

```
Sensors:S dalvikvm:S MP-Decision:S overlay:S RichInputConnection:S *:V
```

That filter says that I don't want to see data from the Sensors process (and some other chatty daemons) but I want verbose logs from everything else. The full details on logcat filters can be found in [Google's Android Developer Documentation][6].

When all that is done, you can begin receiving syslog data pretty quickly on a CentOS or Fedora server. For CentOS, you only need to make a small adjustment to /etc/rsyslog.conf to begin receiving logs:

```
# Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514
```

The standard port is 514, but be sure to change it to match your configuration in the Logcat to UDP application on your phone. Restart rsyslog and you should be able to see logs flowing in from your Android device:

```
# /etc/init.d/rsyslog restart
Shutting down system logger:                               [  OK  ]
Starting system logger:                                    [  OK  ]
# tail /var/log/messages
Nov  4 20:44:04 home.local Iridium: E/ThermalDaemon(  264): ACTION: CPU - Setting CPU[0] to 1512000
Nov  4 20:44:04 home.local Iridium: E/ThermalDaemon(  264): ACTION: CPU - Setting CPU[1] to 1512000
Nov  4 20:44:04 home.local Iridium: E/ThermalDaemon(  264): Fusion mitigation failed - QMI registration incomplete
Nov  4 20:44:07 home.local Iridium: I/ActivityManager(  624): START {act=android.intent.action.MAIN cat=[android.intent.category.HOME] flg=0x10200000 cmp=com.cyanogenmod.trebuchet/.Launcher u=0} from pid 624
Nov  4 20:44:07 home.local Iridium: I/ActivityManager(  624): START {act=android.intent.action.MAIN cat=[android.intent.category.HOME] flg=0x10200000 cmp=com.cyanogenmod.trebuchet/.Launcher u=0} from pid 624
Nov  4 20:44:07 home.local Iridium: I/ActivityManager(  624): START {act=android.intent.action.MAIN cat=[android.intent.category.HOME] flg=0x10200000 cmp=com.cyanogenmod.trebuchet/.Launcher u=0} from pid 624
Nov  4 20:44:08 home.local Iridium: I/ActivityManager(  624): START {act=android.intent.action.MAIN cat=[android.intent.category.HOME] flg=0x10200000 cmp=com.cyanogenmod.trebuchet/.Launcher u=0} from pid 624
Nov  4 20:44:09 home.local Iridium: E/ThermalDaemon(  264): Sensor 'tsens_tz_sensor0' - alarm raised 1 at 57.0 degC
Nov  4 20:44:09 home.local Iridium: E/ThermalDaemon(  264): ACTION: CPU - Setting CPU[0] to 1134000
Nov  4 20:44:09 home.local Iridium: E/ThermalDaemon(  264): ACTION: CPU - Setting CPU[1] to 1134000
```


If you're not seeing logs on your remote server, be sure to check the remote server's firewall since the default rules on a CentOS or Fedora server will block syslog traffic. If you want to generate logs quickly for testing in CyanogenMod, just repeatedly press the home button. A log line from the trebuchet launcher should appear each time.

 [1]: https://twitter.com/rackerhacker/status/261292543965274113
 [2]: https://play.google.com/store/apps/details?id=com.keramidas.TitaniumBackup&hl=en
 [3]: https://play.google.com/store/apps/details?id=sk.madzik.android.logcatudp
 [4]: /wp-content/uploads/2012/11/2012-11-04-14.31.59.jpg
 [5]: /wp-content/uploads/2012/11/2012-11-04-14.36.18.jpg
 [6]: http://developer.android.com/tools/debugging/debugging-log.html#filteringOutput