---
aliases:
- /2006/12/27/phplive-has-no-sessionsave_path/
author: Major Hayden
date: 2006-12-27 17:29:52
tags:
- web
title: PHPLive Has No session.save_path
---

Add this to the virtual host configuration if PHPLive says it has no session.save_path:

```
php_admin_flag safe_mode off
php_admin_flag register_globals off
```

PHPLive **cannot** operate with safe_mode enabled.