---
title: Detect proxies with icanhazproxy
author: Major Hayden
type: post
date: 2014-04-03T15:52:58+00:00
url: /2014/04/03/detect-proxies-with-icanhazproxy/
dsq_thread_id:
  - 3664077969
categories:
  - Blog Posts
tags:
  - icanhazip
  - networking
  - proxy

---
You can already detect proxy servers using [icanhazip.com][1] by accessing the service on port [80][1], [81][2], and [443][3]. If you compare your results and you see different IP addresses, there's most likely a proxy in the way.

To make things easier, I've launched [icanhazproxy.com][4]. It's available on ports [80][4], [81][5] and [443][6] as well. If you choose to access it on port 443, you'll get a certificate for icanhazip.com that you'll need to ignore.

You'll get one of two possible responses:

**200/OK with JSON output:** When a proxy is detected, you'll receive a 200 response and any proxy-related headers will be returned in JSON format. Here's a sample:

```
$ curl icanhazproxy.com
{"via": "1.1 proxy.example.com 0A065C93"}
```


You may receive multiple headers via JSON, so please be prepared for that.

**204/NO CONTENT and empty response:** No common proxy headers were detected. Here's an example:

```
$ curl -si http://icanhazproxy.com:81/ | head -n1
HTTP/1.1 204 NO CONTENT
```


If you get this response but you know there's a proxy in the way, let me know. I may need to look for extra headers or other items in the request.

Go try it out and send me your feedback!

 [1]: http://icanhazip.com
 [2]: http://icanhazip.com:81
 [3]: https://icanhazip.com
 [4]: http://icanhazproxy.com/
 [5]: http://icanhazproxy.com:81/
 [6]: https://icanhazproxy.com/
