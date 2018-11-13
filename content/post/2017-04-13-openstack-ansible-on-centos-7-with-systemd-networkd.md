---
title: OpenStack-Ansible networking on CentOS 7 with systemd-networkd
author: Major Hayden
type: post
date: 2017-04-13T13:18:09+00:00
url: /2017/04/13/openstack-ansible-on-centos-7-with-systemd-networkd/
featured_image: /wp-content/uploads/2017/04/MaxPixel.freegreatpicture.com-Chip-Nsa-Distributor-Switch-It-Network-Ethernet-490027-e1492089463954.jpg
categories:
  - Blog Posts
tags:
  - ansible
  - linux
  - networking
  - openstack
  - systemd
  - vlan

---
[<img src="/wp-content/uploads/2017/04/MaxPixel.freegreatpicture.com-Chip-Nsa-Distributor-Switch-It-Network-Ethernet-490027-e1492089463954.jpg" alt="Ethernet switch" width="1024" height="309" class="aligncenter size-full wp-image-6693" srcset="/wp-content/uploads/2017/04/MaxPixel.freegreatpicture.com-Chip-Nsa-Distributor-Switch-It-Network-Ethernet-490027-e1492089463954.jpg 1024w, /wp-content/uploads/2017/04/MaxPixel.freegreatpicture.com-Chip-Nsa-Distributor-Switch-It-Network-Ethernet-490027-e1492089463954-300x91.jpg 300w, /wp-content/uploads/2017/04/MaxPixel.freegreatpicture.com-Chip-Nsa-Distributor-Switch-It-Network-Ethernet-490027-e1492089463954-768x232.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][1]Although OpenStack-Ansible doesn't fully support CentOS 7 yet, the support is almost ready. I have a four node Ocata cloud deployed on CentOS 7, but I decided to change things around a bit and use systemd-networkd instead of NetworkManager or the old rc scripts.

This post will explain how to configure the network for an OpenStack-Ansible cloud on CentOS 7 with systemd-networkd.

Each one of my OpenStack hosts has four network interfaces and each one has a specific task:

  * `enp2s0` - regular network interface, carries inter-host LAN traffic
  * `enp3s0` - carries `br-mgmt` bridge for LXC container communication
  * `enp4s0` - carries `br-vlan` bridge for VM public network connectivity
  * `enp5s0` - carries `br-vxlan` bridge for VM private network connectivity

## Adjusting services

First off, we need to get systemd-networkd and systemd-resolved ready to take over networking:

```
systemctl disable network
systemctl disable NetworkManager
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl start systemd-resolved
rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```


## LAN interface

My `enp2s0` network interface carries traffic between hosts and handles regular internal LAN traffic.

```
[Match]
Name=enp2s0

[Network]
Address=192.168.250.21/24
Gateway=192.168.250.1
DNS=192.168.250.1
DNS=8.8.8.8
DNS=8.8.4.4
IPForward=yes
```


This one is quite simple, but the rest get a little more complicated.

## Management bridge

The management bridge (`br-mgmt`) carries traffic between LXC containers. We start by creating the bridge device itself:

```
[NetDev]
Name=br-mgmt
Kind=bridge
```


Now we configure the network on the bridge (I use OpenStack-Ansible's defaults here):

```
[Match]
Name=br-mgmt

[Network]
Address=172.29.236.21/22
```


I run the management network on VLAN 10, so I need a network device and network configuration for the VLAN as well. This step adds the `br-mgmt` bridge to the VLAN 10 interface:

```
[NetDev]
Name=vlan10
Kind=vlan

[VLAN]
Id=10
```


```
[Match]
Name=vlan10

[Network]
Bridge=br-mgmt
```


Finally, we add the VLAN 10 interface to `enp3s0` to tie it all together:

```
[Match]
Name=enp3s0

[Network]
VLAN=vlan10
```


## Public instance connectivity

My router offers up a few different VLANs for OpenStack instances to use for their public networks. We start by creating a `br-vlan` network device and its configuration:

```
[NetDev]
Name=br-vlan
Kind=bridge
```


```
[Match]
Name=br-vlan

[Network]
DHCP=no
```


We can add this bridge onto the `enp4s0` physical interface:

```
[Match]
Name=enp4s0

[Network]
Bridge=br-vlan
```


## VXLAN private instance connectivity

This step is similar to the previous one. We start by defining our `br-vxlan` bridge:

```
[NetDev]
Name=br-vxlan
Kind=bridge
```


```
[Match]
Name=br-vxlan

[Network]
Address=172.29.240.21/22
```


My VXLAN traffic runs over VLAN 11, so we need to define that VLAN interface:

```
[NetDev]
Name=vlan11
Kind=vlan

[VLAN]
Id=11
```


```
[Match]
Name=vlan11

[Network]
Bridge=br-vxlan
```


We can hook this VLAN interface into the `enp5s0` interface now:

```
[Match]
Name=enp5s0

[Network]
VLAN=vlan11
```


## Checking our work

The cleanest way to apply all of these configurations is to reboot. The _Adjusting services_ step from the beginning of this post will ensure that systemd-networkd and systemd-resolved come up after a reboot.

Run `networkctl` to get a current status of your network interfaces:

```
# networkctl
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 enp2s0           ether              routable    configured
  3 enp3s0           ether              degraded    configured
  4 enp4s0           ether              degraded    configured
  5 enp5s0           ether              degraded    configured
  6 lxcbr0           ether              routable    unmanaged
  7 br-vxlan         ether              routable    configured
  8 br-vlan          ether              degraded    configured
  9 br-mgmt          ether              routable    configured
 10 vlan11           ether              degraded    configured
 11 vlan10           ether              degraded    configured
```


You should have `configured` in the `SETUP` column for all of the interfaces you created. Some interfaces will show as `degraded` because they are missing an IP address (which is intentional for most of these interfaces).

 [1]: /wp-content/uploads/2017/04/MaxPixel.freegreatpicture.com-Chip-Nsa-Distributor-Switch-It-Network-Ethernet-490027-e1492089463954.jpg
