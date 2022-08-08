---
title: PHPLive Has No session.save_path
author: Major Hayden
date: 2006-12-27T17:29:52+00:00
url: /2006/12/27/phplive-has-no-sessionsave_path/
dsq_thread_id:
  - 3679081622
tags:
  - web

---
Add this to the virtual host configuration if PHPLive says it has no session.save_path:

```
php_admin_flag safe_mode off
php_admin_flag register_globals off
```

PHPLive **cannot** operate with safe_mode enabled.
