---
title: systemd-networkd and macvlan interfaces
author: Major Hayden
date: 2015-10-26T13:50:36+00:00
url: /2015/10/26/systemd-networkd-and-macvlan-interfaces/
dsq_thread_id:
  - 4260851829
tags:
  - fedora
  - kvm
  - macvlan
  - networking
  - security
  - virtualization

---
I spent some time working with [macvlan][1] interfaces on KVM hypervisors last weekend. They're interesting because they're not really a _bridge_. It allows you to assign multiple MAC addresses to a single interface and then allow the kernel to filter traffic into tap interfaces based on the MAC address in the packet. If you're looking for a highly detailed explanation, head on over to [waldner's blog][2] for a deep dive into the technology and the changes that come along with it.

## Why macvlan?

Bridging can become a pain to work with, especially when you're forced to add in creative filtering rules and keep them updated. The macvlan interfaces can help with that (read up on [VEPA][2] mode). There are some [interesting email threads][3] showing that macvlan interfaces can improve network performance for various workloads. Low latency workloads can benefit from the simplicity and low overhead of macvlan interfaces.

## systemd-networkd and macvlan interfaces

Fortunately for us, systemd-networkd makes configuring a macvlan interface **really** easy. I've written about [configuring bridges with systemd-networkd][4] and the process for macvlan interfaces is similar.

In my scenario, I have a 1U server with an ethernet interface called `enp4s0` (read up on [interface naming with systemd-udevd][5]). I want to make a macvlan interface for virtual machines and I'll be attaching VM's to that interface via macvtap interfaces. It's similar to bridging where you make a bridge and then give everyone a port on the bridge.

Start by creating a network device for our macvlan interface:

```ini
# /etc/systemd/network/vmbridge.netdev
[NetDev]
Name=vmbridge
Kind=macvlan

[MACVLAN]
Mode=bridge
```


I've told systemd-networkd that I want a macvlan interface set up in bridge mode. This will allow hosts and virtual machines to talk to one another on the interface. You could choose `vepa` for the mode if you want additional security. However, this will force traffic out to your upstream switch/router and makes it challenging for hosts and guests to communicate with each other.

Now that we have a device configured, let's configure the IP address for the macvlan interface (similar to configuring a bridge):

```ini
# /etc/systemd/network/vmbridge.network
[Match]
Name=vmbridge

[Network]
IPForward=yes
Address=192.168.250.33/24
Gateway=192.168.250.1
DNS=192.168.250.1
```


Let's tell systemd-networkd that our physical network interface, `enp4s0`, is part of this interface:

```ini
# /etc/systemd/network/enp4s0.network
[Match]
Name=enp4s0

[Network]
MACVLAN=vmbridge
```


This is very similar to a configuration for a standard Linux bridge. Once you've reached this step, you'll most likely want to reboot to ensure all of your network devices come up properly.

## Attaching a virtual machine

Attaching a KVM virtual machine to the macvlan interface is quite easy. When you're creating a new VM using `virt-manager`, look for this setting in the wizard:

![6]

If you're installing via `virt-install` just use the following argument for your network configuration:

```
--network type=direct,source=vmbridge,source_mode=bridge
```


You'll end up with interfaces like these after creating multiple virtual machines:

```
 mtu 1500 qdisc fq_codel state UNKNOWN mode DEFAULT group default qlen 500
    link/ether 52:54:00:83:53:f2 brd ff:ff:ff:ff:ff:ff promiscuity 0
    macvtap  mode bridge addrgenmode eui64
15: macvtap2@enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN mode DEFAULT group default qlen 500
    link/ether 52:54:00:f1:76:0b brd ff:ff:ff:ff:ff:ff promiscuity 0
    macvtap  mode bridge addrgenmode eui64
17: macvtap3@enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN mode DEFAULT group default qlen 500
    link/ether 52:54:00:cd:53:34 brd ff:ff:ff:ff:ff:ff promiscuity 0
    macvtap  mode bridge addrgenmode eui64
20: macvtap1@enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN mode DEFAULT group default qlen 500
    link/ether 52:54:00:18:79:d3 brd ff:ff:ff:ff:ff:ff promiscuity 0
    macvtap  mode bridge addrgenmode eui64
```


 [1]: http://virt.kernelnewbies.org/MacVTap
 [2]: http://backreference.org/2014/03/20/some-notes-on-macvlanmacvtap/
 [3]: http://www.spinics.net/lists/netdev/msg103457.html
 [4]: https://major.io/2015/03/26/creating-a-bridge-for-virtual-machines-using-systemd-networkd/
 [5]: https://major.io/2015/08/21/understanding-systemds-predictable-network-device-names/
 [6]: /wp-content/uploads/2015/10/Selection_036.png
