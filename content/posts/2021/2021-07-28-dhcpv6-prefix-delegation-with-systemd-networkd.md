---
author: Major Hayden
categories:
- Blog Posts
date: '2021-07-28'
summary: >-
    Use the new DHCPv6 prefix delegation features in systemd-networkd to make IPv6 subnetting easy! 🎉
images:
- images/2021-07-28-pipes.jpg
slug: dhcpv6-prefix-delegation-with-systemd-networkd
tags:
- fedora
- linux
- networking
title: DHCPv6 prefix delegation with systemd-networkd
type: post
---

{{< figure src="/images/2021-07-28-pipes.jpg" alt="Industrial pipes on a wall" position="center" >}}

My home internet comes from Spectrum (formerly Time Warner Cable) and they offer
IPv6 addresses for cable modem subscribers. One of the handy features they
provide is [DHCPv6 prefix delegation]. If you're not familiar with that topic,
here's a primer on how you get IPv6 addresses:

* [SLAAC]: Your machine selects an IPv6 address based on router advertisements
* DHCPv6: Your machine makes a DHCPv6 request (a lot like DHCP requests) and
  gets an address back to use
* DHCPv6 with prefix delegation: Your machine makes a special DHCPv6 request
  where you provide a hint about the size of the IPv6 network prefix you want.

Are you new to IPv6 subnets and how they're different from IPv4? If so, you
might want to read up on [IPv6 subnets] first.

In a previous post, I wrote about [using wide-dhcpv6 to get IPv6 addresses] and
that guide still works, but using systemd-networkd makes the process *much
easier*.

[DHCPv6 prefix delegation]: https://en.wikipedia.org/wiki/Prefix_delegation
[SLAAC]: https://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_(SLAAC)
[IPv6 subnets]: https://docs.netgate.com/pfsense/en/latest/network/ipv6/subnets.html
[using wide-dhcpv6 to get IPv6 addresses]: /2015/09/11/time-warner-road-runner-linux-and-large-ipv6-subnets/

## Who needs this many IP addresses?

Yes, I know that a /64 IPv6 network contains 18,446,744,073,709,551,616
addresses and that should be enough for most home networks. Using one /64
network block per interface has plenty of benefits for simplifying your network,
though.

A /56 from your provider contains 256 /64 networks and this makes it easy to
configure up to 256 internal networks with a /64 on each. Breaking up a /64
subnet into pieces becomes frustrating very quickly.

## Laying out the basic network

My Linux router is a Dell Optiplex running Fedora 34 with a dual-port Intel I350
network card. These little machines are assembled well and last a long time. My
network interfaces are set up like this:

* `enp2s0f0`: connected to my cable modem for internet access
* `enp2s0f1`: connected to a network bridge (`br0`) for my LAN network

My LAN (192.168.10.0/24) gateway sits on `br0` and masquerades traffic out
through `enp2s0f0`, the external network interface.

All of the systemd-networkd configuration lives in `/etc/systemd/network` and we
will add some files there. First off, we need to set up the external network:

```ini
# /etc/systemd/network/wan.network
[Match]
Name=enp2s0f0

[Network]
DHCP=yes
```

Now we need to set up the internal bridge `br0`:

```ini
# /etc/systemd/network/lanbridge.network
[NetDev]
Name=br0
Kind=bridge
```

Then we can configure the `br0` network interface and IP address:

```ini
# /etc/systemd/network/lanbridge.network
[Match]
Name=br0

[Network]
Address=192.168.10.1/24
ConfigureWithoutCarrier=yes
```

🤔 **Special note:** I like to add the `ConfigureWithoutCarrier` option here
because systemd-network sometimes takes a while to bring the bridge online after
a reboot and that makes certain daemons, like `dnsmasq`, fail to start.

Now let's connect the bridge to the physical network interface with a bind:

```ini
# /etc/systemd/network/lanbridge-bind.network
[Match]
Name=enp2s0f1

[Network]
Bridge=br0
ConfigureWithoutCarrier=true
```

Just run `systemctl restart systemd-networkd` and ensure all of your networks
are alive:

```console
$ networkctl
IDX LINK            TYPE     OPERATIONAL SETUP
  1 lo              loopback carrier     unmanaged
  2 enp2s0f0        ether    routable    configured
  4 enp2s0f1        ether    enslaved    configured
  5 br0             bridge   routable    configured
```

## IPv6 time

Every ISP is a bit different with how they assign IPv6 addresses and what size
blocks they will allocate to you. I've seen where some will only give a /64,
others give a /56, and others give something in between. As for Spectrum, they
provide up to a /56 with a prefix delegation request. You may need to experiment
with a /56 first and slowly back down towards /64 to see what your ISP might do.

Let's go back to the configuration for the external interface and add our prefix delegation hint:

```ini
# /etc/systemd/networkd/wan.network
[Match]
Name=enp2s0f0

[Network]
DHCP=yes

[DHCPv6]
PrefixDelegationHint=::/56
```

When we apply this configuration, systemd-networkd will send a DHCPv6 request
with a prefix hint included.

That's half the battle. We also need a way to take a /64 block from the big /56
block and assign it to various network interfaces on our router. You can do this
manually by looking at the /56, choosing how to subnet your network, and then
manually assigning /64 blocks to each interface.

**Manually assigning subnets is not a fun task.** It gets worse when your ISP
suddenly changes the network blocks assigned to you on a whim. 😱

Luckily, systemd-networkd has built in functionality to do this for you
automatically! Let's go back to the configuration for `br0` and add a few lines:

```ini
# /etc/systemd/networkd/lanbridge.network
[Match]
Name=br0

[Network]
Address=192.168.10.1/24
ConfigureWithoutCarrier=yes

[Network]
IPv6SendRA=yes
DHCPv6PrefixDelegation=yes
```

Run `systemctl restart systemd-networkd` to apply the changes. You should see an
IPv6 network assigned to the interface! 🎉

The `IPv6SendRA` option tells systemd-networkd to automatically announce the
network block on the interface so that computers on the network will
automatically assign their own addresses via SLAAC. (You can retire `radvd` if
you used this in the past.)

Setting `DHCPv6PrefixDelegation` to yes will automatically pull a subnet from
the prefix we asked for on the external network interface and add it to this
interface (`br0` in this case). There's no need to calculate subnets, manage
configurations, or deal with changes. It all happens automatically.

If you have other interfaces, such as VLANs, simply add the `IPv6SendRA` and
`DHCPv6PrefixDelegation` options to their network configurations (the `.network`
files, not the `.netdev` files), and apply the configuration.

*Photo credit: [tian kuan on Unsplash](https://unsplash.com/photos/9AxFJaNySB8)*
