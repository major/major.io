---
aliases:
- /2007/04/08/wordpress-permalinks-in-lighttpd/
author: Major Hayden
date: 2007-04-08 23:21:17
tags:
- web
title: WordPress permalinks in Lighttpd
---

WordPress uses .htaccess files to process its permalinks structure, but Lighttpd won't obey .htaccess files (yet). So, instead of banging your head against the wall, just use something like the following:

```
server.error-handler-404 = "/index.php?error=404"
```

For example, the virtual host for this very website is:

```
$HTTP["host"] =~ "rackerhacker\\.com" {
        server.document-root = basedir+"rackerhacker.com/"
        server.error-handler-404 = "/index.php?error=404"
}
```