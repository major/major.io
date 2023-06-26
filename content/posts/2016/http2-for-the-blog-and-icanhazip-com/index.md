---
aliases:
- /2016/09/13/http2-for-the-blog-and-icanhazip-com/
author: Major Hayden
date: 2016-09-13 13:47:05
tags:
- blog
- encryption
- networking
- security
- tls
title: HTTP/2 for the blog and icanhazip.com
---

I've recently updated this blog and [icanhazip.com][1] to enable HTTP/2! This probably won't have much of an effect on users who query icanhazip.com with automated tools, but it should deliver the content on this blog a [little faster][2]. If you're using an older, non-HTTP/2 client - don't worry. All of the sites will continue working for you as they always have.

Head on over to Wikipedia to [learn more about HTTP/2 and its benefits][3].

Also, I've revised the list of allowed TLS ciphers so that stronger ciphers are required. If you're having issues with a particular client, please let me know.

 [1]: https://icanhazip.com/
 [2]: https://http2.github.io/faq/#what-are-the-key-differences-to-http1x
 [3]: https://en.wikipedia.org/wiki/HTTP/2