---
aliases:
- /2007/05/18/remove-query-strings-from-urls-with-mod_rewrite/
author: Major Hayden
date: 2007-05-18 14:07:37
tags:
- development
- web
title: Remove query strings from URL’s with mod_rewrite
---

If you need to strip query strings from a URL with mod_rewrite, you can use a rewrite syntax such as the following:

```apache2
RewriteEngine on
RewriteCond %{QUERY_STRING} "action=register" [NC]
RewriteRule ^/. http://www.domain.com/registerpage.html? [R,L]
```