---
title: Using systemd-networkd with bonding on Rackspace’s OnMetal servers
author: Major Hayden
type: post
date: 2015-08-21T14:00:46+00:00
url: /2015/08/21/using-systemd-networkd-with-bonding-on-rackspaces-onmetal-servers/
dsq_thread_id:
  - 4052546195
categories:
  - Blog Posts
tags:
  - bonding
  - command line
  - fedora
  - grub2
  - json
  - networking
  - onmetal
  - python
  - rackspace
  - systemd
  - systemd-networkd
  - udev

---
[<img src="/wp-content/uploads/2015/08/OnMetal_Graphic-300x180.png" alt="systemd-networkd with bonding on Rackspace OnMetal Servers" width="300" height="180" class="alignright size-medium wp-image-5818" srcset="/wp-content/uploads/2015/08/OnMetal_Graphic-300x180.png 300w, /wp-content/uploads/2015/08/OnMetal_Graphic.png 500w" sizes="(max-width: 300px) 100vw, 300px" />][1]I've written about [systemd-networkd][2] in the past and how easy it can be to set up new network devices and tunnels. However, the documentation on systemd-networkd with bonding is a bit lacking (but I have a [pull request pending][3] for that).

[Rackspace's OnMetal Servers][4] are a good place to test since they have bonded networks configured by default. They're also quite fast and always fun for experiments.

<!--more-->



To get started, head on over to the [Rackspace Cloud control panel][5] and build a _compute-1_ OnMetal server and choose Fedora 22 as your operating system. Once it starts pinging and you're able to log in, start following the guide below.

## Network device naming

By default, most images come with [systemd's predictable network naming][6] disabled. You can see the kernel command line adjustments here:

```
# cat /boot/extlinux.conf
TIMEOUT 1
default linux

LABEL Fedora (4.1.5-200.fc22.x86_64) 22 (Twenty Two)
      KERNEL /boot/vmlinuz-4.1.5-200.fc22.x86_64
      APPEND root=/dev/sda1 console=ttyS4,115200n8 8250.nr_uarts=5 modprobe.blacklist=mei_me net.ifnames=0 biosdevname=0 LANG=en_US.UTF-8
      initrd /boot/initramfs-4.1.5-200.fc22.x86_64.img
```


This ensures that both network devices show up as _eth0_ and _eth1_. Although it isn't my favorite way to configure a server, it does make it easier for most customers to get up an running quickly with some device names that they are familiar with from virtualized products.

We need to figure out what systemd plans to call these interfaces when we allow udev to name them predictably. The easiest method for figuring out what udev wants to call these devices is to dump the udev database and use `grep`:

```
# udevadm info -e | grep -A 9 ^P.*eth0
P: /devices/pci0000:00/0000:00:03.2/0000:08:00.0/net/eth0
E: DEVPATH=/devices/pci0000:00/0000:00:03.2/0000:08:00.0/net/eth0
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=82599ES 10-Gigabit SFI/SFP+ Network Connection (Ethernet OCP Server Adapter X520-2)
E: ID_MODEL_ID=0x10fb
E: ID_NET_DRIVER=ixgbe
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME_MAC=enxa0369f2cec90
E: ID_NET_NAME_PATH=enp8s0f0
E: ID_NET_NAME_SLOT=ens9f0
```


Look for those lines that contain `ID_NET_NAME_*`. Those tell us what udev prefers to call these network devices. The last name you see in the list is what the interface will be called. Here's what you need to look for in that output:

```
E: ID_NET_NAME_MAC=enxa0369f2cec90
E: ID_NET_NAME_PATH=enp8s0f0
E: ID_NET_NAME_SLOT=ens9f0
```


We can see that this device is in slot 0 of PCI bus 8. However, since udev is able to dig in a bit further, it decides to name the device _ens9f0_, which means:

  * Hotplug slot 9
  * Function index number 0

Udev rolls through a list of possible network names and uses the very last one as the name of the network device. Gentoo's documentation has a [nice explanation][7]. In our case, `ID_NET_NAME_SLOT` took precedence over the others since this particular device sits in a hotplug PCI-Express slot.

We can find the slot number here:

```
# lspci -v -s 08:00.00 | head -n 3
08:00.0 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
    Subsystem: Intel Corporation Ethernet OCP Server Adapter X520-2
    Physical Slot: 9
```


Although this is a bit confusing, it can be helpful in servers when parts are added, removed, or replaced. You'll always be assured that the same device in the same slot will never be renamed.

Our first ethernet device is called _ens9f0_, but what is the second device called?

```
# udevadm info -e | grep -A 9 ^P.*eth1
P: /devices/pci0000:00/0000:00:03.2/0000:08:00.1/net/eth1
E: DEVPATH=/devices/pci0000:00/0000:00:03.2/0000:08:00.1/net/eth1
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=82599ES 10-Gigabit SFI/SFP+ Network Connection (Ethernet OCP Server Adapter X520-2)
E: ID_MODEL_ID=0x10fb
E: ID_NET_DRIVER=ixgbe
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME_MAC=enxa0369f2cec91
E: ID_NET_NAME_PATH=enp8s0f1
E: ID_NET_NAME_SLOT=ens9f1
```


Now we know our ethernet devices are called _ens9f0_ and _ens9f1_. It's time to configure systemd-networkd.

## Bond interface creation

Ensure that you have a `/etc/systemd/network/` directory on your server and create the network device file:

```
# /etc/systemd/network/bond1.netdev
[NetDev]
Name=bond1
Kind=bond

[Bond]
Mode=802.3ad
TransmitHashPolicy=layer3+4
MIIMonitorSec=1s
LACPTransmitRate=fast
```


We're telling systemd-networkd that we want a new bond interface called _bond1_ configured using 802.3ad mode. (Want to geek out on 802.3ad? Check out [IEEE's PDF][8].) In addition, we specify a transmit hash policy, a monitoring frequency, and a requested rate for LACP updates.

