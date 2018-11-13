---
title: WordPress permalinks in Lighttpd
author: Major Hayden
type: post
date: 2007-04-08T23:21:17+00:00
url: /2007/04/08/wordpress-permalinks-in-lighttpd/
dsq_thread_id:
  - 3642766515
tags:
  - web

---
WordPress uses .htaccess files to process its permalinks structure, but Lighttpd won't obey .htaccess files (yet). So, instead of banging your head against the wall, just use something like the following:

`server.error-handler-404 = "/index.php?error=404"`

For example, the virtual host for this very website is:

`</p>
<pre>$HTTP["host"] =~ "rackerhacker\\.com" {
        server.document-root = basedir+"rackerhacker.com/"
        server.error-handler-404 = "/index.php?error=404"
}</pre>
<p>`
