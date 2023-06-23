---
aliases:
- /2012/06/13/guide-to-using-and-understanding-traceroute/
author: Major Hayden
date: 2012-06-13 12:40:47
dsq_thread_id:
- 3642806996
tags:
- fedora
- general advice
- linux
- networking
- sysadmin
title: Great guide for using traceroute and understanding its results
---

Anyone who has been a system administrator for even a short length of time has probably used [traceroute][1] at least once. Although the results often seem simple and straightforward, [Richard Steenbergen][2] pointed out in a [NANOG presentation][3] [PDF] that many people misinterpret the results and chase down the wrong issues.

Richard makes some great points about where latency comes from and when people often make the wrong assumptions regarding the source and location of the latency. For example, it's important to keep in mind that many routers de-prioritize ICMP packets sent directly to them and although you may think a particular hop has a ton of latency, it may just be caused by the router prioritizing the handling of other packets before yours. In addition, different routers measure latency with varying precision (4ms for Cisco).

He also covers tricky routing paths that you might not consider without intimate knowledge of the remote network configuration. Technologies like MPLS can hide parts of the network path from view and those hidden devices could be causing network problems for your traffic.

I sent Richard an email to thank him for assembling this guide and he linked me to a [tablet-handy, book-like version][4]. Both versions have some great information for system and network administrators.

I've mirrored the PDF's here just in case the links above stop working:

  * [A Practical Guide to (Correctly) Troubleshooting with Traceroute (NANOG presentation slides)][5]
  * [Traceroute (Book format)][6]

 [1]: http://en.wikipedia.org/wiki/Traceroute
 [2]: http://www.linkedin.com/in/rsteenbergen
 [3]: http://www.nanog.org/meetings/nanog47/presentations/Sunday/RAS_Traceroute_N47_Sun.pdf
 [4]: http://cluepon.net/ras/traceroute.pdf
 [5]: /wp-content/uploads/2012/06/RAS_Traceroute_NANOG_slides.pdf
 [6]: /wp-content/uploads/2012/06/RAS_Traceroute_Book_Format.pdf