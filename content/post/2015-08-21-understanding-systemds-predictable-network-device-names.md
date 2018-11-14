---
title: Understanding systemd’s predictable network device names
author: Major Hayden
type: post
date: 2015-08-21T21:15:36+00:00
url: /2015/08/21/understanding-systemds-predictable-network-device-names/
dsq_thread_id:
  - 4054862382
categories:
  - Blog Posts
tags:
  - centos
  - command line
  - fedora
  - linux
  - networking
  - systemd
  - udev

---
![1]

I talked a bit about systemd's network device name in my earlier post about [systemd-networkd and bonding][2] and I received some questions about how systemd rolls through the possible names of network devices to choose the final name. These predictable network device names [threw me a curveball last summer][3] when I couldn't figure out how the names were constructed.

Let's walk through this process.

## What's in a name?

Back in the systemd-networkd bonding post, I dug into a dual port Intel network card that showed up in a hotplug slot:

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


This udev database dump shows that it came up with a few different names for the network interface:

  * `ID_NET_NAME_MAC=enxa0369f2cec90`
  * `ID_NET_NAME_PATH=enp8s0f0`
  * `ID_NET_NAME_SLOT=ens9f0`

Where do these names come from? We can dig into systemd's source code to figure out the origin of the names and which one is selected as the final choice.

## Down the udev rabbit hole

Let's take a look at [src/udev/udev-builtin-net_id.c][4]:

```
/*
 * Predictable network interface device names based on:
 *  - firmware/bios-provided index numbers for on-board devices
 *  - firmware-provided pci-express hotplug slot index number
 *  - physical/geographical location of the hardware
 *  - the interface's MAC address
 *
 * http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames
 *
 * Two character prefixes based on the type of interface:
 *   en -- ethernet
 *   sl -- serial line IP (slip)
 *   wl -- wlan
 *   ww -- wwan
 *
 * Type of names:
 *   b&lt;number>                             -- BCMA bus core number
 *   ccw&lt;name>                             -- CCW bus group name
 *   o&lt;index>[d&lt;dev_port>]                 -- on-board device index number
 *   s&lt;slot>[f&lt;function>][d&lt;dev_port>]     -- hotplug slot index number
 *   x&lt;MAC>                                -- MAC address
 *   [P&lt;domain>]p&lt;bus>s&lt;slot>[f&lt;function>][d&lt;dev_port>]
 *                                         -- PCI geographical location
 *   [P&lt;domain>]p&lt;bus>s&lt;slot>[f&lt;function>][u&lt;port>][..][c&lt;config>][i&lt;interface>]
 *                                         -- USB port number chain
```


So here's where our names actually begin. Ethernet cards will always start with _en_, but they might be followed by a _p_ (for PCI slots), a _s_ (for hotplug PCI-E slots), and _o_ (for onboard cards). Scroll down just a bit more for some examples starting at line 56.

## Real-world examples

We already looked at the hotplug slot naming from Rackspace's OnMetal servers. They show up as _ens9f0_ and _ens9f1_. That means they're on a hotplug slot which happens to be slot 9. The function indexes are 0 and 1 (for both ports on the Intel 82599ES).

### Linux firewall with a dual-port PCI card

Here's an example of my Linux firewall at home. It's a Dell Optiplex 3020 with an Intel I350-T2 (dual port):

```
# udevadm info -e | grep -A 10 ^P.*enp1s0f1
P: /devices/pci0000:00/0000:00:01.0/0000:01:00.1/net/enp1s0f1
E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.1/net/enp1s0f1
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=I350 Gigabit Network Connection (Ethernet Server Adapter I350-T2)
E: ID_MODEL_ID=0x1521
E: ID_NET_DRIVER=igb
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME=enp1s0f1
E: ID_NET_NAME_MAC=enxa0369f6e5227
E: ID_NET_NAME_PATH=enp1s0f1
E: ID_OUI_FROM_DATABASE=Intel Corporate
```


And the output from `lspci`:

```
# lspci -s 01:00
01:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
01:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
```


This card happens to sit on PCI bus 1 (enp1), slot 0 (s0). Since it's a dual-port card, it has two function indexes (f0 and f1). That leaves me with two predictable names: _enp1s0f1_ and _enp1s0f0_.

### 1U server with four ethernet ports

Let's grab another example. Here's a SuperMicro 1U X9SCA server with four onboard PCI ethernet cards:

```
# udevadm info -e | grep -A 10 ^P.*enp2s0
P: /devices/pci0000:00/0000:00:1c.4/0000:02:00.0/net/enp2s0
E: DEVPATH=/devices/pci0000:00/0000:00:1c.4/0000:02:00.0/net/enp2s0
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=82574L Gigabit Network Connection
E: ID_MODEL_ID=0x10d3
E: ID_NET_DRIVER=e1000e
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME=enp2s0
E: ID_NET_NAME_MAC=enx00259025963a
E: ID_NET_NAME_PATH=enp2s0
E: ID_OUI_FROM_DATABASE=Super Micro Computer, Inc.
```


And here's all four ports in `lspci`:

```
# for i in `seq 2 5`; do lspci -s 0${i}:; done
02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
05:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
```


These are interesting because they're not all on the same PCI bus. They sit on buses 2-5 in slot 0. There are no function indexes here, so they're named _enp2s0_ through _enp5s0_. These aren't true _onboard_ cards, so they're named based on their locations.

