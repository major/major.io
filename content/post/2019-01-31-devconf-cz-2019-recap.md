---
title: DevConf.CZ 2019 Recap
author: Major Hayden
type: post
date: "2019-01-31"
slug: devconf.cz-2019-recap
categories:
  - Blog Posts
tags:
  - events
  - presentations
  - linux
  - open source
  - devconf
  - red hat
---

[DevConf.CZ 2019] wrapped up last weekend and it was a great event packed
with lots of knowledgeable speakers, an engaging hallway track, and delicious
food. This was my first trip to any DevConf and it was my second trip to
[Brno].

Lots of snow showed up on the second day and more snow arrived later in the
week!

[![devconf-snow-small]](/images/20190131-devconf-2019-snow.jpg)

[DevConf.CZ 2019]: https://devconf.info/cz
[Brno]: https://en.wikipedia.org/wiki/Brno
[devconf-snow-small]: /images/20190131-devconf-2019-snow-720.jpg
[devconf-snow]: /images/20190131-devconf-2019-snow.jpg

## First talk of 2019

I co-presented a talk with one of my teammates, Nikolai, about some of the
fun work we've been doing at Red Hat to improve the quality of the Linux
kernel in an automated way. The room was full and we had lots of good
questions at the end of the talk. We also received some feedback that we
could take back to the team to change how we approached certain parts of the
kernel testing.

![devconf-major-nikolai]

Our project, called Continuous Kernel Integration (CKI), has a goal of
reducing the amount of bugs that are merged into the Linux kernel. This
requires lots of infrastructure, automation, and testing capabilities. We
shared information about our setup, the problems we've found, and where we
want to go in the future.

Feel free to [view our slides] and watch the video (which should be up soon.)

[devconf-major-nikolai]: /images/20190131-devconf-major-nikolai.jpg
[view our slides]: https://www.slideshare.net/MajorHayden/cookies-for-kernel-developers

## Great talks from DevConf

My favorite talk of the conference was [Laura Abbott's] "Monsters, Ghosts, and
Bugs."

![devconf-laura-abbott]

It's the most informative, concise, and sane review of how all the Linux
kernels on the planet fit together. From the insanity of linux-next to the
wild world of being a Linux distribution kernel maintainer, she helped us all
understand the process of how kernels are maintained. She also took time to
help the audience understand which kernels are most important to them and how
they can make the right decisions about the kernel that will suit their
needs. There are [plenty of good points in my Twitter thread] about her talk.

Dan Walsh gave a detailed overview of how to use Podman instead of Docker. He
talked about the project's origins and some of the incorrect assumptions that
many people have (that running containers means only running Docker). Running
containers without root has plenty of benefits. In addition, a significant
amount of work has been done to speed up container pulls and pushes in
Podman. I took some [notes on Dan's talk] in a thread on Twitter.

The firewalld package has gained some new features recently and it's poised
to fully take advantage of nftables in Fedora 31! Using nftables means that
firewall updates are done faster with fewer hiccups in busy environments
(think OpenStack and Kubernetes). In addition, nftables can apply rules to
IPv4 and IPv6 simultaneously, depeending on your preferences. My [firewalld
Twitter thread] has more details from the talk.

The cgroups v2 subsystem was a popular topic in a few of the talks I visited,
including the lightning talks. There are plenty of issues to get it working
with Kubernetes and container management systems. It's also missing the
[freezer capability] from the original cgroups implementation. Without that,
pausing a container, or using technology like [CRIU], simply won't work.
Nobody could name a Linux distribution that has cgroups v2 enabled at the
moment, and that's not helping the effort move forward. Look for more news on
this soon.

![devconf-openshift-pun]

OpenShift is quickly moving towards offering multiple architectures as a
first class product feature. That would incluve aarch64, ppc64le, and s390x
in addition to the existing x86_64 support. Andy McCrae and Jeff Young had a
talk detailing many of the challenges along with lots of punny references to
various "arches". I made a [Twitter thread of the main points] from the
OpenShift talk.

Some of the other news included:

* [real-time linux patches] are likely going to be merged into mainline.
  (only 15 years in the making!)
* Fedora, CentOS, RHEL and EPEL communities are eager to bring more of their
  processes together and make it easier for contributors to join in.
* Linux 5.0 is no more exciting than 4.20. It would have been 4.21 if Linus
  had an [extra finger or toe].

## DevConf.US Boston 2019

The next DevConf.US is in Boston, USA this summer. I hope to see you there!

[Laura Abbott's]: https://twitter.com/openlabbott
[devconf-laura-abbott]: /images/20190131-devconf-laura-abbott-720.jpg
[plenty of good points in my Twitter thread]: https://twitter.com/majorhayden/status/1089507679977046017
[notes on Dan's talk]: https://twitter.com/majorhayden/status/1088715555635220481
[firewalld Twitter thread]: https://twitter.com/majorhayden/status/1088807448817876992
[freezer capability]: https://www.kernel.org/doc/Documentation/cgroup-v1/freezer-subsystem.txt
[CRIU]: https://criu.org/Main_Page
[Twitter thread of the main points]: https://twitter.com/majorhayden/status/1089470907607928833
[devconf-openshift-pun]: /images/20190131-devconf-openshif-pun-720.jpg
[real-time linux patches]: https://wiki.linuxfoundation.org/realtime/start
[extra finger or toe]: https://www.theregister.co.uk/2019/01/07/linux_reaches_the_big_five_point_oh/
