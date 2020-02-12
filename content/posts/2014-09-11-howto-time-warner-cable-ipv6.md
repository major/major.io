---
title: 'HOWTO: Time Warner Cable and IPv6'
author: Major Hayden
type: post
date: 2014-09-11T14:43:03+00:00
url: /2014/09/11/howto-time-warner-cable-ipv6/
dsq_thread_id:
  - 3642807746
categories:
  - Blog Posts
tags:
  - fedora
  - ipv6
  - mikrotik
  - network
  - networking

---
[<img src="/wp-content/uploads/2014/09/logo-top-251x300.png" alt="IPv6 world launch logo" width="251" height="300" class="alignright size-medium wp-image-5211" srcset="/wp-content/uploads/2014/09/logo-top-251x300.png 251w, /wp-content/uploads/2014/09/logo-top.png 324w" sizes="(max-width: 251px) 100vw, 251px" />][1]

Time Warner has [gradually rolled][2] out [IPv6 connectivity][3] to their Road Runner customers over the past couple of years and it started appearing on my home network earlier this year.  I had some issues getting the leases to renew properly after they expired (TWC's default lease length appears to be seven days) and there were some routing problems that cropped up occasionally.  However, over the past month, things seem to have settled down on TWC's San Antonio network.

### Do you have IPv6 yet?

Before you make any adjustments to your network, I'd recommend connecting your computer directly to the cable modem briefly to see if you can get an IPv6 address via [stateless autoconfiguration][4] (SLAAC).  You'll only get one IPv6 address via SLAAC, but we can get a bigger network block later on (keep reading).  Check your computer's network status to see if you received an IPv6 address.  If you have one, try accessing [ipv6.google.com][5].  You can always check [ipv6.icanhazip.com][6] or [ipv6.icanhaztraceroute.com][7] as well.

There's a chance your computer didn't get an IPv6 address while directly connected to the cable modem.  Here are some possible solutions:

* Power off the cable modem for 30 seconds, then plug it back in and see if your computer gets an address
* Ensure you have one of TWC's [approved modems][8]. _(Bear in mind that not all of these modems support IPv6.)_
* Verify that your computer has IPv6 enabled. _(Instructions for [Windows][9], [Mac][10] and [Linux][11] are available.)_

### But I want more addresses

If you were able to get an IPv6 address, it's now time to allocate a network block for yourself and begin using it!  We will request an allocation via [DHCPv6][12].  Every router is a little different, but the overall concept is the same.  Your router will request an allocation on the network and receive that allocation from Time Warner's network.  From there, your router will assign that block to an interface (most likely your LAN, more on that in a moment) and begin handing our IPv6 addresses to devices in your home.

By default, TWC hands out [/64 allocations][13] regardless of what you request via DHCPv6.  <del datetime="2015-03-03T20:49:50+00:00">I had some success in late 2013 when I requested a /56 but it appears that allocations of that size aren't available any longer.  Sure, a /64 allocation is gigantic (bigger than the entire IPv4 address space), but getting a /56 would allow you to assign multiple /64 allocations to different interfaces.</del> **See the last section of this post on how to get a /56 allocation.**  Splitting /64's into smaller subnets is a bad idea.

### Let's talk security

IPv6 eliminates the need for [network address translation][14] (NAT).  This means that by the time you finish this howto, each device in your network with have a publicly accessible internet address.  Also, bear in mind that with almost all network devices, firewall rules and ACL's that are configured with IPv4 will have no effect on IPv6.  This means that you'll end up with devices on your network with all of their ports exposed to the internet.

In Linux, be sure to use [ip6tables][15] (via [firewalld][16], if applicable).  For other network devices, review their firewall configuration settings to see how you can filter IPv6 traffic.  **This is a critical step.  Please don't skip it.**

On my Mikrotik device, I have a separate IPv6 firewall interface that I can configure.  Here is my default ruleset:

```
/ipv6 firewall filter
/ipv6 firewall filter
add chain=input connection-state=related
add chain=input connection-state=established
add chain=forward connection-state=established
add chain=input in-interface=lanbridge
add chain=forward connection-state=related
add chain=input dst-port=546 protocol=udp
add chain=input protocol=icmpv6
add chain=forward protocol=icmpv6
add chain=forward out-interface=ether1-gateway
add action=drop chain=input
add action=drop chain=forward
```


The first five rules ensure that only related or established connections can make it to my internal LAN. I allow UDP 546 for DHCPv6 connectivity and I'm allowing all ICMPv6 traffic to the router and internal devices. Finally, I allow all of my devices inside the network to talk to the internet and block the remainder of the unmatched traffic.

### Configuring the router

It's no secret that I'm a big fan of [Mikrotik][17] devices and I'll guide you through the setup of IPv6 on the Mikrotik in this post.  **Before starting this step, ensure that your firewall is configured (see previous section).**

On the Mikrotik, just add a simple DHCPv6 configuration. I'll call mine 'twc':

```
/ipv6 dhcp-client
add add-default-route=yes interface=ether1-gateway pool-name=twc
```


After that, you should see an allocation pop up within a few seconds (run `ipv6 dhcp-client print`):

```
#    INTERFACE     STATUS        PREFIX                                      EXPIRES-AFTER
0    ether1-gat... bound         2605:xxxx:xxxx:xxxx::/64                    6d9h15m45s
```


Check that a new address pool was allocated by running `ipv6 pool print`:

```
#   NAME      PREFIX                                      PREFIX-LENGTH EXPIRES-AFTER
0 D twc       2605:xxxx:xxxx:xxxx::/64                               64 6d9h13m33s
```


You can now assign that address pool to an interface. Be sure to assign the block to your LAN interface. In my case, that's called _lanbridge_:

```
/ipv6 address
add address=2605:xxxx:xxxx:xxxx:: from-pool=twc interface=lanbridge
```


By default, the Mikrotik device will now begin announcing that network allocation on your internal network. Some of your devices may already be picking up IPv6 addresses via SLAAC! Try accessing the Google or icanhazip IPv6 addresses from earlier in the post.

Checking a Linux machine for IPv6 connectivity is easy. Here's an example from a Fedora 20 server I have at home:

```
$ ip -6 addr
2: em1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qlen 1000
    inet6 2605:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx/64 scope global mngtmpaddr dynamic
       valid_lft 2591998sec preferred_lft 604798sec
    inet6 2605:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx/64 scope global deprecated mngtmpaddr dynamic
       valid_lft 1871064sec preferred_lft 0sec
```


If you only see an address that starts with _fe80_, that's your [link local][18] address. It's not an address that can be accessed from the internet.

### Troubleshooting

If you run into some problems or your router can't pull an allocation via DHCPv6, try the troubleshooting steps from the first section of this post.

Getting assistance from Time Warner is a real challenge. Everyone I've contacted via phone or Twitter has not been able to help and many of them don't even know what IPv6 is. I was even told "we have plenty of regular IPv4 addresses left, don't worry" when I asked for help. Even my unusual methods haven't worked:

<blockquote class="twitter-tweet tw-align-center" width="500">
  <p>
    <a href="https://twitter.com/TWC_Help">@TWC_Help</a> I'll buy one of your engineers a six pack of beer if they can enable IPv6 for my internet connection. ;)
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/498189483825983488">August 9, 2014</a>
  </p>
</blockquote>



My old [SBG6580][19] that was issued by Time Warner wouldn't ever do IPv6 reliably. I ended up buying a [SB6121][20] and I was able to get IPv6 connectivity fairly easily. The SB6121 only does 172mb/sec down - I'll be upgrading it if [TWC MAXX][21] shows up in San Antonio.

### Get a /56

You can get a /56 block of IP addresses from Time Warner by adding `prefix-hint=::/56` onto your IPv6 dhcp client configuration. You'll need to carve out some /64 subnets on your own for your internal network and that's outside the scope of this post. The prefix hint configuration isn't available in the graphical interface or on the web (at the time of this post's writing).

 [1]: /wp-content/uploads/2014/09/logo-top.png
 [2]: http://www.twcableuntangled.com/2014/03/what-is-ipv6-twc-upgrades-the-internet/
 [3]: https://en.wikipedia.org/wiki/IPv6
 [4]: https://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_.28SLAAC.29
 [5]: http://ipv6.google.com/
 [6]: http://ipv6.icanhazip.com
 [7]: http://ipv6.icanhaztraceroute.com
 [8]: http://www.timewarnercable.com/en/support/internet/topics/buy-your-modem.html
 [9]: http://windows.microsoft.com/en-us/windows/ipv6-faq
 [10]: http://support.apple.com/kb/HT4667
 [11]: http://www.linux.com/learn/tutorials/428331-ipv6-crash-course-for-linux
 [12]: https://en.wikipedia.org/wiki/DHCPv6
 [13]: https://en.wikipedia.org/wiki/IPv6_subnetting_reference
 [14]: https://en.wikipedia.org/wiki/Network_address_translation
 [15]: http://ipset.netfilter.org/ip6tables.man.html
 [16]: https://fedoraproject.org/wiki/FirewallD
 [17]: https://www.roc-noc.com/Mikrotik-Desktop-Routers/
 [18]: https://en.wikipedia.org/wiki/Link-local_address
 [19]: http://www.timewarnercable.com/en/residential-home/support/faqs/faqs-equipment-and-instruction-manuals/modems/motorola/motorola-surfboard-sbg6580.html
 [20]: http://www.newegg.com/Product/Product.aspx?Item=N82E16825122015
 [21]: http://www.timewarnercable.com/en/about-us/press/time-warner-cable-begins-twc-maxx-transformation-in-austin-area-.html
