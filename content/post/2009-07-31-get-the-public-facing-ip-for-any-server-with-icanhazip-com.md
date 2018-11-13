---
title: Get the public-facing IP for any server with icanhazip.com
author: Major Hayden
type: post
date: 2009-07-31T13:41:38+00:00
url: /2009/07/31/get-the-public-facing-ip-for-any-server-with-icanhazip-com/
dsq_thread_id:
  - 3642805693
categories:
  - Blog Posts
tags:
  - curl
  - networking
  - wget

---
There are a ton of places on the internet where you can check the public-facing IP for the device you are using. I've used plenty of them, but I've always wanted one that just returned text. You can get pretty close with [checkip.dyndns.org][1], but there is still HTML in the output:

```
$ curl checkip.dyndns.org
Current IP Address: 174.143.240.31</pre>

I wanted something simpler, so I set up [icanhazip.com][2]:

```
$ curl icanhazip.com
174.143.240.31</pre>

 [1]: http://checkip.dyndns.org/
 [2]: http://icanhazip.com/
