---
title: Trust an IP address with firewalld’s rich rules
author: Major Hayden
type: post
date: 2014-11-24T14:44:09+00:00
url: /2014/11/24/trust-ip-address-firewallds-rich-rules/
dsq_thread_id:
  - 3642807765
categories:
  - Blog Posts
tags:
  - fedora
  - firewall
  - network
  - red hat
  - security

---
Managing firewall rules with iptables can be tricky at times. The rule syntax itself isn't terribly difficult but you can quickly run into problems if you don't save your rules to persistent storage after you get your firewall configured. Things can also get out of hand quickly if you run a lot of different tables with jumps scattered through each.

#### Why FirewallD?

[FirewallD's][1] goal is to make this process a bit easier by adding a daemon to the mix. You can send firewall adjustment requests to the daemon and it handles the iptables syntax for you. It can also write firewall configurations to disk. It's especially useful on laptops since you can quickly jump between different firewall configurations based on the network you're using. You might run a different set of firewall rules at a coffee shop than you would run at home.

Adding a trusted IP address to a device running firewalld requires the use of [rich rules][2].

#### An example

Consider a situation where you have a server and you want to allow unrestricted connectivity to that server from a bastion or from your home internet connection. First off, determine your default zone (which is most likely "public" unless you've changed it to something else):

```
# firewall-cmd --get-default-zone
public
```


We will use 11.22.33.44 as our example IP address. Let's add the rich rule:

```
firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="11.22.33.44" accept'
```


Let's break down what we're asking firewalld to do. We're asking to allow IPv4 connectivity from 11.22.33.44 to all ports on the server and we're asking for that rule to be added to the _public_ (default) zone. If you list the contents of your _public_ zone, it should look like this:

```
# firewall-cmd --list-all --zone=public
public (default, active)
  interfaces: eth0
  sources:
  services: dhcpv6-client mdns ssh
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
	rule family="ipv4" source address="11.22.33.44" accept
```


 [1]: https://fedoraproject.org/wiki/FirewallD
 [2]: https://fedoraproject.org/wiki/Features/FirewalldRichLanguage#Handle_rich_rules_with_the_command_line_client
