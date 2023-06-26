---
aliases:
- /2012/06/08/keep-tabs-on-openstack-development-with-openstack-watch-on-twitter/
author: Major Hayden
date: 2012-06-08 12:19:26
tags:
- development
- openstack
- python
- twitter
title: Keep tabs on OpenStack development with OpenStack Watch on Twitter
---

It's no secret that I'm a fan of [Twitter][1] and [OpenStack][2]. I found myself needing a better way to follow the rapid pace of OpenStack development and I figured that a Twitter bot would be a pretty good method for staying up to date.

I'd like to invite you to check out [@openstackwatch][3].

First things first, it's a completely unofficial project that I worked on during my spare time and it's not affiliated with OpenStack in any way. If it breaks, it's most likely my fault.

The bot watches for ticket status changes in [OpenStack's Gerrit server][4] and makes a tweet about the change within a few minutes. Every tweet contains the commit's project, owner, status, and a brief summary of the change. In addition, you'll get a link directly to the review page on the Gerrit server. Here's an example:

<div id="attachment_3452" style="width: 457px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2012/06/openstackwatchtweet.jpg"><img src="/wp-content/uploads/2012/06/openstackwatchtweet.jpg" alt="" title="openstackwatchtweet" width="447" height="154" class="size-full wp-image-3452" srcset="/wp-content/uploads/2012/06/openstackwatchtweet.jpg 447w, /wp-content/uploads/2012/06/openstackwatchtweet-300x103.jpg 300w" sizes="(max-width: 447px) 100vw, 447px" /></a>

  <p class="wp-caption-text">
    Hey! It's Dan!
  </p>
</div>

If you're not a fan of Twitter, there's a link to the RSS feed in the bio section, or you can just add this URL to your RSS feed reader:

  * [http://api.twitter.com/1/statuses/user\_timeline.rss?screen\_name=openstackwatch][5]

If you can come up with any ideas for improvements, please [let me know][6]!

 [1]: http://twitter.com/
 [2]: http://openstack.org/
 [3]: http://twitter.com/openstackwatch
 [4]: http://review.openstack.org/
 [5]: http://api.twitter.com/1/statuses/user_timeline.rss?screen_name=openstackwatch
 [6]: http://twitter.com/rackerhacker