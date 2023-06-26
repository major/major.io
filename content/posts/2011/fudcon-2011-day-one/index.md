---
aliases:
- /2011/01/30/fudcon-2011-day-one/
author: Major Hayden
date: 2011-01-30 07:33:38
enclosure:
- "|\n    http://fedoraproject.org/w/uploads/4/44/State_of_fedora_tempe_2011.ogg\n\
  \    8032960\n    audio/ogg\n"
tags:
- boxgrinder
- cloudfs
- deltacloud
- fedora
- fudcon
- glusterfs
- linux
- python
- rackspace
title: 'FUDCon 2011: Day One'
---

The first day of FUDCon 2011 in Tempe is coming to a close tonight and I'm completely exhausted. [As promised][1], I'll try to summarize the day and cover the talks which I attended.

The day started out with [Jared Smith's][2] "State of Fedora" address. The audio has already been [posted on the wiki][3], but the speech was very positive overall. He talked about some of the struggles that have happened in the past and how they'll probably happen again in some form or another. It was pretty inspirational and you could obviously tell that people in the room were energized by it.

After the address, all of the talks were pitched in [BarCamp format][4]. It was a very efficient and entertaining way to create a schedule for the conference. Everyone had 15-20 seconds to present their talk and then they had to rush outside to post their topic on the wall. We all had the opportunity to go outside and vote for the talks that sounded interesting. Once the votes were tallied, the schedule was set and the conference was fully underway.

The first talk for me was about [Marek Goldmann's][5] [BoxGrinder][6]. _(Note: If you Google for BoxGrinder, make sure that you enter it as a single word. You'll get some wild unrelated results if you use two words.)_ In short, BoxGrinder gives you the ability to have a [kickstart][7]-ish method for automatically building images for virtual machine environments. It's completely [plugin-based][8], so you can have different platform and delivery plugins depending on where your VM needs to be deployed. For example, you could deploy a VM with BoxGrinder that is in a format for VMWare (platform) and is delivered to the target server via SFTP (delivery). The public cloud plugins are only compatible with Amazon's products, but I'm eager to change that during one of the upcoming hackfests.

The [Sheepdog][9] talk started up right after lunch and although it was interesting, I think it left most people with quite a few questions when it was over. However, I think people are generally apprehensive when anyone tries to do anything innovative with storage. Losing data due to a bug is a big concern and many of the questions went deeper into data safety than performance and functionality.

Next up was [Dave Malcolm's][10] talk about the different implementations of python. This was definitely an eye-opening talk for my coworker and I. Dave covered CPython, Jython, PyPy and various other implementations and compared their advantages and disadvantages. I'm still pretty new to Python (I'm clutching on to ruby, PHP and perl still), but this talk really had me thinking about which implementations are best for a particular environment or task. It was quite a bit of fun to learn about some of the deep underpinnings of Python and how they differ depending on the specific implementation.

[Jeff Darcy's][11] talk about [CloudFS][12] was very intriguing. I've been a fan of [GlusterFS][13] recently, but I eventually moved away due to a lack of enterprise features and degrading performance. Jeff is working to add in encryption and authentication without rewriting the filesystem itself. There are quite a few tricky problems involved in the encryption portion due to partial writes and general security during the handshake process. CloudFS could potentially be a network filesystem which could be shared by multiple tenants with their own individual namespaces and segregated UID's. This could be a big win for providers as they could offer up large amounts of storage in an organized fashion without too many management headaches.

We wrapped up the day of talks with [Chris Lalancette's][14] presentation about [Deltacloud][15]. In short, it's a bag of daemons that allow you to manage multiple public or private clouds. Everything from image management to provisioning are included in the project. Questions were raised about whether another application was needed since vendor-specific libraries are abundant and libcloud offers many of the same features in a simpler package.

Tonight's social event was FUDPub at ASU's Memoral Union building. The food and drinks were excellent (thanks to [Rackspace][16]!) and it was a great opportunity to relax and talk with other Fedora users and developers. We had the opportunity to meet people from around the world while playing round after round of bowling and billiards. The discussions were extremely valuable, but as I said before, it was quite tiring.

I've compiled the FUDCon photos I've taken into a [Flickr photo set][17].

That's the end of today's summary. I'll try to keep this going tomorrow as well. Thanks for reading!

 [1]: /2011/01/29/gearing-up-for-fudcon-2011/
 [2]: http://fedoraproject.org/wiki/User:Jsmith
 [3]: http://fedoraproject.org/w/uploads/4/44/State_of_fedora_tempe_2011.ogg
 [4]: http://en.wikipedia.org/wiki/BarCamp
 [5]: http://twitter.com/marekgoldmann
 [6]: http://www.jboss.org/boxgrinder.html
 [7]: http://fedoraproject.org/wiki/Anaconda/Kickstart
 [8]: http://community.jboss.org/wiki/BoxGrinderBuildPlugins
 [9]: http://www.osrg.net/sheepdog/
 [10]: http://fedoraproject.org/wiki/Python_in_Fedora_13
 [11]: http://pl.atyp.us/
 [12]: http://fedoraproject.org/wiki/Features/CloudFS
 [13]: http://www.gluster.org/
 [14]: http://clalance.blogspot.com/
 [15]: http://incubator.apache.org/deltacloud/
 [16]: http://rackspace.com/
 [17]: http://www.flickr.com/photos/texas1emt/sets/72157625935659726/