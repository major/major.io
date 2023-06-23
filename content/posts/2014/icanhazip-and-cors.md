---
aliases:
- /2014/07/21/icanhazip-and-cors/
author: Major Hayden
date: 2014-07-21 14:31:45
dsq_thread_id:
- 3642807634
tags:
- ajax
- cors
- icanhazip
- javascript
- security
title: icanhazip and CORS
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