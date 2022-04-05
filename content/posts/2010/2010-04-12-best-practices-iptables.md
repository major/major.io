---
title: 'Best practices: iptables'
author: Major Hayden
type: post
date: 2010-04-12T13:35:31+00:00
url: /2010/04/12/best-practices-iptables/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806121
categories:
  - Blog Posts

---
Anyone who has used [iptables][1] before has locked themselves out of a remote server at least once. It's easily avoided, but often forgotten. Lots of people have asked me for a list of best practices for iptables firewalls and I certainly hope this post helps.

**Understand how iptables operates**

Before you can begin using iptables, you need to fully understand how it matches packets with chains and rules. There is a [terrific diagram in Wikipedia][2] that will make it easier to understand. It's imperative to remember that iptables rules are read top-down until a matching rule is found. If no matching rule is found, the default policy of the chain will be applied (more on that in a moment).

**Don't set the default policy to DROP**

All iptables chains have a default policy setting. If a packet doesn't match any of the rules in a relevant chain, it will match the default policy and will be handled accordingly. I've seen quite a few users set their default policy to DROP, and this can bring about some unintended consequences.

Consider a situation where your INPUT chain contains quite a few rules allowing traffic, and you've set the default policy to DROP. Later on, another administrator logs into the server and flushes the rules (which isn't a good practice, either). I've met quite a few good systems administrators who are unaware of the default policy for iptables chains. Your server will be completely inaccessible immediately. All of the packets will be dropped since they match the default policy in the chain.

Instead of using the default policy, I normally recommend making an explicit DROP/REJECT rule at the bottom of your chain that matches everything. You can leave your default policy set to ACCEPT and this should reduce the chance of blocking all access to the server.

**Don't blindly flush iptables rules**

Before running `iptables -F`, always check each chain's default policy. If the INPUT chain is set to DROP, you'll need to set it to ACCEPT if you want to access the server after the rules are flushed. Also, consider the security implications of your network when you clear the rules. Your services will be completely exposed and any masquerading or NAT rules will be removed.

**Remember localhost**

Lots of applications require access to the `lo` interface. Ensure that you set up your rules carefully so that the `lo` interface is not disturbed.

**Split complicated rule groups into separate chains**

Even if you're the only systems administrator for your particular network, it's important to keep your iptables rules manageable. If you have a certain subset of rules that may be a little complicated, consider breaking them out into their own chain. You can just add in a jump to that chain from your default set of chains.

**Use REJECT until you know your rules are working properly**

When you're writing iptables rules, you'll probably be testing them pretty often. One way to speed up that process is to use the REJECT target rather than DROP. You'll get an immediate rejection of your traffic (a TCP reset) instead of wondering if your packet is being dropped or if it's making it to your server at all. Once you're done with your testing, you can flip the rules from REJECT to DROP if you prefer.

_For those folks working towards their RHCE, this is a huge help during the test. When you're nervous and in a hurry, the immediate packet rejection is a welcomed sight._

**Be stringent with your rules**

Try to make your rules as specific as possible for your needs. For example, I like to allow ICMP pings on my servers so that I can run network tests against them. I could easily toss a rule into my INPUT chain that looks like this:

<pre lang="html">iptables -A INPUT -p icmp -m icmp -j ACCEPT </pre>

However, I don't want to simply allow all ICMP traffic. There have been some ICMP flaws from time to time and I'd rather keep as low of a profile as possible. There are [many types of ICMP control messages][3], but I only want to allow echo requests:

<pre lang="html">iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT</pre>

This will allow echo requests (standard ICMP pings), but it won't explicitly allow any other ICMP traffic to pass through the firewall.

**Use comments for obscure rules**

If you have rules to cover edge cases that other administrators might not understand, consider using iptables comments by adding the following arguments to your rules:

<pre lang="html">-m comment --comment "limit ssh access"</pre>

The comments will appear in the iptables output if you list the current rules. They will also appear in your saved iptables rules.

**Always save your rules**

Most distributions offer some way to save your iptables rules so that they persist through reboots. Red Hat-based distributions offer `/etc/init.d/iptables save`, but Debian and Ubuntu require some [manual labor][4]. An errant reboot would easily take out your unsaved rules, so save them often.

 [1]: http://en.wikipedia.org/wiki/Iptables
 [2]: http://en.wikipedia.org/wiki/Iptables#Operational_summary
 [3]: http://en.wikipedia.org/wiki/Internet_Control_Message_Protocol#List_of_permitted_control_messages_.28incomplete_list.29
 [4]: http://rackerhacker.com/2009/11/16/automatically-loading-iptables-on-debianubuntu/
