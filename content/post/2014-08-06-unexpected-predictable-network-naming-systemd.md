---
title: Unexpected predictable network naming with systemd
author: Major Hayden
type: post
date: 2014-08-06T21:09:34+00:00
url: /2014/08/06/unexpected-predictable-network-naming-systemd/
dsq_thread_id:
  - 3642807703
categories:
  - Blog Posts
tags:
  - centos
  - debian
  - fedora
  - network
  - redhat
  - systemd

---
![1]

While using a Dell R720 at work today, we stumbled upon a problem where the [predictable network device naming with systemd][2] gave us some unpredictable results. The server has four onboard network ports (two 10GbE and two 1GbE) and an add-on 10GbE card with two additional ports.

Running _lspci_ gives this output:

```
# lspci | grep Eth
01:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
01:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
08:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
08:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
42:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
42:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
```


If you're not familiar with that output, it says:

* Two 10GbE ports on PCI bus 1 (ports 0 and 1)
* Two 1GbE ports on PCI bus 8 (ports 0 and 1)
* Two 10GbE ports on PCI bus 42 (ports 0 and 1)

When the system boots up, the devices are named based on [systemd-udevd's criteria][3]. Our devices looked like this after boot:

```
# ip addr | egrep ^[0-9]
1: lo: &lt;LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
2: enp8s0f0: &lt;BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
3: enp8s0f1: &lt;BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
4: enp1s0f0: &lt;BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
5: enp1s0f1: &lt;BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
6: enp66s0f0: &lt;BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
7: enp66s0f1: &lt;BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
```


Devices 2-5 make sense since they're on PCI buses 1 and 8. However, our two-port NIC on PCI bus 42 has suddenly been named 66. We rebooted the server with the _rd.udev.debug_ kernel command line to display debug messages from systemd-udevd during boot. That gave us this:

```
# journalctl | grep enp66s0f0
systemd-udevd[471]: renamed network interface eth0 to enp66s0f0
systemd-udevd[471]: NAME 'enp66s0f0' /usr/lib/udev/rules.d/80-net-setup-link.rules:13
systemd-udevd[471]: changing net interface name from 'eth0' to 'enp66s0f0'
systemd-udevd[471]: renamed netif to 'enp66s0f0'
systemd-udevd[471]: changed devpath to '/devices/pci0000:40/0000:40:02.0/0000:42:00.0/net/enp66s0f0'
```


So the system sees that the enp66s0f0 device is actually on PCI bus 42. What gives? A quick trip to #systemd on Freenode caused a facepalm:

```
mhayden | weird, udev shows it on pci bus 42 but yet names it 66
    jwl | 0x42 = 66
```


I didn't expect to see hex. Sure enough, converting 42 in hex to decimal yields 66:

```
$ printf "%d\n" 0x42
66
```


That also helps to explain why the devices on buses 1 and 8 were unaffected. Converting 1 and 8 in hex to decimal gives 1 and 8. If you're new to hex, this [conversion table][4] may help.

*Photo Credit: <a href="https://www.flickr.com/photos/90021863@N00/3240995967/">mindfieldz</a> via <a href="http://compfight.com">Compfight</a> <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">cc</a>*

 [1]: /wp-content/uploads/2014/08/3240995967_04d7888d5c_o-e1407359174321.jpg
 [2]: http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
 [3]: http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-net_id.c#n35
 [4]: http://ascii.cl/conversion.htm
