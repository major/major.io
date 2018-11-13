---
title: 'IBM Edge 2016: Day 1 Recap'
author: Major Hayden
type: post
date: 2016-09-20T20:19:48+00:00
url: /2016/09/20/ibm-edge-2016-day-1-recap/
dsq_thread_id:
  - 5159712495
categories:
  - Blog Posts
tags:
  - hardware
  - ibm
  - linux
  - power

---
[<img src="/wp-content/uploads/2016/09/IMG_20160919_090354077_TOP-e1474402617332.jpg" alt="IBM Edge 2016 Day 1" width="1024" height="309" class="aligncenter size-full wp-image-6434" srcset="/wp-content/uploads/2016/09/IMG_20160919_090354077_TOP-e1474402617332.jpg 1024w, /wp-content/uploads/2016/09/IMG_20160919_090354077_TOP-e1474402617332-300x91.jpg 300w, /wp-content/uploads/2016/09/IMG_20160919_090354077_TOP-e1474402617332-768x232.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][1]I am here in Las Vegas for [IBM Edge 2016][2] to learn about the latest developments in POWER, machine learning, and OpenStack. It isn't just about learning - I'm sharing some of our own use cases and challenges from my daily work at [Rackspace][3].

I kicked off the day with a great run down the Las Vegas strip. There are many more staircases and escalators than I remember, but it was still a fun run. The sunrise was awesome to watch as all of the colors began to change:

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    One of the rewards for getting out early to run: sunrise on the Vegas Strip. <a href="https://twitter.com/hashtag/IBMEdge?src=hash">#IBMEdge</a> <a href="https://t.co/Xc11HJ6Pv9">pic.twitter.com/Xc11HJ6Pv9</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/777860950779191296">September 19, 2016</a>
  </p>
</blockquote>



Without further ado, let's get to the recap.

## General Session

Two of the talks in the general session caught my attention: OpenPOWER and Red Bull Racing.

The OpenPOWER talk showcased the growth in the OpenPOWER ecosystem. It started with only five members, but it's now over 250. IBM is currently offering OpenPOWER-based servers and Rackspace's Barreleye design is available for purchase from various vendors.

Red Bull Racing kicked off with an amazing video about the car itself, the sensors, and what's involved with running in 21 races per year. The highlight of the video for me was seeing the F1 car round corners on a mountain while equipped with snow chains.

The car itself has 100,000 components and the car is disassembled and reassembled for each race based on the race conditions. Due to restrictions on how often they can practice, they run over 50,000 virtual simulations per year to test out different configurations and parts. Each race generates 8 petabytes of data and it is live-streamed to the engineers at the track as well as an engineering team in the UK. They can make split second choices on what to do during the race based on this data.

They gave an example of a situation where something was wrong with the car and the driver needed to make a pit stop. The engineers looked over the data that was coming from the car and identified the problem. Luckily, the driver could fix the issue by flipping a switch on the steering wheel. The car won the race by less than a second.

## Breakouts

My first stop on breakouts was [Trends and Directions in IBM Power Systems][4]. We had a high-level look at some of the advancements in POWER8 and OpenPOWER. Two customers shared their stories around why POWER was a better choice for them than other platforms, and everyone made sure to beat up on Moore's Law at every available opportunity. Rackspace was applauded for its leadership on Barreleye!

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    Just spotted <a href="https://twitter.com/Rackspace">@Rackspace</a> public cloud mentioned in the OpenPOWER talk at <a href="https://twitter.com/hashtag/ibmedge?src=hash">#ibmedge</a>! <a href="https://t.co/Fta6VRSMyu">pic.twitter.com/Fta6VRSMyu</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/777930188264906752">September 19, 2016</a>
  </p>
</blockquote>



The most interesting session of the day was the [IBM POWER9 Technology Advanced Deep Dive][5]. Jeff covered the two chips in detail and talked about some of the new connections between the CPU and various components. I'm interested in the hardware GZIP acceleration, NVLINK, and CAPI advancements. The connections to CAPI will be faster, thanks to the Power Service Layer (PSL) moving from the CAPI chip to the CPU itself. This reduces latency when communicating with the accelerator chip.

POWER9 has 192GB/sec on the PCIe Gen4 bus (that's 48 lanes) and there's 300GB/sec (25Gbit/sec x 48 lanes) of duplex bandwidth available for what's called _Common Link_. Common Link is used to communicate with accelerators or remote SMP and it will likely be called "Blue Link" at a later date. Very clever, IBM.

I wrapped the day with Calista Redmond's [OpenPower Revolution in the Datacenter][6]. She talked about where the OpenPOWER foundation is today and where it's going in the future.

## EXPO

As you might expect, IBM has most of the EXPO floor set aside for themselves and they're showing off new advances in POWER, System z, and LinuxONE. I spent a while looking at some of the new POWER8 chassis offerings and had a good conversation with some LinuxONE experts about some blockchain use cases.

IBM hired DJ Andrew Hypes and DJ Tim Exile to make some unique music by sampling sounds in a datacenter. They sampled sounds from IBM servers and storage devices and created some really unique music. It doesn't sound anything like a datacenter, though (thank goodness for that).

<span class="embed-youtube" style="text-align:center; display: block;"><iframe class='youtube-player' type='text/html' width='640' height='360' src='https://www.youtube.com/embed/ZORBcubiV3I?version=3&#038;rel=1&#038;fs=1&#038;autohide=2&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;wmode=transparent' allowfullscreen='true' style='border:0;'></iframe></span>

The [Red Bull Racing][7] booth drew a fairly large crowd throughout the evening. They had one of their F1 cars on site with its 100+ sensors:

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    Red Bull Racing at <a href="https://twitter.com/hashtag/IBMEdge?src=hash">#IBMEdge</a>! <a href="https://t.co/GSWNBjaP9b">pic.twitter.com/GSWNBjaP9b</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/777676547394244608">September 19, 2016</a>
  </p>
</blockquote>



## Summary

The big emphasis for the first day was on using specialized hardware for specialized workloads. Moore's Law took a beating throughout the day as each presenter assured the audience that 2x performance gains won't come in the chip itself for much longer.

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    How I feel after day one of <a href="https://twitter.com/hashtag/IBMEdge?src=hash">#IBMEdge</a>: ? <a href="https://t.co/mqqqwYP0I4">pic.twitter.com/mqqqwYP0I4</a>
  </p>

  <p>
    &mdash; Major Hayden (@majorhayden) <a href="https://twitter.com/majorhayden/status/778046768789397505">September 20, 2016</a>
  </p>
</blockquote>



It won't be possible to achieve the performance we want in the future on the backs of software projects alone. We will need to find ways to be smarter about how we run software on our servers. When something is ripe for acceleration, especially CPU-intensive, repetitive workloads, we should find a way to accelerate it in hardware. There are tons of examples of this already, like AES encryption acceleration, but we will need more acceleration capabilities soon.

 [1]: /wp-content/uploads/2016/09/IMG_20160919_090354077_TOP-e1474402617332.jpg
 [2]: http://www-03.ibm.com/systems/edge/
 [3]: http://www.rackspace.com/
 [4]: http://ibm-edge-2016-notes.readthedocs.io/en/latest/trends-and-directions-ibm-power-systems.html
 [5]: http://ibm-edge-2016-notes.readthedocs.io/en/latest/ibm-power-9-technology-deep-dive.html
 [6]: http://ibm-edge-2016-notes.readthedocs.io/en/latest/openpower-revolution-in-the-datacenter.html
 [7]: https://twitter.com/redbullracing