Now that we have a device defined, we need to provide some network configuration:

```
# /etc/systemd/network/bond1.network
[Match]
Name=bond1

[Network]
VLAN=public
VLAN=servicenet
BindCarrier=ens9f0 ens9f1
```


This tells systemd-networkd that we have an interface called _bond1_ and it has two VLANs configured on it (more on that later). Also, we specify the interfaces participating in the bond. This ensures that the bond comes up and down cleanly as interfaces change state.

As one last step, we need to configure the physical interfaces themselves:

```
# /etc/systemd/network/ens9f0.network
[Match]
Name=ens9f0

[Network]
Bond=bond1
```


```
# /etc/systemd/network/ens9f1.network
[Match]
Name=ens9f1

[Network]
Bond=bond1
```


These files help systemd-networkd understand which interfaces are participating in the bond. You can get fancy here with your `[Match]` sections and use only one interface file with `ens9f*`, but I prefer to be more explicit. Check the documentation for systemd-networkd for that.

## Public network VLAN

The public network for your OnMetal server is delivered via a VLAN. Packets are tagged as VLAN 101 and you need to configure your network interface to handle that traffic. We already told systemd-networkd about our VLANs within the _bond1.network_ file, but now we need to explain the configuration for the public network VLAN.

Start by creating a network device file:

```
# /etc/systemd/network/public.netdev
[NetDev]
Name=public
Kind=vlan
MACAddress=xx:xx:xx:xx:xx:xx

[VLAN]
Id=101
```


You can get the correct MAC address from the information in your server's config drive:

```
mkdir /mnt/configdrive
mount /dev/sda2 /mnt/configdrive/
python -m json.tool /mnt/configdrive/openstack/latest/vendor_data.json
```


Look inside the _network_info_ section for _vlan0_. It will look something like this:

```
{
                "ethernet_mac_address": "xx:xx:xx:xx:xx:xx",
                "id": "vlan0",
                "type": "vlan",
                "vlan_id": 101,
                "vlan_link": "bond0"
            },
```


Take what you see in _ethernet\_mac\_address_ and use that MAC address on the `MACAddress` line in your _public.netdev_ file above. **If you skip this part, your packets won't make it onto the network.** For security reasons, the switch strictly checks to ensure that the right VLAN/IP/MAC combination is use when you communicate on the network.

Now that we have a network device, let's actually configure the network on it:

```
# /etc/systemd/network/public.network
[Match]
Name=public

[Network]
DNS=8.8.8.8
DNS=8.8.4.4

[Address]
Address=xxx.xxx.xxx.xxx/24

[Route]
Destination=0.0.0.0/0
Gateway=xxx.xxx.xxx.1
```


