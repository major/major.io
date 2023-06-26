---
aliases:
- /2009/07/31/get-the-public-facing-ip-for-any-server-with-icanhazip-com/
author: Major Hayden
date: 2009-07-31 13:41:38
tags:
- curl
- networking
- wget
title: Get the public-facing IP for any server with icanhazip.com
---

There are a ton of places on the internet where you can check the public-facing IP for the device you are using. I've used plenty of them, but I've always wanted one that just returned text. You can get pretty close with [checkip.dyndns.org][1], but there is still HTML in the output:

<pre lang="html">$ curl checkip.dyndns.org
Current IP Address: 174.143.240.31</pre>

I wanted something simpler, so I set up [icanhazip.com][2]:

<pre lang="html">$ curl icanhazip.com
174.143.240.31</pre>

 [1]: http://checkip.dyndns.org/
 [2]: http://icanhazip.com/