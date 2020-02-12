---
title: 'Xen Summit: Day One Highlights'
author: Major Hayden
type: post
date: 2010-04-29T15:52:41+00:00
url: /2010/04/29/xen-summit-day-one-highlights/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3678953133
categories:
  - Blog Posts

---
I flew out to San Jose, California with two [other][1] [Rackers][2] for the Xen Summit at AMD's headquarters. The first day of the two-day conference was very informative. Lots of people asked for some highlights, so I'll provide those here.

[Ian Pratt][3] and [Keir Fraser][4] started off the day with an overview of Xen's current roadmap. They talked about their largest products and where they're going.

Open source Xen development is going strong with the recent release of Xen 4.0 and there are some great features in the works for Xen 4.1. There should be a new credit scheduler called "[credit2][5]" in that release. Also, the [Xen Cloud Platform][6] project is improving and the feature set is growing. The [Open vSwitch][7] was recently integrated with XCP.

The [Xen Client Initiative][8] caught my attention quickly as it allows a user to run a very thin hypervisor on a client machine, such as a laptop or desktop computer, and then run multiple operating systems on top of that hypervisor. This would reduce the need for products like VMWare Fusion, VirtualBox or Parallels Desktop.

Still not impressed? Watch Ian Pratt do a quick demonstration of XCI:

<span class="youtube"><iframe title="YouTube video player" class="youtube-player" type="text/html" width="620" height="385" src="//www.youtube.com/embed/b2-K1dbzZPk?wmode=transparent&fs=1&hl=en&modestbranding=1&iv_load_policy=3&showsearch=0&rel=1&theme=dark&hd=1" frameborder="0" allowfullscreen></iframe></span>

Tom Woller from AMD talked about some of the new hardware enhancements that allow Xen to virtualize devices more efficiently. While much of the low-level hardware discussion was a little over my head (I'm terrible with hardware), the improvements make sense and should improve the relationship with Xen.

[Yuvraj Agarwal][9] from the University of California San Diego talked about SleepServers. He's done some impressive work with Xen to reduce the energy usage of PC's left on when their users are no longer in the office.

Jonathan Ludlum covered the roadmap for Xen Cloud Platform in greater detail. This is definitely going to be a product to watch as it has a tight integration between various products, including XAPI, Open vSwitch, and the Xen hypervisor itself. It currently runs a CentOS-based userland and Jonathan said there are no plans to change it.

Later in the afternoon, [Konrad Wilk][10] from Oracle talked about the current status of the Xen kernels. The PVOps kernels are used with Xen 4.0 for the dom0 (and soon for the 3.4.x branch as well). The domU support has been present in PVOps code in the upstream kernels for some time. Many distribution vendors are making one kernel for bare metal and virtualized instances by simply adding PVOps support when they build their kernels. This eliminates the need for the traditional "kernel-xen" kernels that needed to be loaded for virtualized instances to work properly. [Jeremy Fitzhardinge][11] helped Konrad answer some questions from the audience and their presentation was one of the most informative ones of the day.

[George Dunlap][12] talked about the new credit2 scheduler that is due to be released with Xen 4.1 later this year. He found that the current scheduler negatively affects VM's running applications that have low CPU requirements but are affected greatly by higher latency. He tested this with a VM that was playing back an audio stream. When the rest of the VM's on the server used a lot of CPU time, the audio skipped many times. The credit2 scheduler allows for these low-CPU, latency-sensitive applications to keep running as expected without interruptions. I'm looking forward to testing this out later this year.

The last presentation of the day was from [Stefano Stabellini][13]. He covered the work being done to simplify how applications interact with Xen. The new library, libxenlight, strives to be a common layer between client applications and the Xen hypervisor.

The day wrapped up with a great party at Dave and Buster's. We had the opportunity to meet many people from Citrix as well as other people working in the virtualization space. Overall, the first day was very informative and I'm eager to hear some of the presentations scheduled for the second day.

 [1]: http://twitter.com/ajmesserli
 [2]: http://twitter.com/h1nch
 [3]: http://en.wikipedia.org/wiki/Ian_Pratt_(computer_scientist)
 [4]: http://www.xen.org/community/spotlight/keirfraser.html
 [5]: http://wiki.xensource.com/xenwiki/Credit2_Scheduler_Development
 [6]: http://www.xen.org/products/cloudxen.html
 [7]: http://openvswitch.org/
 [8]: http://www.xen.org/products/xci.html
 [9]: http://mesl.ucsd.edu/yuvraj/
 [10]: http://www.linkedin.com/in/darnok
 [11]: http://www.goop.org/~jeremy/
 [12]: http://www.xen.org/community/spotlight/dunlap.html
 [13]: http://uk.linkedin.com/in/stabellini
