---
title: Adventures with GRE and IPSec on Mikrotik routers
author: Major Hayden
type: post
date: 2015-05-27T13:46:28+00:00
url: /2015/05/27/adventures-with-gre-and-ipsec-on-mikrotik-routers/
dsq_thread_id:
  - 3797893733
categories:
  - Blog Posts
tags:
  - general advice
  - ipsec
  - mikrotik
  - networking
  - security

---
![1]

I recently picked up a [RB850GX2][2] from my favorite Mikrotik retailer, [r0c-n0c][3]. It's a dual-core PowerPC board with five ethernet ports and some decent performance for the price.

I still have the RB493G in a colocation and I usually connect my home and the colo via OpenVPN or IPSec. Networking is not one of my best skills and I'm always looking to learn more about it when I can. I decided to try out a GRE tunnel on top of IPSec this time around. Combining GRE and IPSec allows you to simplify connectivity between two network segments through an encrypted tunnel.

## The Setup

The LAN in my colo and at home is fairly simple: a /24 of RFC1918 space behind a Mikrotik doing NAT. My goal was to get a tunnel up between both environments so that I could reach devices behind my colo firewall from home and vice versa. I do plenty of ssh back and forth along with backups from time to time.

In this example, here's the current network configuration:

* Home: 192.168.50.0/24 on the LAN, 1.1.1.1 as the public IP
* Colo: 192.168.150.0/24 on the LAN, 2.2.2.2 as the public IP

I want devices on 192.168.50.0/24 to talk to 192.168.150.0/24 and vice versa. Let's get the GRE tunnel up first.

## GRE

Plain GRE tunnels aren't encrypted, but I prefer to set them up first to test connectivity prior to adding IPSec into the mix. IPSec can be a challenge to configure the first time around.

I'll first create a GRE interface at home:

```
/interface gre
add !keepalive local-address=1.1.1.1 name=home-to-colo remote-address=2.2.2.2
```

We'll do the same on the colo router:

```
/interface gre
add !keepalive local-address=2.2.2.2 name=colo-to-home remote-address=1.1.1.1
```

You can check to see if the GRE tunnel is running from either router:

```
/interface gre print
```

Look for the **R** in the flags column.

If you've made it this far, you now have a GRE tunnel configured but we can't pass any traffic across it yet. We need to add some IP's to both sides and configure some routes.

## IP's and Routes

You have some freedom here to choose the IP addresses for both ends of your tunnel but don't choose anything that interferes with your current LAN IP addresses. In my case, I'll choose 10.10.10.1/30 and 10.10.10.2/30 for both ends of the tunnel.

I'll give the 10.10.10.2 address to the home firewall:

```
/ip address
add address=10.10.10.2/30 interface=home-to-colo network=10.10.10.0
```

And I'll give the 10.10.10.1 address to the colo firewall:

```
/ip address
add address=10.10.10.1/30 interface=colo-to-home network=10.10.10.0
```

At this point, systems at home can ping 10.10.10.1 (the colo router's GRE tunnel endpoint) and systems at the colo can ping 10.10.10.2 (the home router's GRE tunnel endpoint). That's great because we will use these IP's to route our LAN traffic across the tunnel.

We need to tell the home router how to get traffic from its LAN over to the colo LAN and vice versa. We can do that with the tunnel endpoints we just configured.

Let's tell the home router to use the colo router's GRE tunnel endpoint to reach the colo LAN:

```
/ip route
add distance=1 dst-address=192.168.150.0/24 gateway=home-to-colo
```

And tell the colo router to use the home router's GRE endpoint to reach the home LAN:

```
/ip route
add distance=1 dst-address=192.168.50.0/24 gateway=colo-to-home
```

We don't have to tell the router about the tunnel's IP address since those routes are generated automatically when we added the IP addresses to each side of the GRE tunnel.

If you've made it this far, systems in your home LAN should be able to ping the colo LAN and vice versa. If not, go back and double-check your IP addresses on both sides of the tunnel and your routes.

## Adding IPSec

**BEFORE YOU GO ANY FURTHER, ensure you have some sort of out-of-band access to both routers.** If you make a big mistake like I did (more on that later), you're going to be glad you set up another way to reach your devices!

We have an GRE tunnel without encryption already and that's allowing us to pass traffic. That's fine, but it's not terribly secure to send our packets in that tunnel across a hostile internet. IPSec will allow us to tell both routers that we want packets between the public IP addresses of both routers to be encrypted. The GRE tunnel will take care of actually delivering the packets, however. IPSec isn't an interface and it can't be a conduit for networking all by itself.

<strong style="color: #D42020;">Have you configured another way to access both routers yet? Seriously, stop now and do that. I mean it.</strong>

If you have native IPv6 access (not a IPv6 over IPv4 tunnel!) into each device, that can be a viable backup plan. Another option might be serial cables or a dedicated console connection. You'll thank me later.

Configuring IPSec is done in three chunks:

  * Make a proposal: both routers must agree on how to authenticate each other and encrypt traffic
  * Configure a peer list: both routers need to know how to reach each other and have some shared secrets
  * Set a policy: both routers need to agree on which packets must be encrypted

