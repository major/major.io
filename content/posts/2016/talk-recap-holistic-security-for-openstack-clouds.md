---
aliases:
- /2016/10/31/talk-recap-holistic-security-for-openstack-clouds/
author: Major Hayden
date: 2016-10-31 15:52:47
dsq_thread_id:
- 5267743335
featured_image: /wp-content/uploads/2016/10/Holistic-Security-for-OpenStack-Clouds-OpenStack-Summit-Barcelona-2.png
tags:
- network
- networking
- openstack
- presentation
- security
title: 'Talk Recap: Holistic Security for OpenStack Clouds'
---

![1]

Thanks to everyone who attended my talk at the OpenStack Summit in Barcelona! I really enjoyed sharing some tips with the audience and it was great to meet some attendees in person afterwards.

If you weren't able to make it, don't fret! This post will cover some of the main points of the talk and link to the video and slides.

## Purpose

OpenStack clouds are inherently complex. Operating a cloud involves a lot of moving pieces in software, hardware, and networking. Securing complex systems can be a real challenge, especially for newcomers to the information security realm. One wrong turn can knock critical infrastructure online or lead to lengthy debugging sessions.

However, securing OpenStack clouds doesn't need to be a tremendously stressful experience. It requires a methodical, thoughful, and strategic approach. The goal of the talk is give the audience a reliable strategy that is easy to start with and that scales easily over time.

## Why holistic?

The dictionary definition of _holistic_ is:

> characterized by comprehension of the parts of something as intimately connected and explicable only by reference to the whole

To simplify things a bit, thinking about something holistically means that you understand that there are small parts that are valuable on their own, but they make much more value when combined together. Also, it's difficult to talk about the individual parts and get a real understanding of the whole.

In holistic medicine, humans are considered to be a body, mind, and spirit. OpenStack clouds involve servers, software, and a business goal. Security consists of people, process, and technology. To truly understand what's going on, you need to take a look at something with all of its parts connected.

## Security refresher

Get into the mindset that **attackers will get in eventually**. Just change each instance of _if_ to _when_ in your conversations. Attackers can be wrong many times, but the defenders only need to be wrong once to allow a breach to occur.

Simply building a huge moat and tall castle walls around the outside isn't sufficient. Attackers will have free reign to move around inside and take what they want. Multiple layers are needed, and this is the backbone of a _defense-in-depth_ strategy.

Cloud operators need to work from the outside inwards, much like you do with utensils at a fancy dinner. Make a good wall around the outside and work on tightening down the internals at multiple levels.

## Four layers for OpenStack

During the talk, I divided OpenStack clouds into four main layers:

  * outer perimeter
  * control and data planes
  * OpenStack services and backend services in the control plane
  * OpenStack services

For the best explanation of what to do at this level, I highly recommend reviewing the slides or the presentation video (keep scrolling).

## Links and downloads

The slides are on [SlideShare][2] and they are licensed [CC-BY-SA][3]. Feel free to share anything from the slide deck as you wish, but please share it via a similar license and attribute the source!

The video of the talk (including Q&A) is up on YouTube:

<span class="embed-youtube" style="text-align:center; display: block;"><iframe class='youtube-player' type='text/html' width='640' height='360' src='https://www.youtube.com/embed/ehfSLZVCVLA?version=3&#038;rel=1&#038;fs=1&#038;autohide=2&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;wmode=transparent' allowfullscreen='true' style='border:0;'></iframe></span>

## Feedback

I love feedback about my talks! I'm still a novice presenter and every little bit of feedback - positive or negative - really helps. Feel free to [email me][4] or talk to me on [Twitter][5].

 [1]: /wp-content/uploads/2016/10/Holistic-Security-for-OpenStack-Clouds-OpenStack-Summit-Barcelona-2.png
 [2]: http://www.slideshare.net/MajorHayden/holistic-security-for-openstack-clouds
 [3]: https://creativecommons.org/licenses/by-sa/2.0/?
 [4]: mailto:major@mhtx.net
 [5]: https://twitter.com/majorhayden