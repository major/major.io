---
title: Strip off www from URLs with mod_rewrite
author: Major Hayden
type: post
date: 2007-01-15T19:45:55+00:00
url: /2007/01/15/strip-off-www-from-urls-with-mod_rewrite/
dsq_thread_id:
  - 3646736558
categories:
  - Blog Posts
tags:
  - web

---
If you need to remove subdomains from the URL that users enter to visit your website, toss this into your VirtualHost directive:

```
RewriteEngine On
RewriteCond %{HTTP_HOST} ^www.domain.com$ [NC]
RewriteRule ^(.*)$ http://domain.com/$1 [R=301,L]
```


Of course, you can tack on a subdomain too, if that's what you need:

```
RewriteEngine On
RewriteCond %{HTTP_HOST} ^domain.com$ [NC]
RewriteRule ^(.*)$ http://www.domain.com/$1 [R=301,L]
```

