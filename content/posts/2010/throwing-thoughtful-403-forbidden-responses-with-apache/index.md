---
aliases:
- /2010/11/17/throwing-thoughtful-403-forbidden-responses-with-apache/
author: Major Hayden
date: 2010-11-17 13:47:19
tags:
- apache
- command line
- mod_rewrite
- sysadmin
- web
title: Throwing thoughtful “403 Forbidden” responses with apache
---

If you offer a web service that users query via scripts or other applications, you'll probably find that some people will begin to abuse the service. My [icanhazip.com][1] site is no exception.

While many of the users have reasonable usage patterns, there are some users that query the site more than once per second from the same IP address. If you haven't used the site before, all it does is return your public IP address in plain text. Unless your IP changes rapidly, you may not need to query the site more than a few times an hour.

I added the following to my icanhazip.com virtual host definition to get the message across to those users that abuse the service:

```apache
ErrorDocument 403 "No can haz IP. Stop abusing this service. \
    Contact major at mhtx dot net for details."
RewriteEngine On
RewriteCond %{REMOTE_ADDR} ^12.23.34.45$ [OR]
RewriteCond %{REMOTE_ADDR} ^98.87.76.65$
RewriteRule .* nocanhaz [F]
```

The users that are caught on the business end of these 403 responses will see something like this:

```
$ curl -i icanhazip.com
HTTP/1.1 403 Forbidden
Date: Wed, 17 Nov 2010 13:42:55 GMT
Server: Apache
Content-Length: 84
Connection: close
Content-Type: text/html; charset=iso-8859-1

No can haz IP. Stop abusing this service. Contact major at mhtx dot net for details.
```

 [1]: http://icanhazip.com/