---
aliases:
- /2012/06/28/red-hat-summit-2012-thursday/
author: Major Hayden
date: 2012-06-29 04:54:41
dsq_thread_id:
- 3643970097
tags:
- database
- fedora
- kvm
- openstack
- performance
- rackspace
- red hat
- security
- selinux
- sysadmin
- virtualization
title: 'Red Hat Summit 2012: Thursday'
---

Thursday has felt like the busiest, most jam-packed day of the week. The morning started off with three keynotes from HP, Intel, and Red Hat's CTO, Brian Stevens.

HP's message centered around converged cloud and that customers don't need an all or nothing solution. They can pull the best pieces from every type of hosting to do what's best for their business. The presentation from Intel was extremely heavy on the marketing side and didn't have much to do with Red Hat. Pauline Nist talked about how chip fabs operate, the heavy costs involved, and how their processors have changed over time. It felt a bit more like a sales pitch than anything else. She wrapped up with a pretty interesting time lapse video of the construction of a fab building and how the chips are made within the fab.

![1]

[Brian Stevens][2] talked a lot about keeping things in the open, reducing vendor lock-in, and pushing for innovation from multiple sources. He talked a lot about [OpenStack][3] and how it allows people to deliver a consistent user experience on a very open platform.

There was even a video with [Rackspace's][4] own [Jim Curry][5] talking about the unique challenges for building a cloud orchestration layer and how OpenStack solves quite a few of those challenges.

The sessions broke out after that and I made a beeline for [Dan Walsh's][6] session entitled "Multi-tenancy Virtualization Challenges and Solutions." I first ran into Dan at the FUDCon in Tempe and his session there about SELinux changed my mind about it for good. He covered the basics about the dangers of multi-tenant clouds and then went through multiple examples of how to mitigate the risks. Some of the technologies mentioned included [sVirt][7], SELinux policies, and [libseccomp][8].

The discussion about libseccomp caught my attention because the idea is genius. We know that SELinux itself is quite solid. However, what if a user finds some other flaw in the kernel which allows them to circumvent the SELinux layer altogether? The seccomp additions to linux 3.5 allow you specify which syscalls a particular process is allowed to make. Dan gave an example of QEMU when running KVM. If QEMU only needs 20-30 syscalls to get its job done, why allow it to run every syscall available in the x86_64 and x86 instruction sets? With seccomp, you can specify which syscalls are allowed and what you want to have happen when a syscall is requested that isn't allowed. Even if someone found a good kernel flaw, they might get blocked from doing anything malicious if the process isn't allowed to make a syscall necessary to tear up the system.

I met up with the Beefy Miracle himself just before lunch for a photo op:

![beefy_miracle] Major and the Beefy Miracle



Another good session was entitled "Using an Open Source Framework to Catch the Bad Guy" and it covered [auditd][9] in more detail than I imagined was even possible. [Mark St. Laurent][10] talked about how auditd's standard configuration will work for most users but that the government requires some pretty hefty adjustments. I wasn't aware that you can actually tell auditd to halt the server if it runs out of room to write the audit log to the disk. The US Government requires this to be enabled on many machines.

The last session I attended was Sanjay Rao's "Tuning Red Hat Systems for Databases" and it was tremendous. He talked about the differences between OLTP/DSS workloads and how all kinds of settings affect their performance. He covered everything from power management to disk elevators to NUMA. There were what seemed like a million slides and all of them contained some really good information. I really wish he could have cracked the presentation into two sessions to allow for some more discussion around details. If you can find the slides from this session, be sure to look through them.

![11]

As the day ended, a line of buses pulled up in front of the convention center and we were whisked away to Fenway Park for a private party sponsored by IBM. One of my childhood dreams was to travel to Fenway Park (and Wrigley Field) and I can say I'm halfway done! The park was amazing and it was truly an experience to walk up next to the Green Monster and look up to see how tall it really is.

The food was great and there was plenty of Sam Adams on tap. I ran into quite a few Red Hat folks and eventually found Thomas Cameron so I could thank him for the great SELinux session he ran on Wednesday. I'm going to take his slides back and share them at work to inspire some confidence around managing systems with SELinux enabled. A few twitter friends came up and we had some great conversations about cloud computing, OpenStack, and good beer. For anyone who attends class or works at Harvard, be sure to sync up with Philip Durbin. He's a smart guy and he was a lot of fun to talk to.

Friday's the last day and then the trip home begins. I'll try to write up a wrap-up post tomorrow from the airport.

 [1]: /wp-content/uploads/2012/06/Photo-Jun-28-10-04-07.jpg
 [2]: https://www.redhat.com/about/company/management/bios/management-team-brian-stevens-bio
 [3]: http://openstack.org/
 [4]: http://rackspace.com/
 [5]: https://twitter.com/jimcurry/
 [6]: http://danwalsh.livejournal.com/
 [7]: http://danwalsh.livejournal.com/44090.html
 [8]: https://fedoraproject.org/wiki/Features/Syscall_Filters
 [9]: http://people.redhat.com/sgrubb/audit/
 [10]: http://summitblog.redhat.com/2012/03/12/st-laurent-norman-mark/
 [11]: /wp-content/uploads/2012/06/Photo-Jun-28-20-02-29.jpg
 [beefy_miracle]: /wp-content/uploads/2012/06/Photo-Jun-28-10-42-07.jpg