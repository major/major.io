---
aliases:
- /2007/01/26/enabling-cgi-in-apache-virtual-hosts/
author: Major Hayden
date: 2007-01-26 17:12:34
tags:
- web
title: Enabling CGI in Apache virtual hosts
---

Add this to the Apache configuration:

```apache
ScriptAlias /cgi-bin/ "/var/www/html/cgi-bin/"
<Directory "/var/www/html/cgi-bin">
        Options +ExecCGI
        AddHandler cgi-script .cgi
</Directory>
```

Reload Apache and throw this in as test.cgi into your cgi-bin directory:

```perl
#!/usr/bin/perl
print "Content-type: text/html\n\n";
print "Hello, World.";
```

**Do not omit** the content-type on your perl scripts. If you do, Apache will throw a random 500 Internal Server Error and it won't log anything about it.