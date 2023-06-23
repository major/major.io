---
aliases:
- /2016/01/15/nobody-using-software-project-now/
author: Major Hayden
date: 2016-01-15 17:35:48
tags:
- development
- general advice
- python
title: Nobody is using your software project. Now what?
---

![cover]

Working with open source software is an amazing experience. The collaborative process around creation, refinement, and even maintenance, drives more developers to work on open source software more often. However, every developer finds themselves writing code that very few people _actually use_.

For some developers, this can be really bothersome. You offer your code up to the world only to find that the world is much less interested than you expected. We see projects that fit the ["build it, and they will come"][1] methodology all the time, but it can hurt when our projects don't have the same impact.

Start by asking yourself a question:

## Does it matter?

Many of us write software that has a very limited audience. Perhaps we wrote something that worked around a temporary problem or solved an issue that very few poeple would see. Sometimes we write software to work with a project that doesn't have a large user base.

In these situations, it often doesn't matter if other contributors don't show up to collaborate.

However, if you're eager to build a community around an open source project, here are some tips that have worked well for me.

## Make it approachable

Sites like [StackOverflow][2] became immensely popular over time because they provide simple, approachable solutions that normally come with a small amount of explanation. Not all of the code snippets are examples of high quality software development, but that's not the point here. People can search, review something, and get on their way.

Making software more approachable is completely based on your audience. Complicated software, like the [cryptography][3] Python library, has an approach towards experienced software developers who want a robust method for handling cryptographic operations. Compare that to the [requests][4] Python library. The developers on that project have an audience of Python developers of all skill levels and they lead off with a simple example and very approachable documentation.

Both of those approaches are very different but extremely effective to their respective audiences.

Once you know your audience, make these changes to make your software more approachable to them:

  * **Describe your project's sweet spot.** what does it do better than every other project?
  * **What does your project not do well?** This could clue developers into better projects for their needs or entice them to submit patches for improvements.
  * **How do developers get started?** This should include simple ways to install the software, test it after installation, and examples of ways to quickly begin using it.
  * **How do you want to receive improvements?** If someone finds a bug or area for improvement, how should they submit it and what should their expectations be?

If you haven't figured it out already, **documentation is required**. Projects without documentation are quickly skipped over by most developers for a good reason: if you haven't taken the time to help people understand how to use your project, why should they take the time to understand it themselves. Projects without documentation are often assumed to be less mature and not production-ready.

Once you make it this far, it's time to [charge your extrovert battery][5] and promote it.

## Promoting the project

Some of the best-written software projects with the best documentation often find themselves limited by the fact that nobody knows they exist. This can become a challenging problem to solve because it involves actively reaching out to the audience you've identified in the previous steps.

The first step is to do some writing about your software project and what problems it tries to solve. The type of writing and the medium for sharing it is completely up to you.

Some people prefer [writing blog posts][6] on their own blog. You may be able to get additional readers by publishing it on external sites, such as [Medium][7], or as a guest author on another site. For example, [opensource.com][8] invites guest authors to write about various software projects or solutions provided by open source software. If your project is closely affiliated with another large software project, you may be able to publish a post as a guest author on their project site.

Social media can be helpful if it's used wisely with the right audience. Your followers must be able to get some value from whatever you link them to in your social media posts. Steer clear of clickbait-type posts and be genuine. If you want to build a community, your integrity is your most important asset.

## Technical talks

The most effective method for sharing a project is to do it in person. Yes, this means giving a technical talk to an audience. That means standing in front of people. It's the kind of thing that make an introvert pause. However, if you care about your project, you can [tame that technical talk][9] and make a great connection with your audience.

The return on investment in technical talks often takes the form of a [decrescendo][10]. Feedback flows in quickly as soon as the talk is over and gradually decreases over time. The rate of decrease largely depends on the impact you make on your audience. A high-impact, emotionally appealing presentation will yield a long tail of feedback that decreases very slowly. Your project might appear in presentations made by other people and you'll often get additional feedback and involvement from those talks as well.

_Photo Credit: [Wanaku][11] via [Compfight][12] [cc][13]_

 [1]: https://en.wikipedia.org/wiki/Field_of_Dreams
 [2]: http://stackoverflow.com/
 [3]: https://cryptography.io/en/latest/
 [4]: http://docs.python-requests.org/en/latest/
 [5]: http://www.psychotactics.com/the-main-difference-between-extroverts-and-introverts/
 [6]: http://blog.rackspace.com/why-technical-people-should-blog-but-dont/
 [7]: http://medium.com
 [8]: http://opensource.com
 [9]: http://www.slideshare.net/MajorHayden/taming-the-technical-talk
 [10]: https://en.wikipedia.org/wiki/Dynamics_(music)#Gradual_changes
 [11]: https://www.flickr.com/photos/56944665@N00/8627526293/
 [12]: http://compfight.com
 [13]: https://creativecommons.org/licenses/by-nc-nd/2.0/
 [cover]: /wp-content/uploads/2016/01/8627526293_6d3f0edd17_b-e1452879213307.jpg