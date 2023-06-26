---
aliases:
- /2013/06/14/red-hat-summit-2013-recap/
author: Major Hayden
date: 2013-06-15 00:25:50
enclosure:
- "|\n    http://videos.cdn.redhat.com/2013-summit-keynotes-hohndel.mp4\n    127535004\n\
  \    video/mp4\n"
tags:
- fedora
- linux
- openstack
- redhat
- security
- selinuxs
- virtualization
title: Red Hat Summit 2013 Recap
---

![1]

The 2013 Red Hat Summit was my second one and I enjoyed it more than last year. Quite a few people asked for a recap and some takeaways from the Summit and that's what I hope to do in this post.

**Keynotes**

It's quite apparent that Red Hat is taking a more assertive - and sometimes aggressive - stance against closed source, overpriced solutions that prevent consumers from getting things done. Jim Whitehurst had a slide that showed "Open or Die" with a live plant on the left and a dead one on the right (see the photo in the post just below this paragraph). You could hear the gasp in the audience from some of the less technical crowd. Red Hat is making a big push to deliver on Openstack and to modernize their RHEL and RHEV platforms. Paul Cormier detailed some of the upcoming offerings and the overall strategy seems to be a double-down on virtualization via Openstack and further enhancement of Enterprise Linux.

![2]

Of the vendor keynotes, the Intel keynote from Dirk Hohndel was superb. He seemed a bit nervous at first and we were quickly losing interest but he brought us back in with some good anecdotes. Dirk went into detail about how a company with a ton of intellectual property could also embrace open source. Surprisingly, the speech really moved me and there were no slides involved; it was just Dirk talking.

You can watch the keynotes on [Red Hat's Summit site][3]. If you only watch one of them, watch [Dirk Hohndel's talk][4] (direct link to MP4).

**Sessions**

![5]

The most memorable was [Jon Masters' demonstration of the 64-bit ARM platform][6] (AArch64). Although there was no bicycle or spandex involved this year (he apologized for the lack of both), it was amazing to see some firsts. It was the first time AArch64 has been demonstrated in public and the first time Gluster ran on 64-bit ARM. He had a 2U rackmount chassis and the fans were extremely loud. Jon commented that the chips are "rarer than gold" and that he wasn't going to chance turning the fans off. The server performed quite well during the demonstration and certainly outperformed what I'd expect from an ARM system.

Dan Walsh led two informative sessions that I enjoyed. The first was a [session on Linux containers][7]. LXC confused me quite a bit before the talk but Dan and the product manager went through how containers work step by step. They gave real world use cases and made comparisons to the more prevalent virtualization methods, like KVM. As you might expect, Dan sprinkled in some useful security tips to make containers more safe to use.

Another of Dan's talks was about [how to use SELinux in a large enterprise][8]. He started it off with a brief explanation of SELinux and made us all stand up and say the words on his first slide ("SELinux is a labeling system"). He offered some tips on how to manage SELinux on multiple machines with Puppet and Ansible. In addition, he showed how custom policies could be easily exported and then passed around as RPM's or within configuration management systems. We also saw how to send auditd logs to remote systems for aggregation and alerting. You can certainly manage SELinux on many machines simply by treating the policies and configuration just like you treat any other service's configuration files.

Even after the Pub Crawl on Thursday night, the [Friday morning presentation about systemd][9] was packed with attendees. The presenters went through SysV's shortcomings and what systemd can deliver. It will replace init in RHEL 7. Adding systemd reduces the complexity of managing services and allows you to automate many of the things that are annoying to do manually (like cgroups). Its default method of handling cgroups allows CPU share to be carved up _per service_ rather than per process. That means that if httpd has ten workers and MySQL is running two processes, each _service_ will receive a 50% share of the total CPU (rather than httpd getting a lot extra since it has multiple processes).

The RHEL 7 talks were extremely informative and I was writing until my hand almost fell off. I probably missed a lot of the new features so it might be a good idea to wait for the slides to be published. If you're eager to use RHEL 7 as a desktop, you'll see GNOME's classic mode on the desktop (and it looks great).

**After-hours**

As usual, the Red Hat Certified Professionals reception at McGreevy's was a great networking opportunity. I met other Linux users from around the world and enjoyed some pretty decent beer and food. I stayed after the reception and received a detailed lesson about how hockey works. The Bruins pushed through three OT's but eventually lost.

The rain ruined Thursday night's plans but the Red Hat marketing folks put together a great alternative in less than 24 hours. We ended up at [Royale][10] and were treated to a ton of food and drinks. Some musicians set up late in the evening and we were all wondering what type of music they'd play. It was a group called [Alter Ego][11] from Montreal and they really rocked the place. They're famous for "60 costume changes in 90 minutes" and they took us through oldies, disco, and contemporary music. They hit every single music genre I could think of (except country) and everyone was amazed that they entertained us for 90 minutes without a single break. If you get the chance to see this group in person, don't miss it.

![12]

**Wrap-up**

The Red Hat Summits continue to be a good opportunity to learn, network, and experiment. The ratio of attendees seems to be tilting more toward the non-technical side, and this is a problem that the organizers will definitely need to improve. There were several technical sessions packed wall to wall with plenty of non-technical people playing on their phones or checking email on their laptops. It's a tough problem to fix and many conferences have the same issue.

Next year's summit will be in San Francisco in April. I hope to see you there!

 [1]: /wp-content/uploads/2013/06/IMG_20130611_173516.jpg
 [2]: /wp-content/uploads/2013/06/IMG_20130611_180616.jpg
 [3]: http://www.redhat.com/summit/2013/gallery/
 [4]: http://videos.cdn.redhat.com/2013-summit-keynotes-hohndel.mp4
 [5]: /wp-content/uploads/2013/06/IMG_20130613_140551.jpg
 [6]: http://www.redhat.com/summit/sessions/index.html#232
 [7]: http://www.redhat.com/summit/sessions/index.html#418
 [8]: http://www.redhat.com/summit/sessions/index.html#67
 [9]: http://www.redhat.com/summit/sessions/index.html#499
 [10]: http://royaleboston.com/
 [11]: http://www.alteregobooking.com/
 [12]: /wp-content/uploads/2013/06/PANO_20130613_213602.jpg