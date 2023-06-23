---
aliases:
- /2015/09/28/customizing-systemds-network-device-names/
author: Major Hayden
date: 2015-09-29 02:08:22
tags:
- fedora
- network
- supermicro
- systemd
- udev
title: Customizing systemd’s network device names
---

![1]

Earlier today, I wrote a post about my [first thoughts on the Supermicro 5028D-T4NT server][2]. The 10Gb interfaces on the server came up with the names `eth0` and `eth1`. That wasn't what I expected. There's tons of detail on the problem in the blog post as well as the [Github issue][3].

Kay Sievers [gave a hint][4] about how to adjust the interfacing naming in a more granular way than simply disabling the predictable network names. The [documentation][5] on .link files is quite helpful. Skip to the `NamePolicy=` section under `[Link]` and look the options there.

Looking back to another post I wrote about [predictable device naming in systemd][6], we can see how these names fit. In my case, I'd like to have the network device names `enp3s0f0` and `enp3s0f1` instead of `eth0` and `eth1`.

Here's the file I created:

```ini
# cat /etc/systemd/network/10gb.link
[Match]
Driver=ixgbe

[Link]
NamePolicy=path
```


The interfaces came up with the expected names after a reboot:

```
# ip link
6: enp3s0f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 0c:c4:7a:75:91:c8 brd ff:ff:ff:ff:ff:ff
7: enp3s0f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 0c:c4:7a:75:91:c9 brd ff:ff:ff:ff:ff:ff
```


That will be my workaround until something can be fixed in the server's firmware itself or in systemd.

_Photo credit: Wikimedia Commons_

 [1]: /wp-content/uploads/2015/09/Wikimedia_Foundation_Servers-8055_17-e1443492445994.jpg
 [2]: /2015/09/28/first-thoughts-linux-on-the-supermicro-5028d-t4nt/
 [3]: https://github.com/systemd/systemd/issues/1390
 [4]: https://github.com/systemd/systemd/issues/1390#issuecomment-143860466
 [5]: http://www.freedesktop.org/software/systemd/man/systemd.link.html
 [6]: /2015/08/21/understanding-systemds-predictable-network-device-names/