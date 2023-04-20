---
author: Major Hayden
date: '2023-04-20'
summary: |
  Segment your home network easily with a VLAN on a Mikrotik router. 🖥️
tags:
  - fedora
  - mikrotik
  - networking
  - vlan
title: Add a VLAN on a Mikrotik router
---

If your house is like mine, you have devices that you really trust and then there are
those _other devices_.

My trusted device group includes my work computers, a Synology NAS, and a few other
computers. The bucket of untrusted devices includes Chromecasts, TVs, tablets, phones,
and whatever random devices that my kids' friends bring over.

A [VLAN](https://en.wikipedia.org/wiki/VLAN) helps with traffic segmentation by
isolating certain traffic over the same network cable. A router can manage tons of
different networks via the same downlink cable(s) to a switch or other equipment. You
can tell a switch to only allow certain VLANs through a port or you can have the port
only offer one network that happens to be one of your VLANs.

The best analogy for a VLAN is a _cable within a cable_. It's almost like being able to
add thousands of individual segmented networks in the same ethernet cable.

VLANs are possible via a networking standard called
[802.1Q](https://en.wikipedia.org/wiki/IEEE_802.1Q). Network devices add a small 802.1Q
header, often called a _VLAN tag_, to each ethernet packet. These tags offer a way for
network devices to filter traffic on a network.

It works well for devices that don't understand VLANs, too. For example, if you have a
device that isn't VLAN-aware, you can plug it into a switch port that is configured to
offer a VLAN network as the native VLAN. That device happily uses the network it is
offered via the switch port without knowing that the switch is adding VLAN tags to all
traffic that the device creates.

Let's get a VLAN working on a Mikrotik router.

# Adding a VLAN

Mikrotik devices have a great command line interface and I'll use that for this post.

In this example, my networks are set up like this:

1. I have a default LAN network: `192.168.10.0/24`
2. My VLAN network is tagged with tag 15: `192.168.15.0/24`

The basic building block of any network on a Mikrotik device is an _interface_. We start
by creating a VLAN interface:

```
/interface vlan \
add interface=bridge name=vlan15 vlan-id=15
```

My router uses a bridge called `bridge` _(gotta keep things simple)_, but you may need
to use something like `ether2` or `ether3` if you're using a physical network interface
instead of a bridge.

Now I can add an IP address to my new network interface:

```
/ip address \
add address=192.168.15.1/24 interface=vlan15 network=192.168.15.0
```

DHCP sure does make IP address configuration easier, so let's create an address pool and
a DHCP server instance for our VLAN network. Choose whatever range makes sense for you
but my default is usually `10-254`:

```
/ip pool \
add name=vlan15 ranges=192.168.15.10-192.168.15.254
```

Add a DHCP server:

```
/ip dhcp-server \
add address-pool=vlan15 interface=vlan15 name=vlan15
```

The DHCP server uses our `vlan15` address pool for handing out addresses to devices on
the VLAN.

# Testing the VLAN

I like to give the VLAN a quick test with my desktop PC before I start messing around
with the switch configuration. We just need to add a VLAN device via `nmcli` and verify
that DHCP and routing are working.

Let's add a new interface called `VLAN15` to handle traffic tagged with VLAN 15:

```
# Replace enp7s0 with your ethernet interface name!
$ nmcli con add type vlan ifname VLAN15 con-name VLAN15 dev enp7s0 id 15
Connection 'VLAN15' (f7cd4cdf-d2ce-4dc7-9ed8-f40102ff3e42) successfully added.
```

Did we get an IP address and a route?

```
$ ip addr show dev VLAN15
7: VLAN15@enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether xx:xx:xx:xx:xx:xx brd ff:ff:ff:ff:ff:ff
    inet 192.168.15.52/24 brd 192.168.15.255 scope global dynamic noprefixroute VLAN15
       valid_lft 409sec preferred_lft 409sec
    inet6 fe80::7f62:9d9a:dc8c:3fd7/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
$ ip route show dev VLAN15
192.168.15.0/24 proto kernel scope link src 192.168.15.52 metric 400 
```

Awesome!

# Using it with a switch

I have a Mikrotik CRS that I use for my main home switch and it handles VLAN tagging. My
goal here is to _trunk_ VLAN 15 from the router down to the switch so that a particular
port _ONLY_ exposes the VLAN 15 network to a device. I don't want that device to have
any idea that VLAN 15 even exists. It should think that there's a regular old LAN
network coming through the switch port.

This is called an _access port_. Devices on the port have no idea that VLAN tagging is
happening on the switch, but the switch tags all traffic coming from the port.

In this example, I set up switch port `ether20` to take VLAN 15 and make it available as
VLAN 0 (the native VLAN) to anything connected to that switch port:

```
/interface ethernet switch ingress-vlan-translation \
add ports=ether20 customer-vid=0 new-customer-vid=15 sa-learning=yes
```

The `sa-learning` configuration tells the switch to learn the source MAC addresses after
the VLAN translation occurs. I'm not sure if this is explicitly required, but I've
always enabled this setting for access ports. You don't need it for non-VLAN-aware
ports, though.

At this point, I can connect a device to port `ether20` and it gets an IP address via
DHCP on the `192.168.15.1` network automatically!

# Extra credit

Once you begin segmenting your network, review your router configuration to see how
these networks are allowed to communicate with one another. The default on Mikrotik
devices is to allow internal networks to freely communicate with each other since that
makes everything easier to get started. However, I don't want my Chromecast to talk to
my NAS.

Mikrotik's IP firewalling capabilities give you lots of methods for limiting access
between networks. Be sure to read up on the
[IP/Firewall/Filter](https://wiki.mikrotik.com/wiki/Manual:IP/Firewall/Filter)
documentation. If you use IPv6 on your network, be sure to review the
[IPv6/Firewall/Filter](https://wiki.mikrotik.com/wiki/Manual:IPv6/Firewall/Filter) docs,
too.

Even if you think that you aren't using IPv6 internally, [you might actually be using
it](https://en.wikipedia.org/wiki/Link-local_address). 😉

_Cover photo credit: [Kartabya Aryal](https://unsplash.com/photos/dHw-xRahyLY)_