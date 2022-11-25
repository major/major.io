---
title: Lifehacker effect on icanhazip.com
author: Major Hayden
date: 2011-03-30T13:28:55+00:00
url: /2011/03/30/lifehacker-effect-on-icanhazip-com/
dsq_thread_id:
  - 3678941872
tags:
  - command line
  - icanhazip
  - web

---
I was surprised to see coverage about [icanhazip.com][1] on [Lifehacker][2] last Sunday and I was curious to know what effect the story would have on my site's overall traffic. [Dave Drager][3] wrote a great summary of what the site offers and how people can use it in their daily work. It's pretty obvious that icanhazip.com really only serves a niche group of internet users, but even I was surprised at the level of interest.

![lifehacker_graph] icanhazip.com traffic data - March 2011

The graph on the right shows some recent traffic data from March 2011. The Lifehacker story was published around 7AM on March 27th in Australia, so I first started seeing a spike on the 26th (my server's time zone is UTC-5). The yellow bar is a count of the unique visits while the other bars count page views, hits and total bandwidth.

The count of unique visitors certainly increased (by about 10-11x), but the overall hits didn't increase by much. I'd imagine that most visitors accessed the site, noticed that it displayed their public IP, and then they went on their way. As I've said before, this site is easy to re-create and will really only serve a niche segment of internet users.

On most days, I'll receive a very high number of hits from a relatively small number of unique IP addresses. There are quite a few people who check their public-facing IP address every second, but it seems like the majority stick to a more reasonable interval of 5-30 minutes. I've yet to find the value in checking my public IP address once per second, but there are obviously some folks out there who find it valuable (or they aren't good at implementing sleeps in their scripts).

Here's a bit of trivia about the site for those who are interested:

* Almost 40% of the traffic to the site is from Eastern European and Asian countries
* The average user on the site generates about 45 hits per day
* Linux users make up 91% of the traffic on the site (based on user agent strings)
* Over 88% of the hits to the site are requests made with curl or wget
* Most traffic is received between 4-5PM CDT
* Almost 98% of the visitors who reach the site do so via a direct link without a referrer

 [1]: http://rackerhacker.com/icanhazip-com-faq/
 [2]: http://www.lifehacker.com.au/2011/03/find-your-public-ip-anywhere-with-icanhazip-com/
 [3]: http://www.lifehacker.com.au/author/dave-drager/
 [lifehacker_graph]: /wp-content/uploads/2011/03/icanhazip_lifehacker_traffic.jpg
