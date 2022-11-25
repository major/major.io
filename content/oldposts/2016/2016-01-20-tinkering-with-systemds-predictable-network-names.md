---
title: Tinkering with systemd’s predictable network names
author: Major Hayden
date: 2016-01-20T19:46:52+00:00
url: /2016/01/20/tinkering-with-systemds-predictable-network-names/
medium_post:
  - 'O:11:"Medium_Post":9:{s:16:"author_image_url";N;s:10:"author_url";N;s:10:"cross_link";s:3:"yes";s:2:"id";N;s:21:"follower_notification";s:3:"yes";s:7:"license";s:11:"cc-40-by-sa";s:14:"publication_id";s:2:"-1";s:6:"status";s:4:"none";s:3:"url";N;}'
dsq_thread_id:
  - 4508553545
tags:
  - command line
  - fedora
  - hardware
  - networking
  - supermicro
  - systemd
  - systemd-networkd
  - udev

---
<a href="/wp-content/uploads/2016/01/461574071_5d79d1a951_o-e1453319191847.jpg" rel="attachment wp-att-6042"><img src="/wp-content/uploads/2016/01/461574071_5d79d1a951_o-e1453319191847.jpg" alt="Tinkering Tools" class="aligncenter size-full wp-image-6042" /></a>

I've talked about [predictable network names][1] (and [seemingly unpredictable ones][2]) on the blog before, but some readers asked me how they could alter the network naming to fit a particular situation. Oddly enough, my [Supermicro 5028D-T4NT][3] has a problem with predictable names and it's a great example to use here.

## The problem

There's plenty of detail in my post about [the Supermicro 5028D-T4NT][3], but the basic gist is that something within the firmware is causing the all of the network cards in the server to show up as onboard. The server has two 1Gb network interfaces which show up as `eno1` and `eno2`, which makes sense. It also has two 10Gb network interfaces that systemd tries to name `eno1` and `eno2` as well. That's obviously not going to work, so they get renamed to `eth0` and `eth1`.

You can see what udev thinks in this output:

```
P: /devices/pci0000:00/0000:00:02.2/0000:03:00.0/net/eth0
E: DEVPATH=/devices/pci0000:00/0000:00:02.2/0000:03:00.0/net/eth0
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=Ethernet Connection X552/X557-AT 10GBASE-T
E: ID_MODEL_ID=0x15ad
E: ID_NET_DRIVER=ixgbe
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME=eno1
E: ID_NET_NAME_MAC=enx0cc47a7591c8
E: ID_NET_NAME_ONBOARD=eno1
E: ID_NET_NAME_PATH=enp3s0f0
E: ID_OUI_FROM_DATABASE=Super Micro Computer, Inc.
E: ID_PATH=pci-0000:03:00.0
E: ID_PATH_TAG=pci-0000_03_00_0
E: ID_PCI_CLASS_FROM_DATABASE=Network controller
E: ID_PCI_SUBCLASS_FROM_DATABASE=Ethernet controller
E: ID_VENDOR_FROM_DATABASE=Intel Corporation
E: ID_VENDOR_ID=0x8086
E: IFINDEX=4
E: INTERFACE=eth0
E: SUBSYSTEM=net
E: SYSTEMD_ALIAS=/sys/subsystem/net/devices/eno1
E: TAGS=:systemd:
E: USEC_INITIALIZED=7449982
```


The `ID_NET_NAME_ONBOARD` takes precedence, but the `eno1` name is already in use at this point since udev has chosen names for the onboard 1Gb network interfaces already. Instead of falling back to `ID_NET_NAME_PATH`, it falls back to plain old `eth0`. This is confusing and less than ideal.

After a discussion in a [Github issue][4], it seems that the firmware is to blame. Don't worry - we still have some tricks we can do with systemd-networkd.

## Workaround

Another handy systemd-networkd feature is a [link][5] file. These files allow you to apply some network configurations to various interfaces. You can manage multiple interfaces with a single file with wildcards in the `[Match]` section.

In my case, I want to find any network interfaces that use the `ixgbe` driver (my 10Gb network interfaces) and apply a configuration change only to those interfaces. My goal is to get the system to name the interfaces using `ID_NET_NAME_PATH`, which would cause them to appear as `enp3s0f0` and `enp3s0f1`.

Let's create a link file to handle our quirky hardware:

```
# /etc/systemd/network/10gb-quirks.link
[Match]
Driver=ixgbe

[Link]
NamePolicy=path
```


This file tells systemd to find any devices using the `ixgbe` driver and force them to use their PCI device path for the naming. After a reboot, the interfaces look like this:

```
# networkctl  |grep ether
  2 eno1             ether              degraded    configured
  4 eno2             ether              off         unmanaged
  9 enp3s0f0         ether              off         unmanaged
 10 enp3s0f1         ether              off         unmanaged
```


Awesome! They're now named based on their PCI path and that should remain true even through future upgrades. There are plenty of other tricks that you can do with [link][5] files, including completely custom naming for any interface.

## Caveats

As Sylvain noted in the comments below, systemd-networkd provides a default `99-default.link` file that specifies how links should be handled. If you make a link file that sorts after that file, such as `ixgbe-quirks.link`, it won't take effect. Be sure that your link file comes first by starting it off with a number less than 99. This is why my `10gb-quirks.link` file works in my example above.

_Photo Credit: [realblades][6] via [Compfight][7] [cc][8]_

 [1]: /2015/08/21/understanding-systemds-predictable-network-device-names/
 [2]: https://major.io/2014/08/06/unexpected-predictable-network-naming-systemd/
 [3]: /2015/09/28/first-thoughts-linux-on-the-supermicro-5028d-t4nt/
 [4]: https://github.com/systemd/systemd/issues/1390
 [5]: http://www.freedesktop.org/software/systemd/man/systemd.link.html
 [6]: https://www.flickr.com/photos/7819308@N05/461574071/
 [7]: http://compfight.com
 [8]: https://creativecommons.org/licenses/by-sa/2.0/
