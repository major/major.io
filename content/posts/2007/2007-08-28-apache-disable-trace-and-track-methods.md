---
title: 'Apache: Disable TRACE and TRACK methods'
author: Major Hayden
date: 2007-08-29T00:27:59+00:00
url: /2007/08/28/apache-disable-trace-and-track-methods/
dsq_thread_id:
  - 3642769871
tags:
  - security
  - web

---
Lots of PCI Compliance and vulnerability scan vendors will complain about TRACE and TRACK methods being enabled on your server. Since most providers run Nessus, you'll see this fairly often. Here's the rewrite rules to add:

```
RewriteEngine on
RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
RewriteRule .* - [F]
```

These directives will need to be added to each VirtualHost.

Further reading:

[Apache Debugging Guide][1]

 [1]: http://httpd.apache.org/dev/debugging.html
