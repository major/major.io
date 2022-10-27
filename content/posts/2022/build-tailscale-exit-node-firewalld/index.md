---
author: Major Hayden
date: '2022-10-27'
summary: >-
  Tailscale exit nodes allow you to route your traffic through nearly any system in your
  tailnet. Learn how to build an exit node using firewalld. 🕳️
cover: cover.jpg
tags:
  - centos
  - cloud
  - firewalld
  - linux
  - networking
  - rhel
  - tailscale
title: Build a Tailscale exit node with firewalld
---

{{< figure 
    src="cover.jpg"
    alt="View through abandoned cement pipes on a plain" 
    caption="Photo credit: [Patrick Hendry](https://unsplash.com/photos/Tv5lpMsuvoI)"
    >}}

Once upon a time, I spent hours and hours fumbling through openvpn configurations, certificates, and firewalls to get VPNs working between servers.
One small configuration error led to lots of debugging.
Adding new servers meant wallowing through this process all over again.

A friend told me about [Tailscale] and it makes private networking incredibly simple.

Tailscale makes it easy to add nodes to a private network called a _tailnet_ where they can communicate.
In short, it's a dead simple mesh network (with advanced capabilities if you're interested).

This post covers how to create an exit node for your Tailscale network using firewalld Fedora, CentOS Stream, and Red Hat Enterprise Linux (RHEL).

[Tailscale]: https://tailscale.com/

# What's an exit node?

Every node on a Tailscale network, or _tailnet_, can communicate with each other[^acl].
However, it can use be useful to use one of those nodes on the network as an exit node.

Exit nodes allow traffic to leave the tailnet and go out to other networks or the public internet.
This allows you to join an untrusted network, such as a coffee shop's wifi network, and send your traffic out through one of your tailnet nodes.
It works more like a traditional VPN.

Tailscale does this by changing the routes on your device to use the exit node on your tailnet for all traffic.
Creating an exit node involves some configuration on the node itself and within Tailscale's administrative interface.

[^acl]: Tailscale offers complex access control lists (ACLs) that allow you to limit connectivity based on tons of factors.

# Deploy Tailscale

In this example, I'll use Fedora 36, but these instructions work for CentOS Stream and RHEL, too.

Start by installing Tailscale on your system:

* [Fedora](https://tailscale.com/download/linux/fedora)
* [CentOS Stream](https://tailscale.com/download/linux/centos-stream-9)
* [RHEL](https://tailscale.com/download/linux/rhel-9)

Let's get this going on Fedora:

```console
$ sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
Adding repo from: https://pkgs.tailscale.com/stable/fedora/tailscale.repo
$ sudo dnf install tailscale
$ sudo systemctl enable --now tailscaled
$ sudo tailscale up

To authenticate, visit:

	https://login.tailscale.com/a/xxxxxx
```

Click the link to authorize the node to join your tailnet and it should appear in your list of nodes!

# Trusting the tailnet

In my case, I treat my tailnet interfaces as trusted interfaces on each node.
_(This might not fit your use case, so please read the docs on [Network access controls (ACLs)] if you need extra security layers.)_

Start by adding the new `tailscale0` interface as a trusted interface:

```console
# firewall-cmd --add-interface=tailscale0 --zone=trusted
success
# firewall-cmd --list-all --zone=trusted
trusted (active)
  target: ACCEPT
  icmp-block-inversion: no
  interfaces: tailscale0
  sources: 
  services: 
  ports: 
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

This permits all traffic in and out of the tailscale interface.

# Creating an exit node

Let's reconfigure tailscale to allow this node to serve as an exit node:

```console
# tailscale up --advertise-exit-node
Warning: IP forwarding is disabled, subnet routing/exit nodes will not work.
See https://tailscale.com/kb/1104/enable-ip-forwarding/
```

Uh oh.
Tailscale is telling us that it's happy to reconfigure itself, but we're going to run into IP forwarding issues.
Let's see what our primary firewall zone has:

```console
# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources: 
  services: dhcpv6-client mdns ssh
  ports: 
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

We can enable masquerading in firewalld and it will take care of everything for us, including NAT rules and `sysctl` settings for IP forwarding.

```console
# firewall-cmd --add-masquerade --zone=public
success
# firewall-cmd --list-all | grep masq
  masquerade: yes
```

Let's try the Tailscale reconfiguration once more:

```console
# tailscale up --advertise-exit-node
Warning: IPv6 forwarding is disabled.
Subnet routes and exit nodes may not work correctly.
See https://tailscale.com/kb/1104/enable-ip-forwarding/
```

We fixed the IPv4 forwarding, but IPv6 is still not configured properly.
This was done automatically in the past, but firewalld [does not automatically enable IPv6 forwarding] in recent versions.
[Rich rules] come to the rescue:

```console
# firewall-cmd --add-rich-rule='rule family=ipv6 masquerade'
success
# sysctl -a | grep net.ipv6.conf.all.forwarding
net.ipv6.conf.all.forwarding = 1
```

One more try:

```console
# tailscale up --advertise-exit-node
```

Success!
But wait, we still can't send traffic through the exit node until we authorize it in the Tailscale admin interface:

1. Go back to your [machines list] at Tailscale and find your exit node.
2. Right underneath the name of the node, you should see **Exit Node** followed by a circle with an exclamation point.
3. Click the three dots on the far right of that row and click **Edit Route Settings...**.
4. When the modal appears, click the slider to the left of **Use as exit node**.

Now you can test your exit node from your mobile device by choosing an exit node via the settings menu.
Another Linux machine can use it as an exit node as well just by running another `tailscale up` command:

```shell
# Start using an exit node.
sudo tailscale up --exit-node my-exit-node-name

# Stop using an exit node.
sudo tailscale up --exit-node ''
```


[Network access controls (ACLs)]: https://tailscale.com/kb/1018/acls/
[does not automatically enable IPv6 forwarding]: https://github.com/firewalld/firewalld/issues/683
[Rich rules]: https://firewalld.org/documentation/man-pages/firewalld.richlanguage.html
[machines list]: https://login.tailscale.com/admin/machines