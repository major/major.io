---
title: More upgrades for icanhazip.com
author: Major Hayden
type: post
date: 2013-02-23T20:15:24+00:00
url: /2013/02/23/more-upgrades-for-icanhazip-com/
dsq_thread_id:
  - 3642807123
categories:
  - Blog Posts

---
The feature requests for icanhazip.com finally pushed me over the edge and I've made some significant changes. Here we go:

**Get around proxies on port 81**

Quite a few people had issues with local proxies that filtered traffic on port 80 and delivered the wrong results for their external IP address. You can now [reach the site on port 81][1].

**Get your external IP address over HTTPS**

Some users reported that defensive network infrastructure mangled all of their web traffic to the site, so I've [enabled SSL listeners][2] for icanhazip.com. Bear in mind that the SSL certificate is only valid for icanhazip.com and not the other subdomains (like ipv4.icanhazip.com). If you are using applications like curl to access subdomains, you'll need to use the `-k` argument, like this:

```
$ curl https://icanhazip.com/
74.125.225.224
$ curl https://ipv4.icanhazip.com/
curl: (51) SSL peer certificate or SSH remote key was not OK
$ curl -k https://ipv4.icanhazip.com/
74.125.225.224
```


**Local icanhazip.com servers**

The site now exists in Dallas-Fort Worth (US), Chicago (US), and Maidenhead (UK). There are many new DNS records available to use:

  * Random location: icanhazip.com, ipv4.icanhazip.com, ipv6.icanhazip.com
  * DFW: dfw.icanhazip.com, ipv4.dfw.icanhazip.com, ipv6.dfw.icanhazip.com
  * ORD: ord.icanhazip.com, ipv4.ord.icanhazip.com, ipv6.ord.icanhazip.com
  * UK: uk.icanhazip.com, ipv4.uk.icanhazip.com, ipv6.uk.icanhazip.com

One of the HTTP response headers should confirm which node you're querying:

```
$ curl -si icanhazip.com | grep NODE
X-ICANHAZNODE: ord.icanhazip.com
```


**Let me know what you think!**

If you have new ideas for features, let me know. Also, be sure to tell me if something's not working properly for you.

 [1]: http://icanhazip.com:81/
 [2]: https://icanhazip.com/
