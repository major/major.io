---
title: GRE tunnels with systemd-networkd
author: Major Hayden
type: post
date: 2015-10-16T23:54:52+00:00
url: /2015/10/16/gre-tunnels-with-systemd-networkd/
dsq_thread_id:
  - 4232183402
categories:
  - Blog Posts
tags:
  - command line
  - fedora
  - firewalld
  - kernel
  - networking
  - systemd
  - systemd-networkd

---
Switching to [systemd-networkd][1] for managing your networking interfaces makes things quite a bit simpler over standard networking scripts or NetworkManager. Aside from being easier to configure, it uses fewer resources on your system, which can be handy for smaller virtual machines or containers.

Managing tunnels between interfaces is also easier with systemd-networkd. This post will show you how to set up a [GRE tunnel][2] between two hosts running systemd-networkd.

## Getting started

You'll need two hosts running a recent version of systemd-networkd. I'd recommend Fedora 22 since it provides very recent versions of systemd which include enhancements to systemd-networkd.

For this example, I've built one Rackspace Cloud Server in the DFW datacenter and another in IAD. I'll connect them both together with a simple GRE tunnel.

## Switch to systemd-networkd

I've [detailed out this process before][3] but I'll do it again here. First off, we will need a directory made on both servers to hold systemd-networkd configuration files:

```
mkdir /etc/systemd/network
```

Let's add a very simple network configuration for our `eth0` interface on both hosts:

```ini
# cat /etc/systemd/network/eth0.network
[Match]
Name=eth0

[Network]
Address=x.x.x.x/24
Gateway=x.x.x.x
DNS=8.8.8.8
DNS=8.8.4.4
```

Do this on **both servers** and be sure to fill in the `Address` and `Gateway` lines with the correct data for your servers. Also, feel free to use something other than Google's DNS servers if needed.

It's time to get our services in order so that systemd-networkd will handle our networking after a reboot:

```
systemctl disable network
systemctl disable NetworkManager
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl start systemd-resolved
rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

**Don't start systemd-networkd yet.** Having systemd-networkd and NetworkManager fight over your interfaces can lead to a bad day.

Reboot both hosts and wait for them to come back online.

## Configure the GRE tunnel

A GRE tunnel is a simple way to encapsulate packets between two hosts and send almost any protocol across the tunnel you build. However, it's not encrypted. (If you're planning to use this long-term, consider only using encrypted streams across the link or add IPSec on top of the GRE tunnel.)

If we want to route traffic over the GRE tunnel, we will need IP addresses on both sides. I'll use 192.168.254.0/24 for this example, but you're free to use any subnet of any size (except /32!) for this network.

We need to tell systemd-networkd about a new network device that it doesn't know about. We do this with `.netdev` files. Create this file on both hosts:

```ini
# cat /etc/systemd/network/gre-example.netdev
[NetDev]
Name=gre-example
Kind=gre
MTUBytes=1480

[Tunnel]
Remote=[public ip of remote server]
Local=[public ip of local server]
```

We're making a new network device called `gre-example` here and we're telling systemd-networkd about the servers participating in the link. Add this configuration file to **both hosts** but be sure that your `Remote=` line is correct. If you're writing the configuration file for the **first** host, then the `Remote=` line should have the IP address of your **second** host. Do the same thing on the second host, but use the IP address of your first host there.

Now that we have a network device, we need to tell systemd-networkd how to configure the IP address on these new GRE tunnels. Let's make a `.network` file for our GRE tunnel.

On the first host:

```ini
# cat /etc/systemd/network/gre-example.network
[Match]
Name=gre-example

[Network]
Address=192.168.254.1/24
```

On the second host:

```ini
# cat /etc/systemd/network/gre-example.network
[Match]
Name=gre-example

[Network]
Address=192.168.254.2/24
```

## Bringing up the tunnel

Although systemd-networkd knows we have a tunnel configured now, it's not sure which interface should manage the tunnel. In our case, our public interface (`eth0`) is required to be up for this tunnel to function. Go back to your original `eth0.network` files and add one line under the `[Network]` section for our tunnel:

```ini
[Network]
Tunnel=gre-example
```

Restart systemd-networkd on **both hosts** and check the network interfaces:

```
# systemctl restart systemd-networkd
# networkctl
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 eth0             ether              routable    configured
  3 eth1             ether              off         unmanaged
  4 gre0             ipgre              off         unmanaged
  5 gretap0          ether              off         unmanaged
  6 gre-example      ipgre              routable    configured

6 links listed.
```

Hooray! Our GRE tunnel is up! However, we have a firewall in the way.

## Fixing the firewall

We need to tell the firewall two things: trust the GRE interface and trust the public IP of the other server. Trusting the GRE interface is easy with firewalld &#8212; just add this on both hosts:

```
firewall-cmd --add-interface=gre-example --zone=trusted
```

Now, we need a rich rule to tell firewalld to trust the public IP of each host. I talked about this [last year][4] on the blog. Run this command on both hosts:

```
firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="[IP ADDRESS]" accept'
```

If you run this on your first host, use the public IP address of your second host in the `firewall-cmd` command. Use the first host's public IP address when you run the command on the second host.

Save your configuration permanently on **both hosts**:

```
firewall-cmd --runtime-to-permanent
```

Try to ping between your servers using the IP addresses we configured on the GRE tunnel and you should get some replies!

## Final words

Remember that GRE tunnels **are not encrypted**. You can add IPSec over the tunnel or you can ensure that you use encrypted streams across the tunnel at all times (SSL, ssh, etc).

 [1]: http://www.freedesktop.org/software/systemd/man/systemd-networkd.service.html
 [2]: https://en.wikipedia.org/wiki/Generic_Routing_Encapsulation
 [3]: /2015/08/27/build-a-network-router-and-firewall-with-fedora-22-and-systemd-networkd/
 [4]: /2014/11/24/trust-ip-address-firewallds-rich-rules/
