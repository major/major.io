---
title: Privacy and icanhazip.com
author: Major Hayden
type: post
date: 2012-08-05T04:26:50+00:00
url: /2012/08/04/privacy-and-icanhazip-com/
dsq_thread_id:
  - 3664854402
categories:
  - Blog Posts
tags:
  - general advice
  - icanhazip
  - linux
  - sysadmin

---
A forum thread cropped in my inbox today from the [Puppy Linux][1] forums titled "[Major Hayden???][2]". After a little digging, I [found a giant thread][3] talking about [icanhazip.com][4].

In these various threads, I was accused of:

  * being an expert on Linux (totally false!)
  * running a site on behalf of the [CIA][5]
  * being a direct descendent of [General Michael Hayden][6] (former director of CIA & [NSA][7])
  * recording MAC ID's (which I assume means MAC addresses) on icanhazip.com
  * recording connection data for the [FBI][8] for US citizens inside the USA
  * writing spyware

Let's get a few things straight.

**Relation to General Hayden, the CIA, the FBI or the NSA**

Baseless. Hayden may not be terribly common ([one site claims][9] 35,000 people with my last name) but I'm not related to General Hayden in any way that I'm aware of. In addition, I've never had any affiliation with or done any paid work for the CIA, FBI or NSA. Have I been asked to assist with an investigation or two in the past? Yes. However, these were often pursuant to my work as a systems administrator and you'll find that this is relatively common among people who work for hosting companies.

**Running a site on behalf of the US government**

Wrong again. I started the site for my own personal use since I was fed up with all of the other providers who were jamming ads into their pages or asking for money before you could use their site with scripts. After all, the CIA doesn't need icanhazip.com [since they run Facebook already][10].

**Recording personal data on icanhazip.com**

The logging on icanhazip.com is standard for any nginx server. Yes, my logs have remote IP addresses, referrer details (if your application provides them) as well as user agents. I take great care to safeguard this data and only release very broad statistics if they seem interesting. For example, I might make a post about [wget][11] being the most popular application used to access icanhazip.com. Or, I might say something about receiving the majority of my requests from Europe. I'll never release any information personally about anyone using the site and I aggressively rotate the logs once I gather some basic broad stats.

Also, to the [Puppy Linux user who incensed me the most][12], you really need to learn how a network operates. Excluding [IPv6's SLAAC and EUI-64][13], there's no way for me to get your MAC address (not called a MAC ID) or even a portion of your MAC address after your request has passed through several routers to make it to icanhazip.com. I also don't write or distribute spyware. I return a plain text string containing your IP address (and a few HTTP headers) for each request. There is no binary data or redirection ever returned.

**Being an expert on Linux**

Familiar with Linux? Yes. An expert? Hardly.

As I learned on the ambulance as an EMT, the moment you think you're an expert and that you've seen everything is the moment before you get hit by a bus (figuratively).

 [1]: http://puppylinux.org/
 [2]: http://www.murga-linux.com/puppy/viewtopic.php?t=80081
 [3]: http://www.murga-linux.com/puppy/viewtopic.php?t=66968
 [4]: http://icanhazip.com
 [5]: http://en.wikipedia.org/wiki/Central_Intelligence_Agency
 [6]: http://en.wikipedia.org/wiki/Michael_Hayden_(general)
 [7]: http://en.wikipedia.org/wiki/Nsa
 [8]: http://en.wikipedia.org/wiki/Fbi
 [9]: http://www.namestatistics.com/search.php?name=hayden&type=last
 [10]: http://www.theonion.com/video/cias-facebook-program-dramatically-cut-agencys-cos,19753/
 [11]: http://www.gnu.org/software/wget/
 [12]: http://www.murga-linux.com/puppy/viewtopic.php?p=547747#547747
 [13]: http://en.wikipedia.org/wiki/IPv6_address#Stateless_address_autoconfiguration
