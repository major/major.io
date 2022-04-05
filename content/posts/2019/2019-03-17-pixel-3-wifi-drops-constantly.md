---
author: Major Hayden
categories:
- Blog Posts
date: '2019-03-17'
images:
- images/2019-03-17-google-pixel-phones.jpg
slug: pixel-3-wifi-drops-constantly
tags:
- android
- networking
title: Pixel 3 Wi-Fi drops constantly
type: post
---

![pixel_phones]

We have two Google Pixel phones in our house: a Pixel 2 and a Pixel 3. Both
of them drop off our home wireless network regularly. It causes lots of
problems with various applications on the phones, especially casting video
via Chromecast.

At the time when I first noticed the drops, I was using a pair of wireless
access points (APs) from Engenius:

* [EAP600]
* [EAP1200H]

Also, here's what I knew at the time:

* Mac and Linux computers had no Wi-Fi issues at all
* The signal level from both APs was strong
* Disabling one AP made no improvement
* Disabling one band (2.4 or 5GHz) on the APs made no improvement
* Clearing the bluetooth/Wi-Fi data on the Pixel had no effect
* Assigning a static IP address on the Pixel made no improvement
* Using unencrypted SSIDs made no improvement

At this point, I felt strongly that the APs had nothing to do with it. I
ordered a new [NetGear Orbi] mesh router and satellite anyway. The Pixels
still dropped off the wireless network even with the new Orbi APs.

## Reading logs

I started reading logs from every source I could find:

* dhcpd logs from my router
* syslogs from my APs (which forwarded into the router)
* output from tcpdump on my router

Several things became apparent after reading the logs:

* The Wi-Fi drop occurred usually every 30-60 seconds
* The DHCP server received requests for a new IP address after every drop
* None of the network traffic from the phones was being blocked at the router
* The logs from the APs showed the phone disconnecting itself from the
  network; the APs were not forcing the phones off the network

All of the wireless and routing systems in my house seemed to point to a
problem in the phones themselves. They were voluntarily dropping from the
network without being bumped off by APs or the router.

## Getting logs from the phone

It was time to get some logs from the phone itself. That would require
connecting the phone via USB to a computer and enabling USB debugging on the
phone.

First, I downloaded the [Android SDK]. The full studio release isn't needed
-- scroll down and find the *Command line tools only* section. Unzip the
download and find the `tools/bin/sdkmanager` executable. Run it like this:

```
# Fedora 29 systems may need to choose the older Java version for sdkmanager
# to run properly.
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.fc29.x86_64/jre
# Install the android-28 platform tools
./sdkmanager "platform-tools" "platforms;android-28"
```

Now we need to enable USB debugging on the phone itself. **Be sure to disable
USB debugging when you are done!** Follow these steps:

1. Go into the phone's settings and choose *About Phone* from the bottom of
   the list.
2. Scroll to the bottom and tap the *Build number* section repeatedly until
   a message appears saying that you are now a developer.
3. Go back one screen and tap *System*.
4. Click *Advanced* to show the additional options and tap *Developer Options*.
5. In the *Debugging* section, tap *USB Debugging* to enable USB debugging.

Connect the phone to your computer via USB and run:

```
sudo platform-tools/adb logcat
```

Your screen will fill with logs from your phone.

## Nuggets in the log

I watched the logs and waited for the Wi-Fi to drop. As soon as it dropped, I
saw some interesting log messages:

```
I wpa_supplicant: wlan0: CTRL-EVENT-AVOID-FREQ ranges=5785-5825
I chatty  : uid=1000(system) IpClient.wlan0 expire 3 lines
I chatty  : uid=1000 system_server expire 1 line
D CommandListener: Setting iface cfg
E cnss-daemon: wlan_service_update_sys_param: unable to open /proc/sys/net/ipv4/tcp_use_userconfig
I chatty  : uid=1000(system) android.fg expire 1 line
I wpa_supplicant: wlan0: CTRL-EVENT-DISCONNECTED bssid=88:dc:96:4a:b6:75 reason=3 locally_generated=1
I chatty  : uid=10025 com.google.android.gms.persistent expire 7 lines
V NativeCrypto: Read error: ssl=0x7b349e2d08: I/O error during system call, Software caused connection abort
V NativeCrypto: Write error: ssl=0x7b349e2d08: I/O error during system call, Broken pipe
V NativeCrypto: Write error: ssl=0x7b349e2d08: I/O error during system call, Broken pipe
V NativeCrypto: SSL shutdown failed: ssl=0x7b349e2d08: I/O error during system call, Success
D ConnectivityService: reportNetworkConnectivity(158, false) by 10025
```

The line with `CTRL-EVENT-AVOID-FREQ` isn't relevant because it's simply a
hint to the wireless drivers to avoid certain frequencies not used in the
USA. The `CTRL-EVENT-DISCONNECTED` shows where wpa_supplicant received the
disconnection message. The last line with `ConnectivityService` was very
interesting. Something in the phone believes there is a network connectivity
issue. That could be why the Pixel is hopping off the wireless network.

From there, I decided to examine only the `ConnectivityService` logs:

```
sudo platform-tools/adb logcat 'ConnectivityService:* *:S'
```

