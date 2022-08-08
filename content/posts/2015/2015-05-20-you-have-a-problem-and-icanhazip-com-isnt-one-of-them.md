---
title: You have a problem and icanhazip.com isn’t one of them
author: Major Hayden
date: 2015-05-20T12:50:41+00:00
url: /2015/05/20/you-have-a-problem-and-icanhazip-com-isnt-one-of-them/
dsq_thread_id:
  - 3779544516
tags:
  - icanhazip
  - security

---
![1]

I really enjoy operating [icanhazip.com][2] and the [other domains][3]. It's fun to run some really busy services and find ways to reduce resource consumption and the overall cost of hosting.

My brain has a knack for optimization and improving the site is quite fun for me. So much so that I've decided to host all of icanhazip.com out of my own pocket starting today.

**However, something seriously needs to change.**

A complaint came in yesterday from someone who noticed that their machines were making quite a few requests to icanhazip.com. It turns out there was a problem with malware and the complaint implicated my site as part of the problem. One of my nodes was taken down as a precaution while I furiously worked to refute the claims within the complaint. Although the site stayed up on other nodes, it was an annoyance for some and I received a few tweets and emails about it.

Long story short, if you're sending me or my ISP a complaint about icanhazip.com, there's one thing you need to know: **the problem is on your end, not mine**. Either you have users making legitimate requests to my site or you have malware actively operating on your network.

No, it's not time to panic.

**You can actually use icanhazip.com as a tool to identify problems on your network.**

For example, add rules to your intrusion detection systems (IDS) to detect requests to the site in environments where you don't expect those requests to take place. Members of your support team might use the site regularly to test things but your Active Directory server shouldn't start spontaneously talking to my site overnight. That's a red flag and you can detect it **easily**.

Also, don't report the site as malicious or hosting malware when it's not. I've been accused of distributing malware and participating in attacks but then, after further investigation, it was discovered that I was only returning an IPv4 address to a valid request. That hardly warrants the blind accusations that I often receive.

I've taken some steps to ensure that there's a way to contact me with any questions or concerns you might have. For example:

  * You can email abuse, postmaster, and security at icanhazip.com anytime
  * There's a HTTP header with a link to the FAQ (which has been there for years)
  * I monitor any tweets or blog posts that are written about the site

As always, if you have questions or concerns, please reach out to me and read the [FAQ][3]. Thanks to everyone for all the support!

_Photo Credit: [Amir Kamran][4] via [Compfight][5] [cc][6]_

 [1]: /wp-content/uploads/2015/05/5662811240_d686e98683_b-e1432125864107.jpg
 [2]: https://icanhazip.com/
 [3]: /icanhazip-com-faq/
 [4]: https://www.flickr.com/photos/9813317@N08/5662811240/
 [5]: http://compfight.com
 [6]: https://www.flickr.com/help/general/#147
