---
author: Major Hayden
date: '2024-04-18'
summary: |
  Fedora's cloud-init package now uses dhcpcd in place of dhclient, which went end of life in 2022. 💀
tags: 
  - cloud
  - fedora
  - linux
title: cloud-init and dhcpcd
coverAlt: Lights hanging in a tree
coverCaption: |
  [Artists Eyes](https://unsplash.com/photos/a-bunch-of-lights-that-are-on-a-wall-XWYtZhn_21E) via Unsplash
---

We're all familiar with the trusty old `dhclient` on our Linux systems, but [it went end-of-life in 2022](https://github.com/isc-projects/dhcp):

```
NOTE: This software is now End-Of-Life. 4.4.3 is the final release
planned. We will continue to keep the public issue tracker and user
mailing list open.

You should read this file carefully before trying to install or use
the ISC DHCP Distribution.
```

Most Linux distributions use `dhclient` along with cloud-init for the initial dhcp request during the first part of cloud-init's work.
I set off to switch Fedora's cloud-init package to `dhcpcd` instead.

## What's new with dhcpcd?

There are some nice things about `dhcpcd` that you can find in the [GitHub repository](https://github.com/NetworkConfiguration/dhcpcd):

* Very small footprint with almost no dependencies on Fedora
* It can do DHCP and DHCPv6
* It can also be a [ZeroConf](https://en.wikipedia.org/wiki/Zeroconf) client

The project had its last release back in December 2023 and had commits as recently as this week.

## But I use NetworkManager

That's great!
A switch from `dhclient` to `dhcpcd` for cloud-init won't affect you.

When cloud-init starts, it does an initial dhcp request to get just enough networking to reach the cloud's metadata service.
This service provides all kinds of information for cloud-init, including network setup instructions and initial scripts to run.

NetworkManager doesn't start taking action until cloud-init has written the network configuration to the system.

## But I use systemd-networkd

Same as with NetworkManager, this change applies to the _very_ early boot and you won't notice a different when deploying new cloud systems.

## How can I get it right now?

If you're using a recent build of Fedora rawhide (the unstable release under development), you likely have it right now on your cloud instance.
Just run `journalctl --boot`, search for `dhcpcd`, and you should see these lines:

```
cloud-init[725]: Cloud-init v. 24.1.4 running 'init-local' at Wed, 17 Apr 2024 14:39:36 +0000. Up 6.13 seconds.
dhcpcd[727]: dhcpcd-10.0.6 starting
kernel: 8021q: 802.1Q VLAN Support v1.8
dhcpcd[730]: DUID 00:01:00:01:2d:b2:9b:a9:06:eb:18:e7:22:dd
dhcpcd[730]: eth0: IAID 18:e7:22:dd
dhcpcd[730]: eth0: soliciting a DHCP lease
dhcpcd[730]: eth0: offered 172.31.26.195 from 172.31.16.1
dhcpcd[730]: eth0: leased 172.31.26.195 for 3600 seconds
avahi-daemon[706]: Joining mDNS multicast group on interface eth0.IPv4 with address 172.31.26.195.
avahi-daemon[706]: New relevant interface eth0.IPv4 for mDNS.
avahi-daemon[706]: Registering new address record for 172.31.26.195 on eth0.IPv4.
dhcpcd[730]: eth0: adding route to 172.31.16.0/20
dhcpcd[730]: eth0: adding default route via 172.31.16.1
dhcpcd[730]: control command: /usr/sbin/dhcpcd --dumplease --ipv4only eth0
```

There's also an [update pending for Fedora 40](https://bodhi.fedoraproject.org/updates/FEDORA-2024-51d7f6b005), but it's currently held up by the beta freeze.
That should appear as an update as soon as Fedora 40 is released.

Keep in mind that if you have a system deployed already, cloud-init won't need to run again.
Updating to Fedora 40 will update your cloud-init and pull in `dhcpcd`, but it won't need to run again since your configuration is already set.