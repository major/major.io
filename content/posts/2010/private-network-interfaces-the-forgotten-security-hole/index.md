---
aktt_notify_twitter:
- false
aliases:
- /2010/03/01/private-network-interfaces-the-forgotten-security-hole/
author: Major Hayden
date: 2010-03-02 00:55:07
tags:
- apache
- cloud
- command line
- encryption
- iptables
- mysql
- networking
- security
- ssl
- sysadmin
- tcpwrappers
title: 'Private network interfaces: the forgotten security hole'
---

Regardless of the type of hosting you're using - dedicated or cloud - it's important to take network interface security seriously. Most often, threats from the internet are the only ones mentioned. However, if you share a private network with other customers, you have just as much risk on that interface.

Many cloud providers allow you access to a private network environment where you can exchange data with other instances or other services offered by the provider. The convenience of this access comes with a price: other instances can access your instance on the private network just as easily as they could on the public interface.

Here are some security tips for your private interfaces:

**Disable the private interface**

This one is pretty simple. If you have only one instance or server, and you don't need to communicate privately with any other instances, just disable the interface. Remember to configure your networking scripts to leave the interface disabled after reboots.

**Use packet filtering**

The actual mechanism will vary based on your operating system, but filtering packets is the one of the simplest ways to secure your private interface. You can take some different approaches with them, but I find the easiest method is to allow access from your other instances and reject all other traffic.

For additional security, you can limit access based on ports as well as source IP addresses. This could prevent an attacker from having easy access to your other instances if they're able to break into one of them.

**Configure your daemons to listen on the appropriate interfaces**

If there are services that don't need to be listening on the private network, don't allow them to listen on your private interface. For example, MySQL might need to listen on the private interface so the web server can talk to it, but apache won't need to listen on the private interface. This reduces the profile of your instance on the private network and makes it a less likely target for attack.

**Use hosts.allow and hosts.deny**

Many new systems administrators forget about how handy tcpwrappers can be for limiting access. If your firewall is down in error, host.allow and hosts.deny could be an extra layer of protection. It's important to ensure that the daemons you are attempting to control are build with tcpwrappers support. Daemons like sshd support it, but apache and MySQL do not.

**Encrypt all traffic on the private network**

Just because it's called a "private" network doesn't mean that your traffic can traverse the network privately. You should always err on the side of caution and encrypt all traffic traversing the private network. You can use ssh tunnels, stunnel, or the built-in SSL features found in most daemons.

This also brings up an important point: **you should know how your provider's private network works**. Are there safeguards to prevent sniffing? Could someone else possibly ARP spoof your instance's private IP addresses? Is your private network's subnet shared among many customers?

With all of that said, it's also very important to have proper change control policies so that administrators working after you are fully aware of the security measures in place and why they are important. This will ensure that all of the administrators on your instances will understand the security of the system and they should be able to make sensible adjustments later for future functionality.