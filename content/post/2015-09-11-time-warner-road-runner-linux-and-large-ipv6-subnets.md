---
title: Time Warner Road Runner, Linux, and large IPv6 subnets
author: Major Hayden
type: post
date: 2015-09-11T21:08:44+00:00
url: /2015/09/11/time-warner-road-runner-linux-and-large-ipv6-subnets/
dsq_thread_id:
  - 4120810728
categories:
  - Blog Posts
tags:
  - fedora
  - firewall
  - ipv6
  - router
  - security

---
I've written about how to [get larger IPv6 subnets from Time Warner Cable's Road Runner service][1] on a Mikrotik router before, but I've converted to using a Linux server as my router for my home. Getting the larger /56 IPv6 subnet is a little tricky and it's not terribly well documented.

## My network

My Linux router has two bridges, _br0_ and _br1_, that handle WAN and LAN traffic respectively. This is a fairly simple configuration.

```
                +-------------------+
                |                   |
+-----------+   |                   |     +----------+
|Cable modem+---+ br0          br1  +-----+LAN switch|
+-----------+   |                   |     +----------+
                |    Linux router   |
                +-------------------+
```

Ideally, I'd like to have a single address assigned to _br0_ so that my Linux router can reach IPv6 destinations. I'd also like a /64 assigned to the _br1_ interface so that I can distribute addresses from that subnet to devices on my LAN.

## Getting DHCPv6 working

The [wide-dhcpv6][2] package provides a DHCPv6 client and also takes care of assigning some addresses for you. Installing it is easy with dnf:

```
dnf install wide-dhcpv6
```

We will create a new configuration file at `/etc/wide-dhcpv6/dhcp6c.conf`:

```
interface br0 {
 send ia-pd 1;
 send ia-na 1;
};

id-assoc na 1 {
};

id-assoc pd 1 {
 prefix ::/56 infinity;
 prefix-interface br0 {
  sla-id 1;
  sla-len 8;
 };
 prefix-interface br1 {
  sla-id 2;
  sla-len 8;
 };
 prefix-interface vlan1 {
  sla-id 3;
  sla-len 8;
 };
};
```

If this configuration file makes sense to you without explanation, I'm impressed. Let's break it up into pieces to understand it.

The first section with _interface br0_ specifies that we want to do our DHCPv6 requests on the _br0_ interface. The configuration lines inside the curly braces says we want to specify a [prefix delegation][3] (the _IA_PD_ DHCPv6 option) and we also want a stateful (SLAAC) address assigned on _br0_ (the _IA_NA_ DHCPv6 option). These are just simple flags that tell the upstream DHCPv6 server that we want to specify a particular prefix size and that we also want a single address (via SLAAC) for our external interface.

The _id-assoc na 1_ section specifies that we want to accept the default SLAAC address provided by the upstream network device.

The _id-assoc pd 1_ section gives the upstream DHCPv6 server a hint that we really want a /56 block of IPv6 addresses. The next three sections give our DHCPv6 client an idea of how we want addresses configured on our internal network devices. The three interfaces in each _prefix-interface_ section will receive a different block (noted by the _sla-id_ increasing by one each time). Also, the block size we intend to assign is a /64 (_sla-len_ is 8, which means we knock 8 bits off a /56 and end up with a /64). Don't change your _sla-id_ after you set it. That will cause the DHCPv6 client to move your /64 address blocks around to a different interface.

Still with me? This stuff is really confusing and documentation is sparse.

Start the DHCPv6 client and ensure it comes up at boot:

```
systemctl enable dhcp6c
systemctl start dhcp6c
```

Run `ip addr` and look for IPv6 blocks configured on each interface. In my case, _br0_ got a single address, and the other interfaces received unique /64's.

## Telling the LAN about IPv6

The router is working now, but we need to tell our devices on the LAN that we have some IPv6 addresses available. You have different options for this, such as dnsmasq or radvd, but we will use radvd here:

```
dnf -y install radvd
```

If you open `/etc/radvd.conf`, you'll notice a helpful comment block at the top with a great example configuration. I only want to announce IPv6 on my _br1_ interface, so I'll add this configuration block:

```
interface br1
{
  AdvSendAdvert on;
  MaxRtrAdvInterval 30;

  prefix ::/64
  {
    AdvOnLink on;
    AdvAutonomous on;
    AdvRouterAddr off;
  };
};
```

You don't actually need to specify the IPv6 prefix since radvd is smart enough to examine your interface and discover the IPv6 subnet assigned to it. This configuration says we will send router advertisements, let systems on the network choose their own addresses, and we will advertise those addresses as soon as the link comes up.

Let's start radvd and ensure it comes up at boot:

```
systemctl enable radvd
systemctl start radvd
```

Connect a machine to your LAN and you should receive an IPv6 address shortly after the link comes up!

## Troubleshooting

If you're having trouble getting an IPv6 address, double-check your iptables rules. You will need to ensure you're allowing UDP 546 into your external interface. Here are some examples you can use:

```
# If you're using firewalld
firewall-cmd --add-port=546/udp
firewall-cmd --add-port=546/udp --permanent
# If you're using bare ip6tables
ip6tables -A INPUT -p udp -m udp --dport 546 -j ACCEPT
```

 [1]: /2014/09/11/howto-time-warner-cable-ipv6/
 [2]: http://sourceforge.net/projects/wide-dhcpv6/
 [3]: https://en.wikipedia.org/wiki/Prefix_delegation
