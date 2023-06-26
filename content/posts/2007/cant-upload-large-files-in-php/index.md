---
aliases:
- /2007/01/24/cant-upload-large-files-in-php/
author: Major Hayden
date: 2007-01-24 15:35:29
tags:
- web
title: Can’t upload large files in PHP
---

First, check `max_upload_size` in php.ini, but if that doesn't work, look for `LimitRequestBody` in /etc/httpd/conf.d/php.conf and comment it out. Restart apache and you're all set.