---
aliases:
- /2012/04/18/performance-and-redundancy-boost-for-icanhazip-com/
author: Major Hayden
date: 2012-04-18 23:30:06
tags:
- networking
- web
title: Performance and redundancy boost for icanhazip.com
---

It's been a few years since I started [a little project][1] to operate a service to return your IPv4 and IPv6 address. Although there are a bunch of other sites that offer this service as well, I've been amazed by the gradually increasing traffic to [icanhazip.com][2].

Here's a sample of the latest statistics:

  * Hits per day: **1.8 million** (about 21 hits/second)
  * Unique IP addresses per day: **25,555**
  * Hits per day from IPv6 addresses: **1,069** (a little sad)
  * Bandwidth used per day: **~ 400MB**

The site is now running on multiple [Cloud Servers][3] at [Rackspace][4] behind a [load balancer cluster][5]. In addition, the DNS records are hosted with Rackspace's [Cloud DNS][6] service.

This should allow the site to reply more quickly and reliably. If you have suggestions for other improvements, let me know!

 [1]: /2009/07/31/get-the-public-facing-ip-for-any-server-with-icanhazip-com/
 [2]: http://icanhazip.com/
 [3]: http://www.rackspace.com/cloud/cloud_hosting_products/servers/
 [4]: http://www.rackspace.com/cloud/
 [5]: http://www.rackspace.com/cloud/cloud_hosting_products/loadbalancers/
 [6]: http://www.rackspace.com/cloud/cloud_hosting_products/dns/