---
aliases:
- /2015/08/27/build-a-network-router-and-firewall-with-fedora-22-and-systemd-networkd/
author: Major Hayden
date: 2015-08-27 12:38:43
dsq_thread_id:
- 4071756196
tags:
- fedora
- firewall
- networking
- security
- systemd
title: Build a network router and firewall with Fedora 22 and systemd-networkd
---

_This post [originally appeared][1] on the Fedora Magazine blog._

* * *

One of my favorite features of Fedora 22 is [systemd-networkd][2] and all of the new features that came with it in recent systemd versions. The configuration files are easy to read, bridging is simple, and tunnels are resilient.

I've recently started using a small Linux server at home again as a network router and firewall. However, I used systemd-networkd this time and had some great results. Let's get started!

## Overview

Our example router in this example has two network interfaces:

* eth0: public internet connectivity
* eth1: private LAN (192.168.3.1/24)

We want machines on the private LAN to route their traffic through the router to the public internet via NAT. Also, we want clients on the LAN to get their IP addresses assigned automatically.

## Network configuration

All of the systemd-networkd configuration files live within `/etc/systemd/network` and we need to create that directory:

```
mkdir /etc/systemd/network
```

We need to write a network configuration file for our public interface that systemd-networkd can read. Open up `/etc/systemd/network/eth0.network` and write these lines:

```ini
[Match]
Name=eth0

[Network]
Address=PUBLIC_IP_ADDRESS/CIDR
Gateway=GATEWAY
DNS=8.8.8.8
DNS=8.8.4.4
IPForward=yes
```

If we break this configuration file down, we're telling systemd-networkd to apply this configuration to any devices that are called `eth0`. Also, we're specifying a public IP address and CIDR mask (like /24 or /22) so that the interface can be configured. The gateway address will be added to the routing table. We've also provided DNS servers to use with systemd-resolved (more on that later).

I added `IPForward=yes` so that systemd-networkd will automatically enable forwarding for the interface via sysctl. (That always seems to be the step I forget when I build a Linux router.)

Let's do the same for our LAN interface. Create this configuration file and store it as `/etc/systemd/network/eth1.network`:

```ini
[Match]
Name=eth1

[Network]
Address=192.168.3.1/24
IPForward=yes
```

We don't need to specify a gateway address here because this interface will be the gateway for the LAN.

## Prepare the services

If we're planning to use systemd-networkd, we need to ensure that it runs instead of traditional network scripts or NetworkManager:

```
systemctl disable network
systemctl disable NetworkManager
systemctl enable systemd-networkd
```

Also, let's be sure to use systemd-resolved to handle our `/etc/resolv.conf`:

```
systemctl enable systemd-resolved
systemctl start systemd-resolved
rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

## Reboot

We're now set to reboot! It's possible to bring up systemd-networkd without rebooting but I'd rather verify with a reboot now than get goosed with a broken network after a reboot later.

Once your router is back up, run `networkctl` and verify that you have _routable_ in the output for both interfaces:

```
[root@router ~]# networkctl
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 eth0             ether              routable    configured
  3 eth1             ether              routable    configured
```

## DHCP

Now that both network interfaces are online, we need something to tell our clients about the IP configuration they should be using. There are plenty of good options here, but I prefer [dnsmasq][3]. It has served me well over the years and it provides some handy features along with DHCP, such as DNS caching, TFTP and IPv6 router announcements.

Let's install dnsmasq and enable it at boot:

```
dnf -y install dnsmasq
systemctl enable dnsmasq
```

Open `/etc/dnsmasq.conf` in your favorite text editor and edit a few lines:

* Uncomment `dhcp-authoritative`
* This tells dnsmasq that it's the exclusive DHCP server on the network and that it should answer all requests
* Uncomment `interface=` and add `eth1` on the end (should look like `interface=eth1` when you're done)
* Most ISP's filter DHCP replies on their public networks, but we don't want to take chances here. We need to restrict DHCP to our public interface only.
* Look for the `dhcp-range` line and change it to `dhcp-range=192.168.3.50,192.168.3.150,12h`
* We're giving clients 12 hour leases on 192.168.3.0/24

Save the file and start dnsmasq:

```
systemctl start dnsmasq
```

## Firewall

We're almost done! Now it's time to tell iptables to [masquerade][4] any packets from our LAN to the internet. But wait, it's 2015 and we have tools like `firewall-cmd` to do that for us in Fedora.

Let's enable masquerading, allow DNS, and allow DHCP traffic. We can then make the state permanent:

```
firewall-cmd --add-masquerade
firewall-cmd --add-service=dns --add-service=dhcp
firewall-cmd --runtime-to-permanent
```

## Testing

Put a client machine on your LAN network and you should be able to ping some public sites from the client:

```
[root@client ~]# ping -c 4 icanhazip.com
PING icanhazip.com (104.238.141.75) 56(84) bytes of data.
64 bytes from lax.icanhazip.com (104.238.141.75): icmp_seq=1 ttl=52 time=69.8 ms
64 bytes from lax.icanhazip.com (104.238.141.75): icmp_seq=2 ttl=52 time=69.7 ms
64 bytes from lax.icanhazip.com (104.238.141.75): icmp_seq=3 ttl=52 time=69.6 ms
64 bytes from lax.icanhazip.com (104.238.141.75): icmp_seq=4 ttl=52 time=69.7 ms

--- icanhazip.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 69.659/69.758/69.874/0.203 ms
```

## Extras

If you need to adjust your network configuration, just run `systemctl restart systemd-networkd` afterwards. I've found that it's quite intelligent about the network devices and it won't reconfigure anything that hasn't changed.

The `networkctl` command is very powerful. Check out the `status` and `lldp` functions to get more information about your network devices and the networks they're connected to.

When something goes wrong, look in your systemd journal:

```
[root@router ~]# journalctl -u systemd-networkd
-- Logs begin at Fri 2015-07-31 01:22:38 UTC, end at Fri 2015-07-31 02:11:24 UTC. --
Jul 31 01:46:14 router systemd[1]: Starting Network Service...
Jul 31 01:46:14 router systemd-networkd[286]: Enumeration completed
Jul 31 01:46:14 router systemd[1]: Started Network Service.
Jul 31 01:46:15 router systemd-networkd[286]: eth1            : link configured
Jul 31 01:46:15 router systemd-networkd[286]: eth0            : gained carrier
Jul 31 01:46:15 router systemd-networkd[286]: eth0            : link configured
Jul 31 01:46:16 router systemd-networkd[286]: eth1            : gained carrier
```

 [1]: http://fedoramagazine.org/build-network-router-firewall-fedora-22-systemd-networkd/
 [2]: http://www.freedesktop.org/software/systemd/man/systemd-networkd.html
 [3]: http://www.thekelleys.org.uk/dnsmasq/doc.html
 [4]: https://en.wikipedia.org/wiki/Network_address_translation