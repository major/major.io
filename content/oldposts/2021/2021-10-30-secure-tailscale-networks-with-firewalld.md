---
author: Major Hayden
date: '2021-10-30'
summary: >-
  Tailscale provides a handy private network mesh across multiple devices but it
  needs security just like any other network. 🕵
images:
- images/2021-10-30-dark-street.jpg
slug: secure-tailscale-networks-with-firewalld
tags:
- fedora
- firewalld
- linux
- networking
- security
- tailscale
title: Secure Tailscale networks with firewalld
---

{{< figure src="/images/2021-10-30-dark-street.jpg" alt="Dark street at night" position="center" >}}

Much of my daily work involves using multiple clouds and I do the same for my
personal infrastructure, too. Building mesh networks between each piece of cloud
infrastructure, my home, and my mobile phone quickly became overwhelming. That's
where [Tailscale] came in and completely changed my workflow.

## What is Tailscale?

The company claims it's "a secure network that just works" and that definition
fits well. Tailscale builds on protocols used in Wireguard to dynamically
maintain a mesh network between any number of devices. Forget about sharing
keys, managing complex IP space, and automating configuration changes. It
handles all of that for you.

Setting up Tailscale is outside of the scope of this post, but once you get
going, you can add a node to the network and access anything else running
Tailscale within your account. The free account comes with 20 devices and a
subnet router.

A subnet router allows you to install Tailscale on one device (perhaps one
device in your home) and then relay traffic to all devices on that network
through that single node. I use this on my home router and this saves me the
work of installing Tailscale on multiple devices at home.

## Even private networks need security

Tailscale does give you a private mesh network with automatically updating
encryption keys and access control lists (ACLs), but it needs to be secured like
any other private network. If an attacker gains access to any of the nodes you
have running Tailscale, then they could potentially wander throughout your
Tailscale network.

You may be tempted to trust all traffic on your Tailscale network, but a
firewall gives you one extra layer of protection so you're only exposing the
right ports to the right nodes. I wrote about the need for host firewalls (even
in the cloud) on the [Red Hat blog].

## Tailscale and firewalld

I use [firewalld] to manage my firewall configuration and to keep it consistent
for both IPv4 and IPv6 connections. You can use it to easily secure your
Tailscale network.

For those unfamiliar with firewalld, it uses zones to define what traffic should
be allowed in or out of a system. Each zone can have lots of rules assigned for
certain services, ports, sources, and destinations. You can add network
interfaces to each zone to control access.

A router has a public-facing port that goes out to the internet and an
internal-facing port that goes to the local area network (LAN). I put my
internet-facing network device in the `public` zone and I put the
internal-facing network device in the `internal` zone. Then I can allow inbound
DNS on the `internal` zone but block it in the `public` zone.

Tailscale adds a network interface called `tailscale0` by default. All of the
traffic that flows into and out of your mesh network goes through that device.
First off, decide which firewall zone you want to use for Tailscale. You could
certainly create a new zone, but I'm using `dmz` for mine.

```text
$ sudo firewall-cmd --list-all --zone=dmz
dmz
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

By default, `dmz` allows the ssh service and nothing else. If you want to expose
a web server to the Tailscale network, just add the services:

```console
$ sudo firewall-cmd --add-service=http --zone=dmz
$ sudo firewall-cmd --add-service=https --zone=dmz
```

The last step is to add the `tailscale0` interface to the `dmz` zone:

```console
$ sudo firewall-cmd --add-interface=tailscale0 --zone=dmz
```

Now we can check the zone to be sure everything is ready:

```console
$ sudo firewall-cmd --list-all --zone=dmz
dmz
  target: default
  icmp-block-inversion: no
  interfaces: tailscale0
  sources:
  services: http https ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

The last step is to save the firewall configuration to permanent storage so that
it's applied after a reboot:

```console
$ sudo firewall-cmd --runtime-to-permanent
```

Enjoy! 💻


[Tailscale]: https://tailscale.com/
[Red Hat blog]: https://www.redhat.com/en/blog/do-host-firewalls-matter-cloud-deployments
[firewalld]: https://firewalld.org/

*Photo credit: [zhang kaiyv](https://unsplash.com/photos/6HZXZOf9_4E)*