### Storage server with onboard ethernet

Here's an example of a server with a true inboard ethernet card:

```
$ udevadm info -e | grep -A 11 ^P.*eno1
P: /devices/pci0000:00/0000:00:19.0/net/eno1
E: DEVPATH=/devices/pci0000:00/0000:00:19.0/net/eno1
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=Ethernet Connection I217-V
E: ID_MODEL_ID=0x153b
E: ID_NET_DRIVER=e1000e
E: ID_NET_LABEL_ONBOARD=en Onboard LAN
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME_MAC=enxe03f49b159c0
E: ID_NET_NAME_ONBOARD=eno1
E: ID_NET_NAME_PATH=enp0s25
E: ID_OUI_FROM_DATABASE=ASUSTek COMPUTER INC.
```


And the `lspci` output:

```
$ lspci -s 00:19.0
00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-V (rev 05)
```


This card has a new name showing up in udev: `ID_NET_NAME_ONBOARD`. The systemd udev code has some special handling for onboard cards because they usually sit on the main bus. The naming can get a bit ugly because that 19 would need to be converted into hex for the name.

If systemd didn't handle onboard cards differently, this card might be named something ugly like enp0s13 (since 19 in decimal becomes 13 in hex). That's really confusing.

## Picking the final name

As we've seen above, udev makes a big list of names in the udev database. However, there can only be one name in the OS when you try to use the network card.

Let's wander back into the code. this time we're going to take a look in [src/udev/net/link-config.c][5] starting at around line 403:

```c
name_policy) {
        NamePolicy *policy;

        for (policy = config->name_policy;
             !new_name && *policy != _NAMEPOLICY_INVALID; policy++) {
                switch (*policy) {
                        case NAMEPOLICY_KERNEL:
                                respect_predictable = true;
                                break;
                        case NAMEPOLICY_DATABASE:
                                new_name = udev_device_get_property_value(device, "ID_NET_NAME_FROM_DATABASE");
                                break;
                        case NAMEPOLICY_ONBOARD:
                                new_name = udev_device_get_property_value(device, "ID_NET_NAME_ONBOARD");
                                break;
                        case NAMEPOLICY_SLOT:
                                new_name = udev_device_get_property_value(device, "ID_NET_NAME_SLOT");
                                break;
                        case NAMEPOLICY_PATH:
                                new_name = udev_device_get_property_value(device, "ID_NET_NAME_PATH");
                                break;
                        case NAMEPOLICY_MAC:
                                new_name = udev_device_get_property_value(device, "ID_NET_NAME_MAC");
                                break;
                        default:
                                break;
                }
        }
}
```


If we look at the overall case statement, you can see that the first match is the one that takes precedence. Working from top to bottom, udev takes the first match of:

  * `ID_NET_NAME_FROM_DATABASE`
  * `ID_NET_NAME_ONBOARD`
  * `ID_NET_NAME_SLOT`
  * `ID_NET_NAME_PATH`
  * `ID_NET_NAME_MAC`

If we go back to our OnMetal example way at the top of the post, we can follow the logic. The udev database contained the following:

```
E: ID_NET_NAME_MAC=enxa0369f2cec90
E: ID_NET_NAME_PATH=enp8s0f0
E: ID_NET_NAME_SLOT=ens9f0
```


The udev daemon would start with `ID_NET_NAME_FROM_DATABASE`, but that doesn't exist for this card. Next, it would move to `ID_NET_NAME_ONBOARD`, but that's not present. Next comes `ID_NET_NAME_SLOT`, and we have a match! The `ID_NET_NAME_SLOT` entry has _ens9f0_ and that's the final name for the network device.

This loop also handles some special cases. The first check is to see if someone requested for udev to not use predictable naming. We saw this in the [systemd-networkd bonding post][2] when the bootloader configuration contained _net.ifnames=0_. If that kernel command line parameter is present, predictable naming logic is skipped.

Another special case is `ID_NET_NAME_FROM_DATABASE`. Those ports come from udev's internal [hardware database][6]. That file only has one item at the moment and it's for a particular Dell iDRAC network interface.

## Perplexed by hex

If the PCI slot numbers don't seem to line up, be sure to [read my post from last summer][3]. I ran into a peculiar Dell server with a dual port Intel card on PCI bus 42. The interface ended up with a name of _enp66s0f0_ and I was stumped.

The name _enp66s0f0_ seems to say that we have a card on PCI bus 66, in slot 0, with multiple function index numbers (for multiple ports). However, systemd does a conversion of PCI slot numbers into hex. That means that decimal 66 becomes 42 in hex.

Most servers won't be this complicated, but it's key to remember the hex conversion.

## Feedback

Are these systemd-related posts interesting? Let me know. I'm a huge fan of systemd and I enjoy writing about it.

_Photo credit: [University of Michigan Library][7]_

 [1]: /wp-content/uploads/2015/08/2229782090_838eaa8574_o-e1440191509854.jpg
 [2]: /2015/08/21/using-systemd-networkd-with-bonding-on-rackspaces-onmetal-servers/
 [3]: /2014/08/06/unexpected-predictable-network-naming-systemd/
 [4]: https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c
 [5]: https://github.com/systemd/systemd/blob/master/src/udev/net/link-config.c#L403
 [6]: https://github.com/systemd/systemd/blob/master/hwdb/20-net-ifname.hwdb
 [7]: https://www.flickr.com/photos/mlibrary/2229782090
