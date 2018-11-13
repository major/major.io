---
title: Power 8 to the people
author: Major Hayden
type: post
date: 2016-09-22T00:00:21+00:00
url: /2016/09/21/power-8-to-the-people/
featured_image: /wp-content/uploads/2016/09/IBMPowerSystemE870-2.jpg
dsq_thread_id:
  - 5162895836
categories:
  - Blog Posts
tags:
  - aix
  - ibm
  - linux
  - power
  - python

---
IBM Edge 2016 is almost over and I've learned a lot about Power 8 this week. I've talked about some of the learnings in my recaps of days [one][1] and [two][2]. The performance arguments sound really interesting and some of the choices in AIX's design seem to make a lot of sense.

However, there's one remaining barrier for me: **Power 8 isn't really accessible for a tinkerer**.

[<img src="/wp-content/uploads/2016/09/IBMPowerSystemE870-2.jpg" alt="Power 8 E870-2" width="1280" height="853" class="alignright size-full wp-image-6458" srcset="/wp-content/uploads/2016/09/IBMPowerSystemE870-2.jpg 1280w, /wp-content/uploads/2016/09/IBMPowerSystemE870-2-300x200.jpg 300w, /wp-content/uploads/2016/09/IBMPowerSystemE870-2-768x512.jpg 768w, /wp-content/uploads/2016/09/IBMPowerSystemE870-2-1024x682.jpg 1024w" sizes="(max-width: 1280px) 100vw, 1280px" />][3]

## Tinkering?

Google defines _tinkering_ as:

> attempt to repair or improve something in a casual or desultory way,

> often to no useful effect.

> "he spent hours tinkering with the car"

When I come across a new piece of technology, I really enjoy learning how it works. I like to find its strengths and its limitations. I use that information to figure out how I might use the technology later and when I would recommend the technology for someone else to use it.

To me, tinkering is simply messing around with something until I have a better understanding of how it works. Tinkering doesn't have a finish line. Tinkering may not have a well-defined goal. However, it's tinkering that leads to a more robust community around a particular technology.

For example, take a look at the Raspberry Pi. There were plenty of other ARM systems on the market before the Pi and there are still a lot of them now. What makes the Pi different is that it's highly accessible. You can get the newest model for $35 and there are tons of guides for running various operating systems on it. There are even more guides for how to integrate it with other items, such as sprinkler systems, webcams, door locks, and automobiles.

Another example is the Intel NUC. Although the NUC isn't the most cost-effective way to get an Intel chip on your desk, it's powerful enough to be a small portable server that you can take with you. This opens up the door for software developers to test code wherever they are (we use them for OpenStack development), run demos at a customer location, or make multi-node clusters that fit in a laptop bag.

### What makes Power 8 inaccessible to tinkerers?

One of the first aspects that most people notice is the cost. The [S821LC][4] currently starts at around $6,000 on IBM's site, which is a bit steep for someone who wants to learn a platform.

I'm not saying this server should cost less - the pricing seems quite reasonable when you consider that it comes with dual 8-core Power 8 processors in a 1U form factor. It also has plenty of high speed interconnects ready for GPUs and CAPI chips. With all of that considered, $6,000 for a server like this **sounds very reasonable**.

There are other considerations as well. A stripped down S821LC with two 8-core CPUs will [consume about 406 Watts at 50% utilization][5]. That's a fair amount of power draw for a tinkerer and I'd definitely think twice about running something like that at home. When you consider the cooling that's required, it's even more difficult to justify.

### What about AIX?

AIX provides some nice benefits on Power 8 systems, but it's difficult to access as well. Put "learning AIX" into a Google search and [look at the results][6]. The first link is a [thread on LinuxQuestions.org][7] where the original poster is given a few options:

  * Buy some IBM hardware
  * Get in some legal/EULA gray areas with VMware
  * Find an old Power 5/6 server that is coming offline at a business that is doing a refresh

Having access to AIX is definitely useful for tinkering, but it could be very useful for software developers. For example, if I write a script in Python and I want to add AIX support, I'll need access to a system running AIX. It wouldn't necessarily need to be a system with tons of performance, but it would need the functionality of a basic AIX environment.

## Potential solutions

I'd suggest two solutions:

  1. Get AIX into an accessible format, perhaps on a public cloud
  2. Make a more tinker-friendly Power 8 hardware platform

Let's start with AIX. I'd gladly work with AIX in a public cloud environment where I pay some amount for the virtual machine itself plus additional licensing for AIX. It would still be valuable even if the version of AIX had limiters so that it couldn't be used for production workloads. I would be able to access the full functionality of a running AIX environment.

The hardware side leads to challenges. However, if it's possible to do a single Power 8 SMT2 CPU in a smaller form factor, this could become possible. Perhaps these could even be CPUs with some type of defect where one or more cores are disabled. That could reduce cost while still providing the full functionality to someone who wants to tinker with Power 8.

Some might argue that this defeats the point of Power 8 since it's a high performance, purpose-built chip that crunches through some of the world's biggest workloads. That's a totally valid argument.

However, that's not the point.

The point is to get a fully-functional Power 8 CPU - even if it has serious performance limitations - into the hands of developers who want to do amazing things with it. My hope would be that these small tests will later turn into new ways to utilize POWER systems.

It could also be a way for more system administrators and developers to get experience with AIX. Companies would be able to find more people with a base level of AIX knowledge as well.

## Final thoughts

IBM has something truly unique with Power 8. The raw performance of the chip itself is great and the door is open for even more performance through NVlink and CAPI accelerators. These features are game changers for businesses that are struggling to keep up with customer demands. A wider audience could learn about this game-changing technology if it becomes more accessible for tinkering.

_Photo credit: [Wikipedia][8]_

 [1]: /2016/09/20/ibm-edge-2016-day-1-recap/
 [2]: https://major.io/2016/09/21/ibm-edge-2016-day-2-recap/
 [3]: /wp-content/uploads/2016/09/IBMPowerSystemE870-2.jpg
 [4]: http://www-03.ibm.com/systems/power/hardware/s821lc/index.html
 [5]: http://www-912.ibm.com/see/EnergyEstimator
 [6]: https://www.google.com/search?q=learning+AIX
 [7]: http://www.linuxquestions.org/questions/aix-43/cheapest-way-to-learn-aix-4175534982/
 [8]: https://commons.wikimedia.org/wiki/File:IBMPowerSystemE870-2.jpg
