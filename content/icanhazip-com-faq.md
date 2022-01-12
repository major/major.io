---
author: Major Hayden
date: '2021-07-05'
description: >
  The family of icanhaz sites help you get more information about your network connection.
images:
  - images/icanhazip-glasses.jpg
slug: icanhazip-com-faq
tags:
- icanhazip
- linux
- python
title: icanhazip.com FAQ
type: page
---

{{< figure src="/images/icanhazip-glasses.jpg" alt="glasses on a table in front of screens" position="center" >}}

## icanhazip.com has a new owner! 🎉

Starting in June 2021, icanhazip.com is now owned and operated by Cloudflare!
Read more about it in the blog post: [A new future for icanhazip].

All of the remaining sites are unchanged.

[A new future for icanhazip]: /2021/06/06/a-new-future-for-icanhazip/

## Which sites are available?

You have a few to choose from:

  * [icanhazip.com][1] - returns your IP address
  * [icanhazptr.com][2] - returns the [reverse DNS record][3] (PTR) for your IP
  * [icanhaztrace.com][4] - returns a [traceroute][5] from my servers to your IP address
  * [icanhaztraceroute.com][6] - returns a [traceroute][5] from my servers to your IP address
  * [icanhazepoch.com][7] - returns the [epoch time][8] (also called Unix time)
  * [icanhazproxy.com][9] - can determine if your traffic is being proxied

## Why should I use these services when there are plenty of other ones out there?

My services return all data in plain text without any advertisements or extra data. I also monitor the services to ensure they're always available.

## How do I control whether I get results based on IPv4 or IPv6?

There are two helper subdomains for icanhazip.com: [ipv4.icanhazip.com][10] and [ipv6.icanhazip.com][11]. However, I recommend using your command line tool options or code libraries to handle this:

```$ curl -4 icanhazip.com
162.242.244.97
$ curl -6 icanhazip.com
2001:4802:7802:102:c69b:800f:ff20:4cc4
```

## How do I deal with a proxy that is mangling my externally facing IP address?

I run all of these services on ports 80 and 81 in clear text. You can also use SSL to reach these services on port 443. For example:

```
$ curl -4 https://icanhazip.com/
162.242.244.97
```

## Why do all these domains have "icanhaz" in them?

You may understand the reasoning further if you review Wikipedia's article on [lolcats][12].

## Where can I get the source?

Roll on over to [GitHub][13]!

## Can I add checks against these domains to my scripts?

Sure! Just try not to smash the service with unneeded requests.

## What about my privacy?

I do keep the logs from the web server around to ensure that the service isn't being abused. However, no data is stored in a database or provided to third parties. I may pull some general statistics from the logs from time to time about the countries where the site is the most popular, but there will never be anything released on a granular level.

## My Puppy Linux box keeps talking to your server. What's up?

I'm not a Puppy Linux user, but my site is used by some of the startup scripts to help users determine what their external IP address is after booting. My site returns IP addresses without any advertisements and that's why it's relatively popular in some circles. I don't gather any information about users other than what would normally appear in an Apache log. If you're upset about your computer making these connections, please direct your complaints to Puppy Linux developers and maintainers.

 [1]: http://icanhazip.com
 [2]: http://icanhazptr.com
 [3]: https://en.wikipedia.org/wiki/Reverse_DNS_lookup
 [4]: http://icanhaztrace.com
 [5]: https://en.wikipedia.org/wiki/Traceroute
 [6]: http://icanhaztraceroute.com
 [7]: http://icanhazepoch.com
 [8]: https://en.wikipedia.org/wiki/Unix_time
 [9]: http://icanhazproxy.com
 [10]: http://ipv4.icanhazip.com
 [11]: http://ipv6.icanhazip.com
 [12]: http://en.wikipedia.org/wiki/Lolcat
 [13]: https://github.com/major/icanhaz

*Photo credit: [Kevin Ku on Unsplash](https://unsplash.com/photos/w7ZyuGYNpRQ)*
