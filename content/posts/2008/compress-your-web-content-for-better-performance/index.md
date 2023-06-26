---
aliases:
- /2008/09/19/compress-your-web-content-for-better-performance/
author: Major Hayden
date: 2008-09-19 17:00:47
tags:
- apache
- development
- web
title: Compress your web content for better performance
---

Most web developers expend a lot of energy optimizing queries, reducing the overhead of functions, and streamlining their application's overall flow. However, many forget that one of the simplest adjustments is the compression of data as it leaves the web server.

Luckily, [mod_deflate][1] makes this easy, and the Apache documentation has a [handy initial configuration][2] available:

```
<Location />
  SetOutputFilter DEFLATE
  BrowserMatch ^Mozilla/4 gzip-only-text/html
  BrowserMatch ^Mozilla/4\.0[678] no-gzip
  BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html
  SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png)$ no-gzip dont-vary
  Header append Vary User-Agent env=!dont-vary
</Location>
```

This configuration will compress everything except for images. Of course, you can't test this with curl, but you can test it with Firefox and [LiveHTTPHeaders][3]. If you don't have Firefox handy, you can try a very handy [web application][4] that will give you the statistics about the compression of your site's data.

 [1]: http://httpd.apache.org/docs/2.0/mod/mod_deflate.html
 [2]: http://httpd.apache.org/docs/2.0/mod/mod_deflate.html#recommended
 [3]: https://addons.mozilla.org/en-US/firefox/addon/3829
 [4]: http://www.gidnetwork.com/tools/gzip-test.php