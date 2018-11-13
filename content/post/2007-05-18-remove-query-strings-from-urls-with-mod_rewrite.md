---
title: Remove query strings from URL’s with mod_rewrite
author: Major Hayden
type: post
date: 2007-05-18T14:07:37+00:00
url: /2007/05/18/remove-query-strings-from-urls-with-mod_rewrite/
dsq_thread_id:
  - 3679049078
tags:
  - development
  - web

---
If you need to strip query strings from a URL with mod_rewrite, you can use a rewrite syntax such as the following:

`RewriteEngine on<br />
RewriteCond %{QUERY_STRING} "action=register" [NC]<br />
RewriteRule ^/. http://www.domain.com/registerpage.html? [R,L]`