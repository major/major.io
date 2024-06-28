---
author: Major Hayden
date: '2024-06-28'
summary: |
  Redirecting local ports with iptables directly isn't too difficult,
  but can we use firewalld to get the same result? 🧱
tags: 
  - fedora
  - firewalld
  - linux
  - networking
  - security
title: Redirect local ports with firewalld
coverAlt: Night sky over New Mexico
coverCaption: |
  [Jake Weirick](https://unsplash.com/photos/silhouette-photography-of-trees-hIV2CAyCPI4) via Unsplash
---

Linux networking and firewalls give us plenty of options for redirecting traffic from one port to another.
We can allow people outside our home to reach a web server we run in our internal network.
That's called destination NAT, ot [DNAT](https://en.wikipedia.org/wiki/Network_address_translation#DNAT).

You can also redirect traffic to different ports on the same host.
For example, if you have a daemon listening on port 3000, but you want people to reach that service on port 80, you can redirect traffic from 80 to 3000 on the same host (without network address translation).

But how do we do this with [firewalld](https://firewalld.org/)? 🤔

## Old-school iptables methods

Let's say you have a service running on port 3000 and you want to expose it to other computers on your same network as port 80.
With iptables, you would typically start by enabling IP forwarding:

```console
sudo sysctl -w net.ipv4.ip_forward=1
```

Add two iptables rules to handle packets coming in from the outside as well as any locally generated packets:

```console
# Handle locally-generated packets on the same machine.
sudo iptables -t nat -A PREROUTING -s 127.0.0.1 -p tcp --dport 80 -j REDIRECT --to 3000`

# Handle packets coming from outside the current machine.
sudo iptables -t nat -A OUTPUT -s 127.0.0.1 -p tcp --dport 80 -j REDIRECT --to 3000`
```

There's a weird situation that happens on certain machines with certain network configurations where packets are not properly routed when they are destined for the local network adapter.
To fix that, set one more sysctl configuration:

```console
sudo sysctl -w net.ipv4.conf.all.route_localnet=1
```

Remember to make these sysctl configurations permanent:

```console
sudo mkdir /etc/sysctl.conf.d/
echo "net.ipv4.ip_forward=1" | sudo tee >> /etc/sysctl.conf.d/redirect.conf
echo "net.ipv4.conf.all.route_localnet" | sudo tee >> /etc/sysctl.conf.d/redirect.conf
```

## Why consider firewalld?

I like firewalld because I can manage lots of settings for different firewall zones and allow access from one zone to another.
It also allows me to put certain interfaces in trusted zones so they automatically get more access.

Another nice aspect about firewalld is that it supports iptables and nftables backends.
You don't have to think about the differences between the backends.
All of that is taken care of for you.

## Port redirections in firewalld

Let's start by checking our default firewalld zone:

```console
$ sudo firewall-cmd --list-all
FedoraServer (default, active)
  target: default
  ingress-priority: 0
  egress-priority: 0
  icmp-block-inversion: no
  interfaces: bond0 eno1 eno2
  sources: 
  services: dhcpv6-client http https
  ports: 51820/udp
  protocols: 
  forward: yes
  masquerade: yes
  forward-ports:
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

This output shows that my external network interfaces are attached to the zone and forwarding is already on in my case.
If you see `forward: no` here, just run this command:

```console
$ sudo firewall-cmd --add-forward
success
```

Now firewalld will manage your `forwarding` sysctl variables for you on these interfaces.
That's handy. 😉

Next, let's get the redirect working.
We want to take external packets on port 80 and send them to 3000: on the local machine.

```console
$ sudo firewall-cmd \
    --add-forward-port=port=80:proto=tcp:toport=3000:toaddr=127.0.0.1
success
```

In this command, we told firewalld to take 80/tcp from the outside and send it to port 3000 on the local host (127.0.0.1).
Let's double check our current configuration:

```console
$ sudo firewall-cmd --list-all
FedoraServer (default, active)
  target: default
  ingress-priority: 0
  egress-priority: 0
  icmp-block-inversion: no
  interfaces: bond0 eno1 eno2
  sources: 
  services: dhcpv6-client http https
  ports: 51820/udp
  protocols: 
  forward: yes
  masquerade: yes
  forward-ports: 
	port=80:proto=tcp:toport=3000:toaddr=127.0.0.1
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

Test a connection to port 80 with `curl` and it should redirect to the service on port 3000.

🚨 **If everything works, remember to save the firewalld configuration:**

```console
$ sudo firewall-cmd --runtime-to-permanent
success
```

## Extra credit

We can inspect the nftables rules to see the firewall rules that firewalld set for us.
The [Arch Linux nftables wiki page](https://wiki.archlinux.org/title/Nftables) is superb for looking up those commands.

If we dump the current ruleset, we see the rule we created in firewalld:

```console
$ sudo nft list ruleset
---SNIP---
chain nat_PRE_FedoraServer_allow {
        meta nfproto ipv4 tcp dport 80 dnat ip to 127.0.0.1:3000
}
---SNIP---
```