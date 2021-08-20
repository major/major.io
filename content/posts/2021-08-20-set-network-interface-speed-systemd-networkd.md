---
author: Major Hayden
categories:
- Blog Posts
date: '2021-08-20'
description: >-
    Sometimes network interface autonegotiation doesn't work as well as it
    should. Luckily, you can fix it with systemd-networkd. 🔧
images:
- images/2021-08-20-handshake-neon-sign.jpg
slug: set-network-interface-speed-systemd-networkd
tags:
- fedora
- linux
- networking
- systemd
- systemd-networkd
title: Set network interface speed with systemd-networkd
type: post
---

{{< figure src="/images/2021-08-20-handshake-neon-sign.jpg" alt="Neon sign handshake" position="center" >}}

Sometimes automation is your best friend and sometimes it isn't. Typically, when
two devices are connected via ethernet cables, [they negotiate] the best speed
they can manage across a network link. They also try to agree on whether they
can run full or half duplex across the network link.

Most of the time, this works beautifully. It can break down with strange
networking configs, damaged adapters, or finicky cables. In those situations, if
you can rule out physical damage to any parts involved, you may need to disable
autonegotiation to get the functionality you want.

[they negotiate]: https://en.wikipedia.org/wiki/Autonegotiation

## Slow home network

My home internet connection has a 400 megabit per second downlink, but noticed
my downloads were slower this week and if someone was actively downloading
something, such as an Xbox update, the internet latency shot up past 300ms. A
few speed tests later and I found my internet speeds were limited to about 88
megabits per second.

My home firewall is a Dell Optiplex 7060 with an Intel I350-T2 dual-port gigabit
ethernet card. My internet-facing NIC connects to a Netgear CM500-NAS cable
modem. A quick check of my firewall's external adapter revealed the problem:

```console
# ethtool enp2s0f0 | grep Speed
	Speed: 100Mb/s
```

Well that's certainly not right. The I350 is a gigabit card and the CM500-NAS is
rated for speeds well over 100 mb/s. Rebooting the cable modem and the router
itself didn't change anything. I replaced the ethernet cable with a few others
and there was no change there, either.

At this point, I was worried that my cable modem or adapter might have
malfunction. At least there's one more option.

## Manually set the link speed

Before we approach this section, here's a reminder:

----

💣 **Be sure that you have some other way to get into your system if manually
setting the link speed fails.**

If the system is remote to you, such as a dedicated server, virtual machine, or
a faraway edge device that requires a 5 hour drive, you may want to consider
other options. There's a chance that manually setting the link speed may cause
the link negotiation to fail entirely.

----

systemd-networkd gives you plenty of low-level control over network interfaces
using the [link files]. These files have two parts:

* a `[Match]` section that tells systemd-networkd about the network devices that
    need special configuration
* a `[Link]` section that has special configuration for a network interface

We need two of these configurations in the `[Link]` section:

* `BitsPerSecond=` specifies the speed for the device with K/M/G suffixes
* `Duplex=` specifies `half` or `full` duplex

In this example, I'll match the interface on its MAC address and set the
speed/duplex:

```ini
# /etc/systemd/networkd/internet.link
[Match]
MACAddress=a0:36:9f:6e:52:26

[Link]
BitsPerSecond=1G
Duplex=full
```

We can apply the configuration change by restarting systemd-networkd:

```console
systemctl restart systemd-networkd
```

Now let's check the speeds:

```console
# ethtool enp2s0f0 | grep Speed
	Speed: 1000Mb/s
```

Perfect! 🎉

## Digging for answers

Once the network speeds were working well again and my kids weren't upset by
glitches in their Netflix shows, I decided to look for issues that might be
causing the negotiation to fail. Some quick checks of the network card show some
potential issues:

```console
# ethtool -S enp2s0f0 | grep error
     rx_crc_errors: 22
     rx_missed_errors: 0
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_window_errors: 0
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     rx_errors: 33
     tx_errors: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_frame_errors: 0
     rx_fifo_errors: 0
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
```

I've swapped network cables between the devices a few times and these errors
continue to appear frequently. My I350 card is several years old and
discontinued from Intel, so this could be the culprit. It's also been moved
between quite a few different computers over the years. A replacement with
something new might be in my future.

[link files]: https://www.freedesktop.org/software/systemd/man/systemd.link.html

*Photo credit: [Charles Deluvio on Unsplash](https://unsplash.com/photos/AT5vuPoi8vc)*
