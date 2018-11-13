---
title: Parsing HTML through PHP in Plesk
author: Major Hayden
type: post
date: 2007-09-28T18:17:00+00:00
url: /2007/09/28/parsing-html-through-php-in-plesk/
dsq_thread_id:
  - 3667896843
tags:
  - plesk
  - web

---
Some users will want to parse HTML through the PHP parser because one of their applications requires it, or because they think it's a good idea. Parsing regular static content through PHP is not recommended as it will cause a performance hit on the server each time a static page is loaded.

Unfortunately, enabling this in conjunction with Plesk will cause problems with the Plesk web statistics. Since the PHP parsing is disabled for the `/plesk-stat/` directories, Apache will mark the page as a PHP page and your browser will attempt to download it rather than display it.

To fix this issue, simply add the following LocationMatch to the bottom of your Apache configuration:

`AddType application/x-httpd-php .php .html</p>
<p><LocationMatch "/plesk-stat/(.*)"><br />
AddType text/html .html<br />
</LocationMatch>`

This will force Apache to serve HTML files from `/plesk-stat/` as text/html rather than application/x-http-php. Your web statistics will display in the browser rather than downloading as a PHP file.
