---
title: Going back to Linux as a desktop
author: Major Hayden
type: post
date: 2012-10-12T13:43:01+00:00
url: /2012/10/12/going-back-to-linux-as-a-desktop/
dsq_thread_id:
  - 3642807078
categories:
  - Blog Posts
tags:
  - linux
  - mac
  - sysadmin

---

Although I've been exclusively using a Mac for everything but servers since
about 2008, I found myself considering a move back to Linux on the desktop
after seeing how some people were using it at LinuxCon. My [conversion from
the iPhone to Android][1] was rocky for a very brief period and now I can't
think of a reason to ever go back. I approached Linux in the same way and
ordered a new ThinkPad shortly after returning from the conference.

The ThinkPad ordering experience was one of the worst retail experiences I've
had so far but that's a separate discussion for a separate post (that's on the
way soon). This post is focused only on my experience getting back into a
Linux desktop for the first time in four years.

**The Good**

Linux hardware support has come a really long way over the past few years. All
of my hardware was recognized and configured in Fedora 17 without any action
on my part. The fingerprint reader has some proprietary firmware that couldn't
be automatically loaded (which didn't bother me much). Getting network
connectivity via ethernet, WiFi and even a 4G USB stick was surprisingly
simple. Battery life was longer in Linux than in Windows and I was glad to see
that the power management features were working well and already configured
how I'd like them to be.

I knew I wasn't a fan of GNOME 3 already, so I loaded up KDE and XFCE. Both
worked extremely well with great performance. Desktop effects were really
responsive and I never saw flickering, crashes, or artifacts. Those were a lot
more frequent previously. I eventually settled into the i3 window manager and
got into a keyboard-based workflow with tiled windows. It was shocking to see
how much time I could save with a tiled window manager when I wasn't pushing
and resizing windows every time I opened a new app or a new window.

The raw X performance has improved drastically. In i3, I rarely found myself
waiting for anything to render and any changes to my desktop were speedy. Font
smoothing and rendering has also come a long way. OS X still leads this
category for me, but I was glad to see some serious advancements in Linux in
this area.

One of the biggest worries I had about Linux was email. I need Exchange
connectivity with good calendaring support for work and I didn't enjoy using
Evolution in the past. My choice this time around was Thunderbird with the
Lightning plugin for calendaring and Enigmail for GPG signing and encryption.
I stacked that on the davmail gateway for Exchange connectivity. This worked
_surprisingly_ well. The performance could have been a bit better, but as far
as functionality is concerned, everything I tried worked. Creating meeting
invitations, responding to meeting invitations, handling email, and searching
the GAL was a relatively smooth experience.

Chrome was easy to install and very stable. Using Skype with video was a
breeze and I was on TeamSpeak calls with my team at work within a few minutes.
I had a slew of terminals to choose from and I settled on [terminator][2]
since I could have tiled terminals in my tiled window manager (which I'm sure
Xzibit would approve).

Virtualization was simple and I was a few package installs away from running
KVM. Xen also worked well via virt-manager and the performance was excellent.
I installed VMWare Workstation since it was my favorite before, but it caused
stack traces in the kernel and I eventually had to remove it.

**The Bad**

I have yet to find a Twitter client for Linux that I enjoy using. It took me
forever to find even one application which used Twitter's streaming API (which
was released almost three years ago). Many of the applications were either
difficult to use, had confusing UI's, or wasted so much screen real estate
that they became a nuisance. Text-based clients looked good at first glance
but then I became frustrated with the inability to quickly see conversations
or see what a particular reply was referring to in my timeline. My current Mac
client is [Yorufukurou][3].

Music management was another sore spot. Some applications, like audacious, fit
the bill perfectly for basic internet radio streaming and playing small
albums. If I tried to look for an application to replace iTunes (library
management, internet radio, podcasts, and sync with a mobile device), I ended
up with Songbird, amarok and rhythmbox. Songbird was fair but lacked a lot of
features that I was eager to get. At first, amarok and rhythmbox looked like
winners but managing a library with them was taking much more time than I was
willing to invest.

The ThinkPad screen is very washed out by default but I found quite a few
forum posts talking about applying ICM profiles to correct it. Quite a few
people made that adjustment in Windows with some very good results. I tried to
do the same in Fedora 17 but struggled after working through several different
methods. Fedora 18 is going to have gnome-color-manager from the start and it
will probably make that process a little easier. Getting a DisplayLink adapter
working in Fedora 17 was problematic but I've read that native support for
configuring these devices is coming soon.

**Conclusion**

Linux on the desktop has really improved a substantial amount but I'm leaning
back towards the Mac. Although a portion of that decision centers around the
Mac hardware, the majority of the decision hinges on my workflow and the
quality of the applications available for my specific needs. I found myself
much less distracted in Linux mainly because it was more difficult for me to
interact with my coworkers and friends than it was on the Mac.

For a fair fight, I may try to get Linux going on my MacBook to ensure I'm
comparing apples to apples. I'll save that for later this year when Fedora 18
is released.

Keep in mind that everyone has a unique workflow and mine may be much
different than yours. I'm eager to read your comments and I welcome any
feedback you have.

 [1]: /2012/09/06/one-week-with-android/
 [2]: https://terminator-gtk3.readthedocs.io/en/latest/
 [3]: https://sites.google.com/site/yorufukurou/home-en