We will start with the proposal. The defaults are good for both routers. Add this configuration **on both devices**:

```
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=md5 enc-algorithms=aes-128-cbc,twofish
```

Now our routers agree on what methods they'll use to encrypt traffic. Feel free to adjust these algorithms later if needed. Let's tell each router about its peer.

At home:

```
/ip ipsec peer
add address=2.2.2.2/32 nat-traversal=no secret=letshavefunwithipsec
```

At the colo:

```
/ip ipsec peer
add address=1.1.1.1/32 nat-traversal=no secret=letshavefunwithipsec
```

Both routers now know about each other and they both have the same shared secret (please use a better shared secret in production). All we have left is configuring a policy.

At this point, ensure you're accessing both routers via an out-of-band method (native IPv6, console, serial, etc). **YOU ARE ABOUT TO LOSE CONNECTIVITY TO YOUR REMOTE DEVICE.**

At home, we set up a policy that says all traffic between the public addresses of both firewalls must be encrypted (GRE will carry the traffic for us). **Ensure that the CIDR portion of the IP address for dst-address/src-address is present!**

```
/ip ipsec policy
add dst-address=2.2.2.2/32 sa-dst-address=2.2.2.2 sa-src-address=1.1.1.1 src-address=1.1.1.1/32 tunnel=yes
```

We will do something similar on the colo side. **Again, ensure that the CIDR portion of the IP address for dst-address/src-address is present!**

```
/ip ipsec policy
add dst-address=1.1.1.1/32 sa-dst-address=1.1.1.1 sa-src-address=2.2.2.2 src-address=2.2.2.2/32 tunnel=yes
```

You should now be able to ping across your GRE tunnel but it's encrypted this time! If you find that one of your devices is inaccessible, don't panic. Disable the policy you just added (`set disabled=yes number=[number of your policy]`) and review your configuration.

In the policy step, we told both routers that if traffic moves between the _src-address_ and _dst-address_, we want it encrypted. Also, the _sa-src-address_ and _sa-dst-address_ gives the router a hint to figure out the identity of the peer and what their shared secret is.

## Checking our work

You can check your work with something like this on the home router:

```
[major@Home] > /ip ipsec remote-peers print
 0 local-address=1.1.1.1 remote-address=2.2.2.2 state=established side=initiator established=7h17m10s
```

If you have a line like that, your IPSec peers can communicate properly. To test the encryption, you have two options. One option is to put a device outside your firewall and dump traffic via a tap or hub.

Another option (albeit less accurate) is to use the profile tool built into RouterOS. Run the following:

```
/tool profile
```

You'll see some output showing where the majority of your CPU is consumed. Now, transfer some large files between systems behind both routers. You can use [iperf][4] for this as well if you really want to stress out the network link. When you do that, you should see **encrypting** in the profile output as a very large consumer of the CPU. If you only see something like **gre** or **ethernet** as your top CPU consumers, you may have missed something on your IPSec policy and your traffic is likely not being encrypted. This isn't true for all routers &#8212; it depends on your normal workloads.

## How I made a huge mistake

When I was going through this process, I made it through the GRE portion without a hitch. Everything worked well. Once I added IPSec to the mix, I used the GRE tunnel endpoints (10.10.10.1 and 10.10.10.2) as my _src-address_ and _dst-address_ in my IPSec policy. Nothing was getting encrypted and I was getting really frustrated.

I kept reading tutorials on various sites and came to realize that I didn't need an encryption policy between the tunnel endpoints, I needed a policy between the actual public addresses of the routers. I wasn't aware that the GRE tunnel would happily keep working between the two public IP addresses even with the IPSec policy in place between the IP addresses.

First mistake: I didn't access my colo router via an out-of-band path. Second mistake: I applied my IPSec policy on the home router first and was shocked that I lost connectivity to the colo router. That was a quick fix &#8212; I just disabled the IPSec policy on the home router and I could access the colo router again.

Just after adjusting the IPSec policy on the colo router to use the public IP addresses, I noticed that connectivity dropped. At this point, I expected that &#8212; I set up a policy there but I hadn't done it on the home router yet. I enabled the policy on the home router and then started pinging. Nothing.

Then came the Pingdom and UptimeRobot alerts for my sites in the colo. **Oh crap.**

![5]

Once I was able to reach the colo router via IPv6 through some other VM's, I realized what happened. I left the CIDR mask off the _src-address_ and _dst-address_ in the IPSec policy.

Guess what RouterOS chose as a CIDR mask for me? **/0.** Ouch.

I quickly adjusted those to be /32's. Within seconds, everything was up again and the GRE tunnel began working. As the Pingdom alerts cleared and my heart rate returned to normal, I figured the best thing I should do is share my story so that others don't make the same mistake. ;)

 [1]: https://major.io/wp-content/uploads/2015/05/mikrotik-routerboard-rb8_6221.jpg
 [2]: http://routerboard.com/RB850Gx2
 [3]: https://www.roc-noc.com/mikrotik/routerboard/RB850Gx2.html
 [4]: /2010/03/20/testing-network-throughput-with-iperf/
 [5]: https://major.io/wp-content/uploads/2015/05/ive-made-a-huge-mistake.gif