To get your IP address and gateway, you can use `ip addr` and `ip route`. Or, you can look in your config drive within the _networks_ section for the same data. Ensure that your IP address and gateway are configured correctly. I've used Google's default DNS servers here but you can use your own if you prefer.

## ServiceNet VLAN

Rackspace's ServiceNet is the backend network that connects you to other servers as well as other Rackspace products, like Cloud Databases and Cloud Files. We will configure this network in the same fashion, starting with the network device file:

```
# /etc/systemd/network/servicenet.netdev
[NetDev]
Name=servicenet
Kind=vlan
MACAddress=xx:xx:xx:xx:xx:xx

[VLAN]
Id=401
```


As we did before, go look in your config drive for the right MAC address to use. You'll look in the _network_info_ section again but this time you'll look for _vlan1_

Now we're ready to create the network file:

```
# /etc/systemd/network/servicenet.network
[Match]
Name=servicenet

[Network]
Address=xxx.xxx.xxx.xxx/20

[Route]
Destination=10.176.0.0/12
Gateway=10.184.0.1

[Route]
Destination=10.208.0.0/12
Gateway=10.184.0.1
```


Review your config drive json for the correct IP address and routes. Your routes will likely be the same as mine, but that can change over time.

## Enable systemd-networkd

All of our configuration files are in place, but now we need to enable systemd-networkd at boot time:

```
systemctl disable network
systemctl disable NetworkManager
systemctl enable systemd-networkd
systemctl enable systemd-resolved
```


We also need to let systemd-resolved handle our DNS resolution:

```
systemctl start systemd-resolved
rm /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```


Finally, there's one last gotcha that is only on OnMetal that needs to be removed. Comment out the second and third line in `/etc/rc.d/rc.local`:

```
#!/usr/bin/sh
#sleep 20
#/etc/init.d/network restart
exit 0
```


That's there as a workaround for some network issues that sometimes appear during first boot. We won't need it with systemd-networkd.

## Reboot

We're ready to test our new configuration! First, let's disable the forced old interface names on the kernel command line. Open `/boot/extlinux.conf` and ensure that the following two items are not in the kernel command line:

  * net.ifnames=0
  * biosdevname=0

Remove them from any kernel command lines you see and save the file. Reboot and cross your fingers.

## Checking our work

If you get pings after a reboot, you did well! If you didn't. you can use OnMetal's rescue mode to hop into a temporary OS and mount your root volume. Be sure to look inside `/var/log/messages` for signs of typos or other errors.

We can use some simple tools to review our network status:

```
# networkctl
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 bond0            ether              off         unmanaged
  3 bond1            ether              degraded    configured
  4 public           ether              routable    configured
  5 servicenet       ether              routable    configured
  6 ens9f0           ether              carrier     configured
  7 ens9f1           ether              carrier     configured
```


Don't be afraid of the _degraded_ status for _bond1_. That's there because systemd doesn't have networking configuration for the interface since we do that with our VLANs. Also, both physical network interfaces are listed as _carrier_ because they don't have network configuration, either. They're just participating in the bond.

Feel free to ignore _bond0_, too. The bonding module in the Linux kernel automatically creates the interface when it's loaded.

## Extra credit: Switch to grub2

Sure, extlinux is fine for most use cases, but I prefer something a little more powerful. Luckily, switching to grub2 is quite painless:

```
dnf -y remove syslinux-extlinux
rm -f /boot/extlinux.conf
dnf -y install grubby grub2
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-install /dev/sda
```


Simply reboot and you'll be booting with grub2!

 [1]: /wp-content/uploads/2015/08/OnMetal_Graphic.png
 [2]: /2015/03/26/creating-a-bridge-for-virtual-machines-using-systemd-networkd/
 [3]: https://github.com/systemd/systemd/pull/1001
 [4]: http://www.rackspace.com/en-us/cloud/servers/onmetal
 [5]: https://mycloud.rackspace.com/
 [6]: http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
 [7]: https://wiki.gentoo.org/wiki/Udev/Upgrade_Guide#Example_interface_IDs
 [8]: http://www.ieee802.org/3/hssg/public/apr07/frazier_01_0407.pdf
