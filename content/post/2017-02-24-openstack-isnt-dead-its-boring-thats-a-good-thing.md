---
title: OpenStack isn’t dead. It’s boring. That’s a good thing.
author: Major Hayden
type: post
date: 2017-02-24T16:06:24+00:00
url: /2017/02/24/openstack-isnt-dead-its-boring-thats-a-good-thing/
featured_image: /wp-content/uploads/2017/02/1024px-Midtown_HDR_Atlanta-e1487943722280.jpg
categories:
  - Blog Posts
tags:
  - cloud
  - development
  - openstack
  - servers
  - virtualization

---
[<img src="/wp-content/uploads/2017/02/1024px-Midtown_HDR_Atlanta-e1487943722280-1024x350.jpg" alt="Atlanta Georgia OpenStack PTG" width="1024" height="350" class="aligncenter size-large wp-image-6608" srcset="/wp-content/uploads/2017/02/1024px-Midtown_HDR_Atlanta-e1487943722280.jpg 1024w, /wp-content/uploads/2017/02/1024px-Midtown_HDR_Atlanta-e1487943722280-300x103.jpg 300w, /wp-content/uploads/2017/02/1024px-Midtown_HDR_Atlanta-e1487943722280-768x263.jpg 768w" sizes="(max-width: 1024px) 100vw, 1024px" />][1]

_NOTE: The opinions shared in this post are mine alone and are not related to my employer in any way._

* * *

The first [OpenStack Project Teams Gathering (PTG)][2] event was held this week in Atlanta. The week was broken into two parts: cross-project work on Monday and Tuesday, and individual projects Wednesday through Friday. I was there for the first two days and heard a few discussions that started the same way.

> Everyone keeps saying OpenStack is dead.

> Is it?

**OpenStack isn't dead.** It's boring.

## "The report of my death was an exaggeration"

Mark Twain [said it best][3], but it works for OpenStack as well. The news has plenty of negative reports that cast a shadow over OpenStack's future. You don't have to look far to find them:

  * [HPE and Cisco Moves Hurt OpenStack's Public Cloud Story (Fortune)][4]
  * [Is Cisco killing off its OpenStack public cloud? (Computer Business Review)][5]
  * [OpenStack still has an enterprise problem][6]

This isn't evidence of OpenStack's demise, but rather a transformation. Gartner called OpenStack a ["science project"][7] in 2015 and now 451 Research Group is [saying something very different][8]:

> 451 Research Group estimates OpenStack's ecosystem to grow nearly five-fold in revenue, from US$1.27 billion market size in 2015 to US$5.75 billion by 2020.

A 35% CAGR sounds pretty good for a product in the middle of a transformation. In Texas, we'd say that's more than enough to ["shake a stick at"][9].

## The transformation

You can learn a lot about the transformation going on within OpenStack by reading analyst reports and other news online. I won't go into that here since that data is readily available.

Instead, I want to take a look at how OpenStack has changed from the perspective of a developer. My involvement with OpenStack started in the Diablo release in 2011 and my first OpenStack Summit was the Folsom summit in San Francisco.

Much of the discussion at that time was around the "minutiae" of developing software in its early forms. We discussed topics like how to test, how to handle a myriad of requirements that constantly change, and which frameworks to use in which projects. The list of projects was quite short at that time (there were only 7 main services in Grizzly). Lots of effort certainly poured into feature development, but there was a ton of work being done to keep the wheels from falling off entirely.

The discussions at this week's PTG were very different.

Most of the discussion was around adding new integrations, improving reliability, and increasing scale. Questions were asked about how to integrate OpenStack into existing enterprise processes and applications. Reliability discussions were centered less around making the OpenStack services reliable, but more around how to increase overall resiliency when other hardware or software is misbehaving.

Discussions or arguments about minutiae were difficult to find.

## Boring is good

**I'm not trying to say that working with OpenStack is boring.** Developing software within the OpenStack community is an enjoyable experience. The rules and regulations within most projects are there to prevent design mistakes that have appeared before and many of these sets of rules are aligned between projects. Testing code and providing meaningful reviews is also straightforward.

However, the drama, both unproductive and productive, that plagued the project in the past is diminishing. It still exists in places, especially when it comes to vendor relationships. (That's where most open source projects see their largest amounts of friction, anyway.)

This transformation may make OpenStack appear "dead" to some. The OpenStack community is solving different problems now. Many of them are larger and more difficult to solve. Sometimes these challenges take more than one release to overcome. Either way, many OpenStack developers are up for these new challenges, even if they don't make the headlines.

As for me: **bring on the boring**. Let's crush the hard stuff.

* * *

_Photo credit: By Mike (Flickr: DSC\_6831\_2\_3\_tonemapped) [[CC BY 2.0][10]], [via Wikimedia Commons][11]_

 [1]: /wp-content/uploads/2017/02/1024px-Midtown_HDR_Atlanta-e1487943722280.jpg
 [2]: https://www.openstack.org/ptg/
 [3]: http://www.thisdayinquotes.com/2010/06/reports-of-my-death-are-greatly.html
 [4]: http://fortune.com/2016/12/19/openstack-public-cloud/
 [5]: http://www.cbronline.com/news/cloud/public/cisco-killing-off-openstack-public-cloud/
 [6]: http://www.itworld.com/article/2699624/open-source-tools/openstack-still-has-an-enterprise-problem.html
 [7]: https://www.theregister.co.uk/2015/05/18/openstack_private_clouds_are_science_projects_says_gartner/
 [8]: http://www.informationweek.com/cloud/what-you-need-to-know-about-openstack/a/d-id/1328252
 [9]: http://english.stackexchange.com/questions/92393/origin-of-more-x-than-you-can-shake-a-stick-at
 [10]: http://creativecommons.org/licenses/by/2.0
 [11]: https://commons.wikimedia.org/wiki/File%3AMidtown_HDR_Atlanta.jpg
