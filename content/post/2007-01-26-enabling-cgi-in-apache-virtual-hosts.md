---
title: Enabling CGI in Apache virtual hosts
author: Major Hayden
type: post
date: 2007-01-26T17:12:34+00:00
url: /2007/01/26/enabling-cgi-in-apache-virtual-hosts/
dsq_thread_id:
  - 3644199320
tags:
  - web

---
Add this to the Apache configuration:

<pre>ScriptAlias /cgi-bin/ "/var/www/html/cgi-bin/"
<Directory "/var/www/html/cgi-bin">
        Options +ExecCGI
        AddHandler cgi-script .cgi
</Directory></pre>

Reload Apache and throw this in as test.cgi into your cgi-bin directory:

<pre>#!/usr/bin/perl
print "Content-type: text/html\n\n";
print "Hello, World.";</pre>

**Do not omit** the content-type on your perl scripts. If you do, Apache will throw a random 500 Internal Server Error and it won't log anything about it.
