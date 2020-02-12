---
title: 'Red Hat Summit 2012: Wednesday'
author: Major Hayden
type: post
date: 2012-06-28T06:03:51+00:00
url: /2012/06/28/red-hat-summit-2012-wednesday/
dsq_thread_id:
  - 3642807006
categories:
  - Blog Posts
tags:
  - cloud
  - glusterfs
  - linux
  - network
  - networking
  - red hat
  - security
  - selinux
  - sysadmin

---
Wednesday was action-packed with dramatic keynotes and great sessions. The morning was kicked off by [Paul Cormier][1] and he talked about some new products coming from Red Hat. Much of the product releases were centered around cloud offerings (like [Openshift][2]) and his talk was mainly aimed at CIO's and decision makers. There wasn't a lot of technical detail within his talk but it was refreshing to hear a Linux vendor talk about their products as being revolutionary steps in pulling away from vendor lock-in and proprietary solutions.

Paul was followed by Irfan Khan who talked about the value of very low latency information exchange and processing. He drove home the point that the biggest value we can gain from information in the current age is related to our ability to gather and interpret the information in as close to real time as possible. I expected a speech from a SAP employee to be relatively dry but I was pleasantly surprised to find that he made a lot of good points. Irfan emphasized that big data providers need to find a way to fit into their customers' landscape without causing too much disruption while also providing some real benefits.

My first session was [Jeff Darcy's][3] discussion about Red Hat's storage offering and what GlusterFS advancements were on the horizon. His talk was standing room only and he covered a lot of highly technical points about GlusterFS. I'm getting the feeling that GlusterFS is gaining more momentum and that we'll be seeing more features around consistency and performance very soon.

As a fan of SELinux, I made sure that I was in [Thomas Cameron's][4] "SELinux for Mere Mortals" class. Although I feel relatively confident that I can solve SELinux problems when I find them, Thomas covered a lot of easier solutions that I hadn't previously considered. His explanation of the basics of SELinux are a must read for any system administrator working on a Red Hat system. I managed to [find his slides from last year][5] but he said the new slides should be up by Friday.

I attended another good class about managing network resources with Red Hat. Although the slides were a little wordy, the content was extremely good. The speaker talked about receiving a 40Gb/sec ethernet card from Mellanox and how he bumped the performance from 8Gb/sec to 37Gb/sec by adjusting CPU pinning (for NUMA) as well as some kernel configuration around TCP buffers. It was an eye-opening discussion and it was a good session for people who are trying to find bottlenecks in their hardware.

The afternoon was spend mingling with GlusterFS developers and users as well as the people working the Fedora booth. I managed to pick up some Fedora stickers but I've yet to get my picture taken with the life-size Beefy Miracle hot dog. That's my goal for tomorrow.

The night wrapped up with the Red Hat Certified Professionals Party at McGreevy's across from the Hynes Convention Center. I ran into a bunch of fellow RHCA's and RHCE's who read my blog and I was glad some of the posts were able to help them along their way to becoming certified. Congratulations to the folks who passed the early rounds of the new JBoss exams! Being the first ones through that process certainly can't be easy.

For anyone who is working towards their RHCA, [be sure to read my post about my experience with it][6]. It's a long haul, but the knowledge you'll gain will be worth it.

 [1]: http://www.redhat.com/about/company/management/bios/management-team-paul-cormier-bio
 [2]: https://openshift.redhat.com/app/
 [3]: http://pl.atyp.us/
 [4]: http://people.redhat.com/tcameron/
 [5]: http://people.redhat.com/tcameron/Summit11/selinux/cameron_w_530_selinux_for_mere_mortals.pdf
 [6]: /2012/02/13/looking-back-at-the-long-road-to-becoming-a-red-hat-certified-architect/
