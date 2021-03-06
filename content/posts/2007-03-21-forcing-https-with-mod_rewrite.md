---
title: Forcing HTTPS (SSL) with mod_rewrite
author: Major Hayden
type: post
date: 2007-03-21T15:00:15+00:00
url: /2007/03/21/forcing-https-with-mod_rewrite/
dsq_thread_id:
  - 3679062141
tags:
  - development
  - security
  - web

---
If you can't use PHP to force HTTPS, you can use mod_rewrite instead. Toss this in an .htaccess file in the web root of your site:

```
RewriteEngine On
RewriteCond %{SERVER_PORT} 80
RewriteRule ^(.*)$ https://www.domain.com/$1 [R,L]
```

Or, if it needs to be forced only for a certain folder:

```
RewriteEngine On
RewriteCond %{SERVER_PORT} 80
RewriteCond %{REQUEST_URI} somefolder
RewriteRule ^(.*)$ https://www.domain.com/somefolder/$1 [R,L]
```
