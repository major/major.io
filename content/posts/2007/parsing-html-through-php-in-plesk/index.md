---
aliases:
- /2007/09/28/parsing-html-through-php-in-plesk/
author: Major Hayden
date: 2007-09-28 18:17:00
tags:
- plesk
- web
title: Parsing HTML through PHP in Plesk
---

Some users will want to parse HTML through the PHP parser because one of their applications requires it, or because they think it's a good idea. Parsing regular static content through PHP is not recommended as it will cause a performance hit on the server each time a static page is loaded.

Unfortunately, enabling this in conjunction with Plesk will cause problems with the Plesk web statistics. Since the PHP parsing is disabled for the `/plesk-stat/` directories, Apache will mark the page as a PHP page and your browser will attempt to download it rather than display it.

To fix this issue, simply add the following LocationMatch to the bottom of your Apache configuration:

```apache
AddType application/x-httpd-php .php .html
<LocationMatch "/plesk-stat/(.*)">
AddType text/html .html
</LocationMatch>
```

This will force Apache to serve HTML files from `/plesk-stat/` as text/html rather than application/x-http-php. Your web statistics will display in the browser rather than downloading as a PHP file.