---
aliases:
- /2016/05/16/troubleshooting-openstack-network-connectivity/
author: Major Hayden
date: 2016-05-17 02:43:41
tags:
- general advice
- network
- networking
- openstack
- security
- troubleshooting
title: Troubleshooting OpenStack network connectivity
---

_NOTE: This post is a work in progress. If you find something that I missed, feel free to leave a comment. I've made plenty of silly mistakes, but I'm sure I'll make a few more. :)_

* * *

Completing a deployment of an OpenStack cloud is an **amazing feeling**. There is so much automation and power at your fingertips as soon as you're finished. However, the mood quickly turns sour when you create that first instance and it never responds to pings.

It's the same feeling I get when I hang Christmas lights every year only to find that a whole section didn't light up. If you've ever seen [National Lampoon's Christmas Vacation][1], you know what I'm talking about:

![Chevy-Chase-in-National-Lampoons-Christmas-Vacation.jpg](Chevy-Chase-in-National-Lampoons-Christmas-Vacation.jpg)

I've stumbled into plenty of problems (and solutions) along the way and I'll detail them here in the hopes that it can help someone avoid throwing a keyboard across the room.

## Security groups

Security groups get their own section because I forget about them constantly. [Security groups][3] are a great feature that lets you limit inbound and outbound access to a particular network port.

However, OpenStack's default settings are fairly locked down. That's great from a security perspective, but it can derail your first instance build if you're not thinking about it.

You have two options to allow traffic:

  * Add more permissive rules to the `default` security group
  * Create a new security group and add appropriate rules into it

I usually ensure that ICMP traffic is allowed into any port with the `default` security group applied, and then I create a another security group specific to the class of server I'm building (like `webservers`). Changing a security group rule or adding a new security group to a port takes effect in a few seconds.

## Something is broken in the instance

Try to [get console access][4] to the instance through Horizon or via the command line tools. I generally find an issue in one of these areas:

  * The IP address, netmask, or default gateway are incorrect
  * Additional routes should have been applied, but were not applied
  * Cloud-init didn't run, or it had a problem when it ran
  * The default iptables policy in the instance is overly restrictive
  * The instance isn't configured to bring up an instance by default
  * Something is preventing the instance from getting a DHCP address

If the network configuration looks incorrect, cloud-init may have had a problem during startup. Look in `/var/log/` or in `journald` for any explanation of why cloud-init failed.

There's also the chance that the network configuration is correct, but the instance can't get a DHCP address. Verify that there are no iptables rules in place on the instance that might block DHCP requests and replies.

Some Linux distributions don't send [gratuitous ARP packets][5] when they bring an interface online. Tools like [arping][6] can help with these problems.

If you find that you can connect to almost anything from within the instance, but you can't connect to the instance from the outside, verify your security groups (see the previous section). In my experience, a lopsided ingress/egress filter almost always points to a security group problem.

## Something is broken in OpenStack's networking layer

Within the OpenStack control plane, the nova service talks to neutron to create network ports and manage addresses on those ports. One of the requests or responses may have been lost along the way or you may have stumbled into a bug.

If your instance couldn't get an IP address via DHCP, make sure the DHCP agent is running on the server that has your neutron agents. Restarting the agent should bring the DHCP server back online if it isn't running.

You can also hop into the network namespace that the neutron agent uses for your network. Start by running:

```
# ip netns list
```


Look for a namespace that starts with `qdhcp-` and ends with your network's UUID. You can run commands inside that namespace to verify that networking is functioning:

```
# ip netns exec qdhcp-NETWORK_UUID ip addr
# ip netns exec qdhcp-NETWORK_UUID ping INSTANCE_IP_ADDRESS
```


If your agent can ping the instance's address, but you can't ping the instance's address, there could be a problem on the underlying network - either within the virtual networking layer (bridges and virtual switches) or on the hardware layer (between the server and upstream network devices).

Try to use `tcpdump` to dump traffic on the neutron agent and on the instance's network port. Do you see any traffic at all? You may find a problem with incorrect VLAN ID's here or you may see activity that gives you more clue (like one half of an ARP or DHCP exchange).

## Something is broken outside of OpenStack

Diagnosing these problems can become a bit challenging since it involves logging into other systems.

If you are using VLAN networks, be sure that the proper VLAN ID is being set for the network. Run `openstack network show` and look for `provider:segmentation_id`. If that's correct, be sure that all of your servers can transmit packets with that VLAN tag applied. I often remember to allow tagged traffic on all of the hypervisors and then I forget to do the same in the control plane.

Be sure that your router has the VLAN configured and has the correct IP address configuration applied. It's possible that you've configured all of the VLAN tags correctly in all places, but then fat-fingered an IP address in OpenStack or on the router.

While you're in the router, test some pings to your instance. If you can ping from the router to the instance, but not from your desk to the instance, your router might not be configured correctly.

For instances on private networks, ensure that you created a router on the network. This is something I tend to forget. Also, be sure that you have the right routes configured between you and your OpenStack environment so that you can route traffic to your private networks through the router. If this isn't feasible for you, another option could be OpenStack's [VPN-as-a-service][7] feature.

Another issue could be the cabling between servers and the nearest switch. If a cable is crossed, it could mean that a valid VLAN is being blocked at the switch because it's coming in on the wrong port.

## When it's something else

There are some situations that aren't covered here. If you think of any, please leave a comment below.

As with any other troubleshooting, I go back to this quote from [Dr. Theodore Woodward][8] about diagnosing illness in the medical field:

> When you hear hoofbeats, think of horses not zebras.

Look for the simplest solutions and work from the smallest domain (the instance) to the widest (the wider network). Make small changes and go back to the instance each time to verify that something changed. Once you find the solution, document it! Someone will surely appreciate it later.

 [1]: https://en.wikipedia.org/wiki/National_Lampoon%27s_Christmas_Vacation
 [3]: http://docs.openstack.org/openstack-ops/content/security_groups.html
 [4]: http://docs.openstack.org/user-guide/cli_access_instance_through_a_console.html
 [5]: https://en.wikipedia.org/wiki/Address_Resolution_Protocol#ARP_announcements
 [6]: https://en.wikipedia.org/wiki/Arping
 [7]: https://github.com/openstack/neutron-vpnaas
 [8]: https://en.wikipedia.org/wiki/Zebra_(medicine)