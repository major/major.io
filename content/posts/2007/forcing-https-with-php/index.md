---
aliases:
- /2007/03/21/forcing-https-with-php/
author: Major Hayden
date: 2007-03-21 14:27:35
dsq_thread_id:
- 3642765993
tags:
- development
- security
- web
title: Forcing HTTPS with PHP
---

To force HTTPS with a PHP script, just put this snippet near the top:

```php
if ($_SERVER['SERVER_PORT'] != 443) {
header("Location: https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']);
}
```