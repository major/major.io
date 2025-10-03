---
aliases:
- /2012/01/11/native-ipv6-connectivity-in-mikrotiks-routeros/
author: Major Hayden
date: 2012-01-11 13:30:07
tags:
- command line
- ipv6
- linux
- mikrotik
- networking
title: Native IPv6 connectivity in Mikrotik’s RouterOS
---

It's no secret that I'm a big fan of the [Routerboard][1] devices and the [RouterOS software from Mikrotik][2] that runs on them. The hardware is solid, the software is stable and feature-rich, and I found a [great vendor][3] that ships quickly.

I recently added a [RB493G][4] ([~ $230 USD][5]) to sit in front of a pair of colocated servers. The majority of the setup routine was the same as with my previous devices except for the IPv6 configuration.

In the past, I've set up IPv6 tunnels with [Hurricane Electric][6] and it's been mostly a cut-and-paste operation from the sample configuration in their IPv6 tunnel portal. Setting up native IPv6 involved a little more legwork.

If your provider will give you two /64's or an entire /48, getting IPv6 connectivity for your WAN/LAN interfaces is simple. However, if you can only get one /64, you'll have to see if your provider can route it to you via your Mikrotik's [link local][7] interface (I wouldn't recommend this for many reasons).

I split my Mikrotik into two interfaces: wan and lanbridge. The lanbridge bridge joins all of the LAN ethernet ports (ether2-9 on the RB493G) and the wan interface connects to the upstream switch.

My configuration:

```
/ipv6 address
add address=2001:DB8:0:1::2/64 advertise=yes disabled=no eui-64=no interface=wan
add address=2001:DB8:0:2::1/64 advertise=yes disabled=no eui-64=no interface=lanbridge
/ipv6 route
add disabled=no distance=1 dst-address=::/0 gateway=2001:DB8:0:1::1 scope=30 \
  target-scope=10
/ipv6 nd
add advertise-dns=no advertise-mac-address=yes disabled=no hop-limit=64 \
  interface=all managed-address-configuration=no mtu=unspecified \
  other-configuration=no ra-delay=3s ra-interval=3m20s-10m ra-lifetime=30m \
  reachable-time=unspecified retransmit-interval=unspecified
/ipv6 nd prefix default
set autonomous=yes preferred-lifetime=1w valid-lifetime=4w2d
```


Explanation:

```
/ipv6 address
add address=2001:DB8:0:1::2/64 advertise=yes disabled=no eui-64=no interface=wan
add address=2001:DB8:0:2::1/64 advertise=yes disabled=no eui-64=no interface=lanbridge
```


These two lines configure the IPv6 addresses for the firewall's interfaces. My provider's router holds the 2001:DB8:0:1::1/64 address and routes the remainder of that /64 to me via 2001:DB8:0:1::2/64. The second /64 is on the lanbridge interface and my LAN devices take their IP addresses from that block. My provider routes that second /64 to me via the 2001:DB8:0:1::2/64 IP on my wan interface.

```
/ipv6 route
add disabled=no distance=1 dst-address=::/0 gateway=2001:DB8:0:1::1 scope=30 \
  target-scope=10
```


I've set a [gateway][8] for IPv6 traffic so that the Mikrotik knows where to send internet-bound IPv6 traffic (in this case, to my ISP's core router).

```
/ipv6 nd
add advertise-dns=no advertise-mac-address=yes disabled=no hop-limit=64 \
  interface=lanbridge managed-address-configuration=no mtu=unspecified \
  other-configuration=no ra-delay=3s ra-interval=3m20s-10m ra-lifetime=30m \
  reachable-time=unspecified retransmit-interval=unspecified
/ipv6 nd prefix default
set autonomous=yes preferred-lifetime=1w valid-lifetime=4w2d
```


These last two lines configure the [neighbor discovery][9] on my lanbridge interface. This allows my LAN devices to do [stateless autoconfiguration][10] (which gives them an IPv6 address as well as the gateway).

Want to read up on IPv6?

  * [Linux IPv6 HOWTO][11]
  * [IPv6 on Wikipedia][12]
  * [IPv6 Cheat Sheet][13] [PDF]
  * [IPv6 Subnetting Card][14]

 [1]: http://routerboard.com/
 [2]: http://www.mikrotik.com/software.html
 [3]: http://www.roc-noc.com/
 [4]: http://routerboard.com/RB493G
 [5]: http://www.roc-noc.com/mikrotik/routerboard/rb493g-complete.html
 [6]: http://ipv6.he.net/
 [7]: http://en.wikipedia.org/wiki/Link-local_address#IPv6
 [8]: http://tldp.org/HOWTO/html_single/Linux+IPv6-HOWTO/#AEN1083
 [9]: http://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol
 [10]: http://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_.28SLAAC.29
 [11]: http://tldp.org/HOWTO/html_single/Linux+IPv6-HOWTO/
 [12]: http://en.wikipedia.org/wiki/IPv6
 [13]: http://www.roesen.org/files/ipv6_cheat_sheet.pdf
 [14]: http://www.ripe.net/lir-services/resource-management/number-resources/ipv6/ipv6-subnetting-card