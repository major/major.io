---
aliases:
- /2016/04/22/lessons-learned-four-years-colocation-hosting/
author: Major Hayden
date: 2016-04-22 13:30:52
tags:
- colocation
- general advice
- hardware
- hosting
- linux
- networking
- servers
title: 'Lessons learned: Five years of colocation'
---

Back in 2011, I decided to try out a new method for hosting my websites and other applications: [colocation][2]. Before that, I used shared hosting, VPS providers ("cloud" wasn't a popular thing back then), and dedicated servers. Each had their drawbacks in different areas. Some didn't perform well, some couldn't recover from failure well, and some were terribly time consuming to maintain.

This post will explain why I decided to try colocation and will hopefully help you avoid some of my mistakes.

## Why choose colocation?

For the majority of us, hosting an application involves renting something from another company. This includes tangible things, such as disk space, servers, and networking, as well as the intangible items, like customer support. We all choose how much we rent (and hope our provider does well) and how much we do ourselves.

Colocation usually involves renting space in a rack, electricity, and network bandwidth. In these environments, the customer is expected to maintain the server hardware, perimeter network devices (switches, routers, and firewalls), and all of the other equipment downstream from the provider's equipment. Providers generally offer good price points for these services since they only need to ensure your rack is secure, powered, and networked.

As an example, a quarter rack in Dallas at a low to mid-range colocation provider can cost between $200-400 per month. That normally comes with a power allotment (mine is 8 amps) and network bandwidth (more on that later). In my quarter rack, I have five 1U servers plus a managed switch. One of those servers acts as my firewall.

Let's consider a similar scenario at a dedicated hosting provider. I checked some clearance prices in Dallas while writing this post and found pricing for servers which have similar CPUs as my servers, but with much less storage. The pricing for five servers runs about $550/month and we haven't even considered a switch and firewall yet.

Cost is one factor, but I have some other preferences which push me strongly towards colocation:

  * **Customized server configuration:** I can choose the quantity and type of components I need
  * **Customized networking:** My servers run an OpenStack private cloud and I need complex networking
  * **Physical access**: Perhaps I'm getting old, but I enjoy getting my hands dirty from time to time

If you have similar preferences, the rest of this post should be a good guide for getting started with a colocation environment.

## Step 1: Buy quality parts

Seriously - **buy quality parts**. That doesn't mean you need to go buy the newest server available from a well-known manufacturer, but you do need to find reliable parts in a new or used server.

I've built my environment entirely with [Supermicro][3] servers. The [X9SCi-LN4F][4] servers have been extremely reliable. My first two came brand new from [Silicon Mechanics][5] and I'm a big fan of their products. Look at their Rackform R.133 for something very similar to what I have.

My last three have all come from [Mr. Rackables][7] (an eBay seller). They're used X9SCi-LN4F servers, but they're all in good condition. I couldn't beat the price for those servers, either.

Before you buy, do some reading on brand reliability and compatibility. If you plan to run Linux, do a Google search for the model of the server and the version of Linux you plan to run. Also, take a moment to poke around some forums to see what other people think of the server. Go to [WebHostingTalk][8] and search for hardware there, too.

Buying quality parts gives you a little extra piece of mind, especially if your colo is a long drive from your home or work.

## Step 2: Ask questions

Your first conversation with most providers will be through a salesperson. That's not necessarily a bad thing since they will give you a feature and pricing overview fairly quickly. However, I like to ask additional questions of the salesperson to learn more about the technical staff.

Here are some good conversation starters for making it past a salesperson to the technical staff:

  * _Your website says I get 8 amps of power. How many plugs on the PDU can I use?_
  * _My applications need IPv6 connectivity. Is it possible to get something larger than a /64?_
  * _For IPv6 connectivity, will I use DHCP-PD or will you route a larger IPv6 block to me via SLAAC?_
  * _I'd like to delegate reverse DNS to my own nameservers. Do you support that?_
  * _If I have a problem with a component, can I ship you a part so you can replace it?_

When you do get a response, look for a few things:

  * Did the response come back in a reasonable timeframe? _(Keep in mind that you aren't a paying customer yet.)_
  * Did the technical person take the time to fully explain their response?
  * Does the response leave a lot of room for creative interpretation? _(If so, ask for clarification.)_
  * Does the technical invite additional questions?

It's much better to find problems now than after you've signed a contract. I'll talk more about contracts later.

## Step 3: Get specific on networking

Look for cities with very diverse network options. Big cities, or cities with lots of datacenters, will usually have good network provider choices and better prices. In Texas, your best bet is Dallas (which is where I host).

I've learned that bandwidth measurement is one of the biggest areas of confusion and "creative interpretation" in colocation hosting. Every datacenter I've hosted with has handled things differently.

There are four main ways that most colocation providers handle networking:

### 95th percentile

This is sometimes called [burstable billing][9] since it allows you to have traffic bursts without getting charged a lot for it. In the old days, you had to commit to a rate and stick with it (more on that method next). 95th percentile billing allows you to have some spikes during the measurement period without requiring negotiations for a higher transfer rate.

Long story short, this billing method measures your bandwidth on regular intervals and throws out the top 5% of your intervals. This means that some unusual spikes (so long as it's less than 36 hours in a month) won't cause you to need a higher committed rate. For most people, this measurement method is beneficial since your spikes are thrown out. However, if you have sustained spikes, [this billing method can be painful][10].

### Committed rate

If you see a datacenter say something like "$15 per megabit", they're probably measuring with [committed rates][11]. In this model, you choose a rate, like 10 megabits/second, and pay based on that rate. At $15 per megabit, your bandwidth charge would be $150 per month. The actual space in the rack and the power often costs extra.

Some people have good things to say about this billing method, but it seems awful to me. If you end up using 1 megabit per second, you still get billed for 10. If you have some spikes that creep over 10 megabit, even if you stay well under that rate as an average, the datacenter folks will ask you to do a higher commit. That means more money for something you may or may not use.

In my experience, this is is a **serious red flag**. This suggests that the datacenter network probably doesn't have much extra capacity available within the datacenter, with its providers, or both. You sometimes see this in cities where bandwidth is more expensive. If you find a datacenter that's totally perfect, but they want to do a committed rate, ask if there's an option for 95th percentile. If not, I strongly suggest looking elsewhere.

### Total bandwidth

Total bandwidth billing is what you normally see from most dedicated server or VPS providers. They will promise a certain transfer allotment and a network port speed. You will often see something like "10TB on a 100mbps port" and that means you can transfer 10TB in a month at at 100 megabits per second. They often don't care how you consume the bandwidth, but if you pass 10TB, you will likely pay overages per gigabyte. (Be sure to ask about the overage price.)

This method is nice because you can watch it like a water meter. You can take your daily transfer, multiply by 30, and see if the transfer allotment is enough. Most datacenters will allow you to upgrade to a gigabit port for a fee and this will allow you to handle spikes a little easier.

For personal colocation, this bandwidth billing method is great. It could be a red flag for larger customers because it gives a hint that the datacenter might be oversubscribed on networking. If every customer wanted to burst to 100 megabit at the same time, there probably isn't enough network connectivity to allow everyone to get that guaranteed rate.

### Bring your own

Finally, you could always negotiate with bandwidth providers and bring your own bandwidth. This comes with its own challenges and it's probably not worth it for a personal colocation environment. Larger business like this method because they often have rates negotiated with providers for their office connectivity and they can often get a good rate within the colocation datacenter.

There are plenty of up-front costs with bringing your own bandwidth provider. Some of those costs may come from the datacenter itself, especially if new cabling is required.

## Step 4: Plan for failure

Ensure that spare parts are available at a moment's notice if something goes wrong. In my case, I keep two extra hard drives in the rack with my servers as well as two sticks of RAM. My colocation datacenter is about four hours away by car, and I certainly don't want to make an emergency trip there to replace a broken hard drive.

Buying servers with out of band management can be a huge help during an emergency. Getting console access remotely can shave plenty of time off of an outage. The majority of Supermicro servers come with an out of band management controller by default. You can use simple IPMI commands to reboot the server or use the iKVM interface to interact with the console. Many of these management controllers allow you to mount USB drives remotely and re-image a server at any time.

Ask the datacenter if they have a network KVM that you could use or rent during an emergency. Be sure to ask about pricing and the time expectations when you request one to be connected to your servers.

## Step 5: Contracts and payment

Be sure to read the contract carefully. Pay special attention to how the datacenter handles outages and how you can request SLA credits. Take time to review any sections on what rights you have when they don't hold up their end of the deal.

As with any contract, find out what happens when the contract ends. Does it auto-renew? Do you keep the same rates? Can you go month to month? Reviewing these sections before signing could save a lot of money later.

## Wrapping up

Although cloud hosting has certainly made it easier to serve applications, there are still some people out there that prefer to have more customization than cloud hosting allows. For some applications, cloud hosting can be prohibitively expensive. Some applications don't tolerate a shared platform and the noisy neighbor issues that come with it.

Colocation can be a challenging, but rewarding, experience. As with anything, you must do your homework. I certainly hope this post helps make that homework a little easier.

* * *

_Since I know someone will ask me:_ I host with [Corespace][12] and I've been with them for a little over a year. They have been great so far and their staff has been friendly in person, via tickets, and via telephone.

_Photo credit: [Kev (Flickr)][13]_

 [1]: /wp-content/uploads/2016/04/15401776380_f5c6e357a2_k-e1461296519292.jpg
 [2]: https://en.wikipedia.org/wiki/Colocation_centre
 [3]: https://www.supermicro.com/
 [4]: http://www.supermicro.com/products/motherboard/Xeon/C202_C204/X9SCi-LN4F.cfm
 [5]: http://www.siliconmechanics.com/
 [7]: http://stores.ebay.com/MrRackables
 [8]: http://www.webhostingtalk.com/
 [9]: https://en.wikipedia.org/wiki/Burstable_billing
 [10]: https://en.wikipedia.org/wiki/Burstable_billing#95th_percentile
 [11]: https://en.wikipedia.org/wiki/Committed_information_rate
 [12]: http://corespace.com/
 [13]: https://www.flickr.com/photos/44176115@N07/15401776380/