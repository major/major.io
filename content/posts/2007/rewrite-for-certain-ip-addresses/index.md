---
aliases:
- /2007/02/08/rewrite-for-certain-ip-addresses/
author: Major Hayden
date: 2007-02-08 18:26:45
dsq_thread_id:
- 3679069116
tags:
- plesk
- web
title: Rewrite for certain IP addresses
---

Need to redirect all users except for yourself to another site until yours is live?

```
RewriteCond %{REMOTE_ADDR} !"^64\.39\.0\.38"
RewriteRule .* http://othersite.com/
```