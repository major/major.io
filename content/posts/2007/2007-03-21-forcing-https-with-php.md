---
title: Forcing HTTPS with PHP
author: Major Hayden
date: 2007-03-21T14:27:35+00:00
url: /2007/03/21/forcing-https-with-php/
dsq_thread_id:
  - 3642765993
tags:
  - development
  - security
  - web

---
To force HTTPS with a PHP script, just put this snippet near the top:

```php
if ($_SERVER['SERVER_PORT'] != 443) {
header("Location: https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']);
}
```
