---
author: Major Hayden
categories:
- Blog Posts
date: '2021-10-11'
description: >-
    Learn how to forward ports with firewalld for IPv4 and IPv6 destinations. 🕵🏻
images:
- images/2021-10-11-subway-gates.jpg
slug: forwarding-ports-with-firewalld
tags:
- books
- reading
title: Forwarding ports with firewalld
type: post
---

{{< figure src="/images/2021-10-11-subway-gates.jpg" alt="Access gates at a subway station" position="center" >}}

I've tamed many of my complex firewall rules with [firewalld] over the years. It
allows you to divide your devices, destinations, and network interfaces into
zones. From there, you apply rules to zones. In addition, it handles all of the
difficult work on the backend with iptables and nftables.

Forwarding ports remains a tricky process in firewalld, but there are a few
different ways to work through it.

[firewalld]: https://firewalld.org/

## Using the simple syntax

The [firewall-cmd man page] shows the syntax for setting a forward port rule.
Here's a simple one for port 80 going to a device on a LAN:

```text
--add-forward-port=port=80:proto=tcp:toport=8080:toaddr=192.168.10.50
```

This line says to catch packets on port 80 and forward them to port 8080 on
192.168.10.50. You can also leave the `toaddr` off the arguments to forward the
port to the same server where the firewall is running:

```text
--add-forward-port=port=80:proto=tcp:toport=8080
```

This rule catches packets on port 80 and redirects them to port 8080 on the same
host. This could be handy for running a rootless podman container on a host
where the container doesn't have enough privileges to run on port 80.

Let's try this example on our firewall. First, I'll start a rootless podman
container on port 8080:

```console
$ podman run -d -p 8080:80 docker.io/traefik/whoami
Trying to pull docker.io/traefik/whoami:latest...
Getting image source signatures
Copying blob 69d0b1dd9140 done
Copying blob f089da391c25 done
Copying blob 65aa504e5268 done
Copying config 10d7504ea2 done
Writing manifest to image destination
Storing signatures
6e32b04c8933a6864249b20fd9aa27b8fc85c7c75f1c5b6f5f1ae76457f58c1c
```

_(The `whoami` container is a great way to hunt down networking problems with
containers or routers in front of containers.)_

Now I can try to connect with `curl` via IPv4:

```console
$ curl -4 testserver
curl: (7) Failed to connect to testserver port 80: No route to host
```

Ah, we forgot to forward the port! 🤦🏻‍♂️ Let's do that now:

```console
# firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080
success
# firewall-cmd --list-all
FedoraServer (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp1s0
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
	port=80:proto=tcp:toport=8080:toaddr=
  source-ports:
  icmp-blocks:
  rich rules:
```

And now the `curl`:

```console
➜ curl -4 testserver
Hostname: 6e32b04c8933
IP: 127.0.0.1
IP: ::1
IP: 10.0.2.100
IP: fe80::3c96:8dff:fec3:2d01
RemoteAddr: 10.0.2.100:35586
GET / HTTP/1.1
Host: testserver
User-Agent: curl/7.76.1
Accept: */*
```

And now we have the reply from the `whoami` container on port 80! Let's try IPv6:

```console
➜ curl -6 testserver
curl: (7) Failed to connect to testserver port 80: Permission denied
```

Darn! 🤔

## Investigating IPv6

As I mentioned earlier, firewalld manages iptables and nftables on the backend
for you automatically. I'm using Fedora 34, and firewalld uses nftables by
default. We need to see which rules nftables has for port 80:

```console
# nft list tables
table inet firewalld
table ip firewalld
table ip6 firewalld
# nft list table ip firewalld | grep 80
		tcp dport 80 redirect to :8080
# nft list table ip6 firewalld | grep 80
#
```

Ah, the rules for IPv6 aren't there! There's a little note in the `firewall-cmd`
man page for us:

> For IPv6 forward ports, please use the rich language.

## Time to get rich

You have two options here to get port forwarding working on both IPv4 and IPv6:

1. Use the simple syntax for IPv4 and the rich rules for IPv6
2. Use rich rules for both IPv4 and IPv6

Option 2 is my preferred one since it's consistent between both IPv4 and IPv6.
Let's start by removing our port forward rule (just run the same command as
before but replace `add` with `remove`):

```console
# firewall-cmd --remove-forward-port=port=80:proto=tcp:toport=8080
success
```

Now, let's add some rich rules:

```console
# firewall-cmd --add-rich-rule='rule family=ipv4 forward-port to-port=8080 protocol=tcp port=80'
success
# firewall-cmd --add-rich-rule='rule family=ipv6 forward-port to-port=8080 protocol=tcp port=80'
success
# firewall-cmd --list-all
FedoraServer (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp1s0
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
	rule family="ipv6" forward-port port="80" protocol="tcp" to-port="8080"
	rule family="ipv4" forward-port port="80" protocol="tcp" to-port="8080"
```

Now let's try connecting on IPv6:

```console
$ curl -6 testserver
Hostname: 6e32b04c8933
IP: 127.0.0.1
IP: ::1
IP: 10.0.2.100
IP: fe80::3c96:8dff:fec3:2d01
RemoteAddr: 10.0.2.100:35590
GET / HTTP/1.1
Host: testserver
User-Agent: curl/7.76.1
Accept: */*
```

Double check the nftables rules:

```console
# nft list table ip firewalld | grep 80
		tcp dport 80 redirect to :8080
# nft list table ip6 firewalld | grep 80
		tcp dport 80 redirect to :8080
```

And save the firewalld configuration so it persists through reboots:

```console
# firewall-cmd --runtime-to-permanent
success
```

Enjoy your freshly forwarded ports. 🎉

[firewall-cmd man page]: https://firewalld.org/documentation/man-pages/firewall-cmd.html

*Photo credit: [Eric Prouzet on Unsplash](https://unsplash.com/photos/vSKnoJZr3m8)*