This logcat line tells adb that I want all logs from all log levels about the
`ConnectivityService`, but all of the other logs should be silenced. I
started seeing some interesting details:

```
D ConnectivityService: NetworkAgentInfo [WIFI () - 148] validation failed
D ConnectivityService: Switching to new default network: NetworkAgentInfo{ ni{[type: MOBILE[LTE]...
D ConnectivityService: Sending DISCONNECTED broadcast for type 1 NetworkAgentInfo [WIFI () - 148] isDefaultNetwork=true
D ConnectivityService: Sending CONNECTED broadcast for type 0 NetworkAgentInfo [MOBILE (LTE) - 100] isDefaultNetwork=true
D ConnectivityService: handleNetworkUnvalidated NetworkAgentInfo [WIFI () - 148] ...
```

Wait, what is this "validation failed" message? The Pixel was making network
connections successfully the entire time as shown by tcpdump. This is part of
Android's [network connecivity checks] for various networks.

The last few connections just before the disconnect were to
`connectivitycheck.gstatic.com` (based on tcpdump logs) and that's Google's
way of verifying that the wireless network is usable and that there are no
captive portals. I connected to it from my desktop on IPv4 and IPv6 to verify:

```
$ curl -4 -i https://connectivitycheck.gstatic.com/generate_204
HTTP/2 204
date: Sun, 17 Mar 2019 15:00:30 GMT
alt-svc: quic=":443"; ma=2592000; v="46,44,43,39"
$ curl -6 -i https://connectivitycheck.gstatic.com/generate_204
HTTP/2 204
date: Sun, 17 Mar 2019 15:00:30 GMT
alt-svc: quic=":443"; ma=2592000; v="46,44,43,39"
```

Everything looked fine.

## Heading to Google

After a bunch of searching on Google, I kept finding posts talking about
disabling IPv6 to fix the Wi-Fi drop issues. I shrugged it off and kept
searching. Finally, I decided to disable IPv6 and see if that helped.

I stopped `radvd` on the router, disabled Wi-Fi on the phone, and then
re-enabled it. As I watched, the phone stayed on the wireless network for two
minutes. Three minutes. Ten minutes. **There were no drops.**

At this point, this is still an unsolved mystery for me. Disabling IPv6 is a
terrible idea, but it keeps my phones online. I plan to put the phones on
their own VLAN without IPv6 so I can still keep IPv6 addresses for my other
computers, but this is not a good long term fix. If anyone has any input on
why this helps and how I can get IPv6 re-enabled, please [let me know]!

## Update 2019-03-18

Several readers wanted to see what was happening just before the Wi-Fi drop,
so here's a small snippet from tcpdump:

```
07:26:06.736900 IP6 2607:f8b0:4000:80d::2003.443 > phone.41310: Flags [F.], seq 3863, ack 511, win 114, options [nop,nop,TS val 1288800272 ecr 66501414], length 0
07:26:06.743101 IP6 2607:f8b0:4000:80d::2003.443 > phone.41312: Flags [F.], seq 3864, ack 511, win 114, options [nop,nop,TS val 1778536228 ecr 66501414], length 0
07:26:06.765444 IP6 phone.41312 > 2607:f8b0:4000:80d::2003.443: Flags [R], seq 4183481455, win 0, length 0
07:26:06.765454 IP6 phone.41310 > 2607:f8b0:4000:80d::2003.443: Flags [R], seq 3279990707, win 0, length 0
07:26:07.487180 IP6 2607:f8b0:4000:80d::2003.443 > phone.41316: Flags [F.], seq 3863, ack 511, win 114, options [nop,nop,TS val 4145292968 ecr 66501639], length 0
07:26:07.537080 IP6 phone.41316 > 2607:f8b0:4000:80d::2003.443: Flags [R], seq 4188442452, win 0, length 0
```

That IPv6 address is at a Google PoP in Dallas, TX:

```
$ host 2607:f8b0:4000:80d::2003
3.0.0.2.0.0.0.0.0.0.0.0.0.0.0.0.d.0.8.0.0.0.0.4.0.b.8.f.7.0.6.2.ip6.arpa domain name pointer dfw06s49-in-x03.1e100.net.
```

I haven't been able to intercept the traffic via man-in-the-middle since
Google's certificate checks are very strict. However, checks from my own
computer work without an issue:

```
$ curl -ki "https://[2607:f8b0:4000:80d::2003]/generate_204"
HTTP/2 204
date: Mon, 18 Mar 2019 12:35:18 GMT
alt-svc: quic=":443"; ma=2592000; v="46,44,43,39"
```

[pixel_phones]: /images/2019-03-17-google-pixel-phones.jpg
[EAP600]: https://www.engeniustech.com/engenius-products/indoor-wireless-ceiling-ap-eap600/
[EAP1200H]: https://www.engeniustech.com/engenius-products/indoor-wireless-ceiling-ap-eap1200h/
[NetGear Orbi]: https://www.netgear.com/support/product/RBR50.aspx
[Android SDK]: https://developer.android.com/studio
[Network connectivity checks]: https://android.googlesource.com/platform/frameworks/base/+/android-6.0.0_r1/services/core/java/com/android/server/ConnectivityService.java#2009
[let me know]: mailto:major@mhtx.net