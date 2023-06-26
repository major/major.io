---
aliases:
- /2007/08/28/apache-disable-trace-and-track-methods/
author: Major Hayden
date: 2007-08-29 00:27:59
tags:
- security
- web
title: 'Apache: Disable TRACE and TRACK methods'
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