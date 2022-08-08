---
title: 'First thoughts: Linux on the Supermicro 5028D-TN4T'
author: Major Hayden
date: 2015-09-28T12:55:51+00:00
url: /2015/09/28/first-thoughts-linux-on-the-supermicro-5028d-t4nt/
tags:
  - fedora
  - linux
  - networking
  - supermicro
  - systemd

---
I've recently moved over to Rackspace's OpenStack Private Cloud team and the role is full of some great challenges. One of those challenges was figuring out a home lab for testing.

## The search

My first idea was to pick up some lower-power machines that would give me some infrastructure at a low price with a low power bill as well. I found some Dell Optiplex 3020's on Newegg with Haswell i3's that came in at a good price point. In addition, they delivered the virtualization extensions that I needed without a high TDP.

Once I started talking about my search on Twitter, someone piped in with a suggestion:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p lang="en" dir="ltr">
    <a href="https://twitter.com/majorhayden">@majorhayden</a> what are you planning? If you have to replace any server, take a look into this <a href="http://t.co/W6dcDqow5l">http://t.co/W6dcDqow5l</a> I'd love to own one !!
  </p>

  <p>
    &mdash; Sergio Galvan (@sgmac) <a href="https://twitter.com/sgmac/status/645083591798423552">September 19, 2015</a>
  </p>
</blockquote>

![1]

Supermicro, eh? I've had great success with two Supermicro boxes from Silicon Mechanics (and I can't say enough good things about both companies) in my colocation environment. I decided to take a closer look at the [Supermicro 5028D-TN4T][2].

There's a great review on [AnandTech][3] about the Supermicro 5028D-TN4T. It gets plenty of praise for packing a lot of advanced features into a small, energy-efficient server. AnandTech found that the [idle power draw was around 30 watts][4] and as low as 27 watts in some cases. I haven't tested it with my [Kill A Watt][5] yet, but I intend to do so later this week.

## Initial thoughts

This chassis is **small**. I snapped a quick photo for some folks who were asking about it on Twitter:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p lang="en" dir="ltr">
    <a href="https://twitter.com/claco">@claco</a> <a href="https://twitter.com/sgmac">@sgmac</a> Relatively small. That's an X1 Carbon in the background as a side reference. <a href="http://t.co/EJ8ef6wl1d">pic.twitter.com/EJ8ef6wl1d</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/647546895976370176">September 25, 2015</a>
  </p>
</blockquote>



I'll have better pictures soon in a more detailed review. If you're itching for more photos now, head on over to the AnandTech article I mentioned earlier.

Installing the RAM was a piece of cake, but I did need to hold a fan shroud out of the way as I installed some of them. There are three spots for installing SSD drives: one for an M.2 SATA drive and two 2.5&#8243; drive spots. Routing the cables to the SSD drives is quite easy, but you will have to clip a zip tie or two (_carefully_).

The IPMI is fantastic, as expected. If you've ever used other Supermicro servers with built-in IPMI, then you'll recognize the interface. You have full control over power, fans, and serial output. In addition, the standard iKVM interface is there so you can view the graphical console remotely, attach disks over the network, and power cycle the server. The IPMI was configured to use DHCP out of the box.

The fan noise is a bit higher than I'd like during boot, but it's nothing like your average 1U/2U server. It's louder than my Optiplex 3020 (which is whisper silent) but much quieter than the ASA 5520. The system is very quiet once it finishes booting and it settles down.

## Linux fun

As expected, everything worked fine in Linux - except the 10Gb interfaces. It has a X557 controller for the dual 10Gb interfaces:

```
# lspci | grep Eth
03:00.0 Ethernet controller: Intel Corporation Ethernet Connection X552/X557-AT 10GBASE-T
03:00.1 Ethernet controller: Intel Corporation Ethernet Connection X552/X557-AT 10GBASE-T
05:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
05:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
```


The downside here is that the X557 PHY ID wasn't [added until Linux 4.2][6]. However, I upgraded the server from Fedora 22 to 23 (and picked up Linux 4.2.1 along the way), and everything worked.

The onboard 1Gb interfaces showed up as `eno1` and `eno2`, as expected, but the 10Gb cards showed up as `eth0` and `eth1`. If you've read my post on [systemd's predictable interface named][7], you'll notice this is a little unpredictable. The 10Gb interfaces seem to come up as `eno1` and `eno2` in udev, but that won't work since the onboard I350 ethernet ports already use those names:

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


I [opened up a Github issue for systemd][8] and it's getting some attention. We'll hopefully see it fixed soon.

## More to come

Keep an eye out for a more detailed review once I start throwing some OpenStack workloads on the Supermicro server. I'll also take some more detailed photos and share the additional parts I added to my server.

 [1]: /wp-content/uploads/2015/09/SYS-5028D-TN4T_open.jpg
 [2]: http://www.supermicro.com/products/system/midtower/5028/sys-5028d-tn4t.cfm
 [3]: http://www.anandtech.com/show/9185/intel-xeon-d-review-performance-per-watt-server-soc-champion/3
 [4]: http://www.anandtech.com/show/9185/intel-xeon-d-review-performance-per-watt-server-soc-champion/15
 [5]: http://www.p3international.com/products/p4400.html
 [6]: https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=c2c78d5c35e4f4a9226360bc432dc81b47f163e4
 [7]: /2015/08/21/understanding-systemds-predictable-network-device-names/
 [8]: https://github.com/systemd/systemd/issues/1390
