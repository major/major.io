---
title: icanhazip and CORS
author: Major Hayden
type: post
date: 2014-07-21T14:31:45+00:00
url: /2014/07/21/icanhazip-and-cors/
dsq_thread_id:
  - 3642807634
categories:
  - Blog Posts
tags:
  - ajax
  - cors
  - icanhazip
  - javascript
  - security

---
I received an email from an [icanhazip.com][1] user last week about [enabling cross-origin resource sharing][2]. He wanted to use AJAX calls on a different site to pull data from icanhazip.com and use it for his visitors.

Those headers are now available for all requests to the services provided by icanhazip.com! Here's what you'll see:

```
$ curl -i icanhazip.com
---
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET
---
```


 [1]: /icanhazip-com-faq/ "icanhazip.com FAQ"
 [2]: http://enable-cors.org/index.html
