---
title: Can’t upload large files in PHP
author: Major Hayden
type: post
date: 2007-01-24T15:35:29+00:00
url: /2007/01/24/cant-upload-large-files-in-php/
dsq_thread_id:
  - 3679077768
tags:
  - web

---
First, check max\_upload\_size in php.ini, but if that doesn't work, look for "LimitRequestBody" in /etc/httpd/conf.d/php.conf and comment it out. Restart apache and you're all set.
