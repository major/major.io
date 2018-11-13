---
title: What is ‘steal time’ in my sysstat output?
author: Major Hayden
type: post
date: 2008-11-04T17:19:08+00:00
url: /2008/11/04/what-is-steal-time-in-my-sysstat-output/
dsq_thread_id:
  - 3642805295
categories:
  - Blog Posts
tags:
  - sar
  - xen

---
After running sar on my new slice from [SliceHost][1]*, I noticed a new column called _steal_. It's generally very low on my virtual machine, and I've never seen it creep over 1-2%.

IBM's [definition][2] of steal time is actually pretty good:

> Steal time is the percentage of time a virtual CPU waits for a real CPU while the hypervisor is servicing another virtual processor.

So, relatively speaking, what does this mean?

A high steal percentage may mean that you may be outgrowing your virtual machine with your hosting company. Other virtual machines may have a larger slice of the CPU's time and you may need to ask for an upgrade in order to compete. Also, a high steal percentage may mean that your hosting company is overselling virtual machines on your particular server. If you upgrade your virtual machine and your steal percentage doesn't drop, you may want to seek another provider.

A low steal percentage can mean that your applications are working well with your current virtual machine. Since your VM is not wrestling with other VM's constantly for CPU time, your VM will be more responsive. This may also suggest that your hosting provider is underselling their servers, which is definitely a good thing.

* _I've been a customer of [SliceHost][1] for a while (prior to [Rackspace's acquisition][3]), and I recommend them to anyone who needs a solid VM solution. If you want to help out with my hosting costs, you're welcome to use my [SliceHost referral link][4]._

 [1]: http://slicehost.com/
 [2]: http://www.ibm.com/developerworks/linux/linux390/perf/tuning_rec_CPUtimes_virtual.html
 [3]: http://www.slicehost.com/articles/2008/10/22/big-news-today
 [4]: https://manage.slicehost.com/customers/new?referrer=6fc0943c343da4f6b87dbe5abf500c2e
