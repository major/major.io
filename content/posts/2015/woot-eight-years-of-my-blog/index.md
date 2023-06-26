---
aliases:
- /2015/04/14/woot-eight-years-of-my-blog/
author: Major Hayden
date: 2015-04-14 18:53:34
tags:
- apache
- fedora
- httpd
- nginx
- php
- rackspace
- security
- ssl
- tls
- wordpress
title: Woot! Eight years of my blog
---

The spring of 2015 marks eight years of this blog! I've learned plenty of tough lessons along the way and I've made some changes recently that might be handy for other people. After watching [Sasha Laundy's][1] video from her awesome talk at Pycon 2015[^2], I'm even more energized to share what I've learned with other people. _(Seriously: Go watch that video or review the slides whether you work in IT or not. It's worth your time.)_

Let's start from the beginning.

<!--more-->

### History Lesson

When I started at [Rackspace][3] in late 2006, I came from a fairly senior role at a very small company. I felt like I knew a lot and then discovered I knew almost nothing compared to my new coworkers at Rackspace. Sure, some of that was [impostor syndrome kicking in][4], but much of it was due to being in the right place at the right time. I took a _lot_ of notes in various places: notebooks, [Tomboy notes][5], and plain text files. It wasn't manageable and I knew I needed something else.

[<img src="/wp-content/uploads/2015/04/429788108_f8a6308501_o-300x225.jpg" alt="Rackspace Zeppelin" width="300" height="225" class="alignright size-medium wp-image-5495" srcset="/wp-content/uploads/2015/04/429788108_f8a6308501_o-300x225.jpg 300w, /wp-content/uploads/2015/04/429788108_f8a6308501_o-1024x768.jpg 1024w, /wp-content/uploads/2015/04/429788108_f8a6308501_o.jpg 1280w" sizes="(max-width: 300px) 100vw, 300px" />][6]Many of my customers were struggling to configure various applications on LAMP stacks and a frequent flier on my screen of tickets was WordPress. I installed it on a shared hosting account and began tossing my notes into it instead of the various other places. It was a bit easier to manage the content and it came with another handy feature: I could share links with coworkers when I knew how to fix something that they didn't. In the long run, this was the best thing that came out of using WordPress.

Fast forward to today and the blog has more than 640 posts, 3,500 comments, and 100,000 sessions per month. I get plenty of compliments via email along with plenty of criticism. Winston Churchill [said it best][7]:

> Criticism may not be agreeable, but it is necessary. It fulfils the same function as pain in the human body. It calls attention to an unhealthy state of things.

I love all the comments and emails I get - happy or unhappy. That's what keeps me going.

### Now Required: TLS (with optional Perfect Forward Secrecy)

I've offered encrypted connections on the blog for quite some time but it's now a hard requirement. TLS 1.0, 1.1 and 1.2 are supported and the ciphers supporting [Perfect Forward Secrecy (PFS)][8] are preferred over those that don't. For the super technical details, feel free to review a scan from [Qualys' SSL Labs][9].

You might be asking: "Why does a blog need encryption if I'm just coming by to read posts?" My response is **"Why not?"**. The cost for SSL certificates in today's market is extremely inexpensive. For example, you can get three years on a [COMODO certificate at CheapSSL][10] for $5 USD per year. _(I'm a promoter of CheapSSL - they're great.)_

Requiring encryption doesn't add much overhead or load time but it may prevent someone from reading your network traffic or slipping in malicious code along with the reply from my server. Google also [bumps up search engine rankings][11] for sites with encryption available.

### Moved to nginx

[Apache][12] has served up this blog exclusively since 2007. It's always been my go-to web server of choice but I've taken some deep dives into [nginx][13] configuration lately. I've moved the blog over to a Fedora 21 virtual machine (on a Fedora 21 KVM hypervisor) running nginx with PHP running under [php-fpm][14]. It's also using nginx's [fastcgi_cache][15] which has really surprised me with its performance. Once a page is cached, I'm able to drag out about 800-900 Mbit/sec using [ab][16].

Another added benefit from the change is that I'm now able to dump my caching-related plugins from WordPress. That means I have less to maintain and less to diagnose when something goes wrong.

### Thanks!

Thanks for all of the emails, comments, and criticism over the years. I love getting those emails that say "Hey, you helped me fix something" or "Wow, I understand that now". That's what keeps me going. ;)

 [1]: https://twitter.com/sashalaund
 [2]: http://blog.sashalaundy.com/talks/asking-helping/
 [3]: http://www.rackspace.com/
 [4]: /2014/02/04/be-an-inspiration-not-an-impostor/
 [5]: https://wiki.gnome.org/Apps/Tomboy
 [6]: /wp-content/uploads/2015/04/429788108_f8a6308501_o.jpg
 [7]: http://books.google.co.in/books?id=mfvSQbviy50C&pg=PA79
 [8]: http://en.wikipedia.org/wiki/Forward_secrecy
 [9]: https://www.ssllabs.com/ssltest/analyze.html?d=major.io
 [10]: https://cheapsslsecurity.com/comodo/positivessl.html
 [11]: http://googleonlinesecurity.blogspot.com/2014/08/https-as-ranking-signal_6.html
 [12]: http://httpd.apache.org/
 [13]: http://nginx.org/
 [14]: http://php-fpm.org/
 [15]: http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache
 [16]: http://httpd.apache.org/docs/2.2/programs/ab.html

[^2]: Sasha Laundy's blog used to be at blog.sashalaundy.com, but it appears to
be offline now. 😞