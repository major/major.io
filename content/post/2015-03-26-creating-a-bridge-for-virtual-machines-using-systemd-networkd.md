---
title: Creating a bridge for virtual machines using systemd-networkd
author: Major Hayden
type: post
date: 2015-03-26T13:17:08+00:00
url: /2015/03/26/creating-a-bridge-for-virtual-machines-using-systemd-networkd/
dsq_thread_id:
  - 3642808072
categories:
  - Blog Posts
tags:
  - centos
  - fedora
  - network
  - red hat
  - systemd

---
There are plenty of guides out there for making ethernet bridges in Linux to support virtual machines using built-in network scripts or NetworkManager. I decided to try my hand with creating a bridge using only systemd-networkd and it was surprisingly easy.

First off, you'll need a version of systemd with networkd support. Fedora 20 and 21 will work just fine. RHEL/CentOS 7 and Arch Linux should also work. Much of the networkd support has been in systemd for quite a while, but if you're looking for fancier network settings, like bonding, you'll want at least systemd 216.

### Getting our daemons in order

Before we get started, ensure that systemd-networkd will run on a reboot and NetworkManager is disabled. We also need to make a config file director for systemd-networkd if it doesn't exist already. In addition, let's enable the caching resolver and make a symlink to systemd's `resolv.conf`:

```
systemctl enable systemd-networkd
systemctl disable NetworkManager
systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
mkdir /etc/systemd/network
```


### Configure the physical network adapter

In my case, the network adapter connected to my external network is _enp4s0_ but yours will vary. Run `ip addr` to get a list of your network cards. Let's create `/etc/systemd/network/uplink.network` and put the following in it:

```
[Match]
Name=enp4s0

[Network]
Bridge=br0
```


I'm telling systemd to look for a device called _enp4s0_ and then add it to a bridge called _br0_ that we haven't configured yet. Be sure to change _enp4s0_ to match your ethernet card.

### Make the bridge

We need to tell systemd about our new bridge network device and we also need to specify the IP configuration for it. We start by creating `/etc/systemd/network/br0.netdev` to specify the device:

```
[NetDev]
Name=br0
Kind=bridge
```


This file is fairly self-explanatory. We're telling systemd that we want a device called _br0_ that functions as an ethernet bridge. Now create `/etc/systemd/network/br0.network` to specify the IP configuration for the _br0_ interface:

```
[Match]
Name=br0

[Network]
DNS=192.168.250.1
Address=192.168.250.33/24
Gateway=192.168.250.1
```


This file tells systemd that we want to apply a simple static network configuration to _br0_ with a single IPv4 address. If you want to add additional DNS servers or IPv4/IPv6 addresses, just add more `DNS=` and `Address` lines right below the ones you see above. Yes, it's just that easy.

### Let's do this

Some folks are brave enough to stop NetworkManager and start all of the systemd services here but I prefer to reboot so that everything comes up cleanly. That will also allow you to verify that future reboots will cause the server to come back online with the right configuration. After the reboot, run `networkctl` and you'll get something like this (with color):

[<img src="/wp-content/uploads/2015/03/networkctl_screenshot.png" alt="networkctl screenshot" width="501" height="154" class="aligncenter size-full wp-image-5436" srcset="/wp-content/uploads/2015/03/networkctl_screenshot.png 501w, /wp-content/uploads/2015/03/networkctl_screenshot-300x92.png 300w" sizes="(max-width: 501px) 100vw, 501px" />][1]

Here's what's in the screenshot:

```
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 enp2s0           ether              off         unmanaged
  3 enp3s0           ether              off         unmanaged
  4 enp4s0           ether              degraded    configured
  5 enp5s0           ether              off         unmanaged
  6 br0              ether              routable    configured
  7 virbr0           ether              no-carrier  unmanaged

7 links listed.
```


My ethernet card has four ports and only _enp4s0_ is in use. It has a _degraded_ status because there is no IP address assigned to _enp4s0_. You can ignore that for now but it would be nice to see this made more clear in a future systemd release.

Look at _br0_ and you'll notice that it's _configured_ and _routable_. That's the best status you can get for an interface. You'll also see that my other ethernet devices are in the _unmanaged_ state. I could easily add more `.network` files to `/etc/systemd/network` to configure those interfaces later.

### Further reading

As usual, the [Arch Linux wiki page on systemd-networkd][2] is a phenomenal resource. There's a detailed overview of all of the available systemd-networkd configuration file options over at [systemd's documentation site][3].

 [1]: /wp-content/uploads/2015/03/networkctl_screenshot.png
 [2]: https://wiki.archlinux.org/index.php/systemd-networkd
 [3]: http://www.freedesktop.org/software/systemd/man/systemd.network.html
