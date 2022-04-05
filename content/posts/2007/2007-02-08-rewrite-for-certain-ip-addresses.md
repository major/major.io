---
title: Rewrite for certain IP addresses
author: Major Hayden
type: post
date: 2007-02-08T18:26:45+00:00
url: /2007/02/08/rewrite-for-certain-ip-addresses/
dsq_thread_id:
  - 3679069116
tags:
  - plesk
  - web

---
Need to redirect all users except for yourself to another site until yours is live?

```
RewriteCond %{REMOTE_ADDR} !"^64\.39\.0\.38"
RewriteRule .* http://othersite.com/
```
