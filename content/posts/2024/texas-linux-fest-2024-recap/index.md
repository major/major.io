---
author: Major Hayden
date: '2024-04-16'
summary: |
  I gave two talks at this year's event and ran into lots of old friends and colleagues. 🐧
tags: 
  - centos
  - fedora
  - linux
  - presentation
title: Texas Linux Fest 2024 recap 🤠
coverAlt: Austin skyline as seen from the south side of the river
coverCaption: |
  I took this photo in Austin!
---

The 2024 [Texas Linux Festival](https://2024.texaslinuxfest.org/) just ended last weekend and it was a fun event as always.
It's one my favorite events to attend because it's really casual.
You have plenty of opportunities to see old friends, meet new people, and learn a few things along the way.

I was fortunate enough to have two talks accepted for this year's event.
One was focused on containers while the other was a (very belated) addition to my [impostor syndrome talk](/p/impostor-syndrome-talk-faqs-and-follow-ups/) from 2015.

This was also my first time building slides with [reveal-md](https://github.com/webpro/reveal-md), a "batteries included" package for making [reveal.js](https://revealjs.com/) slides.
Nothing broke too badly and that was a relief.

## Containers talk

I've wanted to share more of what I've done with CoreOS in low-budget container deployments and this seemed like a good time to share it with the world out loud.
My talk, [Automated container updates with GitHub and CoreOS](https://txlf24-containers.major.io/#/), walked the audience through how to deploy containers on CoreOS, keep them updated, and update the container image source.

My goal was to keep it as low on budget as possible.
Much of it was centered around a stack of [caddy](/p/caddy-porkbun/), librespeed, and docker-compose.
All of it was kept up to date with [watchtower](/p/watchtower/).

My custom Caddy container needed support for [Porkbun's](https://porkbun.com/) DNS API and I used GitHub Actions to build that container and serve it to the internet using GitHub's package hosting.
_This also gave me the opportunity to share how awesome Porkbun is for registering domains, including their [customized pig artwork](https://porkbun.com/tld/jobs) for every TLD imaginable._ 🐷

We had a great discussion afterwards about how CoreOS **does indeed live on** as [Fedora CoreOS](https://fedoraproject.org/coreos/).

## Tech career talk

This talk made me nervous because it had a lot of slides to cover, but I also wanted to leave plenty of time for questions.
[Five tips for a thriving technology career](https://txlf24-tech-career.major.io/#/) built upon my old impostor syndrome talk by sharing some of the things I've learned over the year that helped me succeed in my career.

I managed to end early with time for questions, and boy did the audience have questions! 📣
Some audience members helped me answer some questions, too!

We talked a lot about office politics, tribal knowledge, and toxic workplaces.
The audience generally agreed that most businesses tried to rub copious amounts of Confluence on their tribal knowledge problem, but it never improved. 😜

The room was full with people standing in the back and I'm tremendously humbled by everyone who came.
I received plenty of feedback afterwards and that's the best gift I could ever get. 🎁

## Other talks

[Anita Zhang](https://github.com/anitazha) had an excellent keynote talk on the second day about her unusual path into the world of technology.
Her slides were pictures of her dog that lined up with various parts of her story.
That was a great idea.

[Kyle Davis](https://www.linkedin.com/in/kyle-davis-linux/?originalSubdomain=ca) offered talks on [valkey](https://github.com/valkey-io/valkey) and [bottlerocket](https://github.com/bottlerocket-os/bottlerocket).
There was plenty about the redis and valkey story that I didn't know and the context was useful.
It looks like you can simply drop valkey into most redis environments without much disruption.

[Thomas Cameron](https://www.linkedin.com/in/thomascameron/) talked about running OKD on Fedora CoreOS in his home lab.
There were quite a few steps, but he did a great job of connecting the dots between what needed to be done and why.

## Around the exhibit hall

I helped staff the Fedora/CoreOS booth and we had plenty of questions.
Most questions were around the M1 Macbook running [Asahi Linux](https://asahilinux.org/) that was on the table. 😉

There were still quite a few misconceptions around the CentOS Stream changes, as well as how AlmaLinux and Rocky Linux fit into the picture.
Our booth was right next to the AlmaLinux booth and I had the opportunity to meet [Jonathan Wright](https://jonathanspw.com/about/).
That was awesome!

**I can't wait for next year's event.**
