---
title: Allow a port range with firewalld
author: Major Hayden
type: post
date: "2019-01-04"
slug: allow-port-range-with-firewalld
categories:
  - Blog Posts
tags:
  - fedora
  - centos
  - networking
---

Managing iptables gets a lot easier with [firewalld]. You can manage rules for
the IPv4 and IPv6 stacks using the same commands and it provides fine-grained
controls for various "zones" of network sources and destinations.

## Quick example

Here's an example of allowing an arbitrary port (for [netdata]) through the
firewall with iptables and firewalld on Fedora:

```
## iptables
iptables -A INPUT -j ACCEPT -p tcp --dport 19999
ip6tables -A INPUT -j ACCEPT -p tcp --dport 19999
service iptables save
service ip6tables save

## firewalld
firewall-cmd --add-port=19999/tcp --permanent
```

In this example, `firewall-cmd` allows us to allow a TCP port through the
firewall with a much simpler interface and the change is made permanent with
the `--permanent` argument.

You can always test a change with firewalld without making it permanent:

```
firewall-cmd --add-port=19999/tcp
## Do your testing to make sure everything works.
firewall-cmd --runtime-to-permanent
```

The `--runtime-to-permanent` argument tells firewalld to write the currently
active firewall configuration to disk.

## Adding a port range

I use [mosh] with most of my servers since it allows me to reconnect to an
existing session from anywhere in the world and it makes higher latency
connections less painful. Mosh requires a range of UDP ports (60000 to 61000)
to be opened.

We can do that easily in firewalld:

```
firewall-cmd --add-port=60000-61000/udp --permanent
```

We can also see the rule it added to the firewall:

```
# iptables-save | grep 61000
-A IN_public_allow -p udp -m udp --dport 60000:61000 -m conntrack --ctstate NEW,UNTRACKED -j ACCEPT
# ip6tables-save | grep 61000
-A IN_public_allow -p udp -m udp --dport 60000:61000 -m conntrack --ctstate NEW,UNTRACKED -j ACCEPT
```

If you haven't used firewalld yet, give it a try! There's a lot more documentation on common use cases in the [Fedora firewalld documentation].

[firewalld]: https://firewalld.org/
[netdata]: https://github.com/netdata/netdata
[mosh]: https://mosh.org/
[Fedora firewalld documentation]: https://docs.fedoraproject.org/en-US/quick-docs/firewalld/
