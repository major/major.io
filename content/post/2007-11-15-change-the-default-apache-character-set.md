---
title: Change the default Apache character set
author: Major Hayden
type: post
date: 2007-11-15T18:09:01+00:00
url: /2007/11/15/change-the-default-apache-character-set/
dsq_thread_id:
  - 3642770583
tags:
  - apache
  - web

---
By default, Red Hat Enterprise Linux 4 sets the default character set in Apache to UTF-8. Your specific web application may need for the character set to be set to a different value, and the change can be made fairly easily. Here's an example where the character set is changed to ISO-8859-1:

First, adjust the AddDefaultCharset directive in /etc/httpd/conf/httpd.conf:

```
#AddDefaultCharset UTF-8<br />
AddDefaultCharset ISO-8859-1
```

Then, reload Apache and check your headers:

```
# /etc/init.d/httpd reload<br />
# curl -I localhost<br />
HTTP/1.1 403 Forbidden<br />
Date: Thu, 08 Nov 2007 22:18:14 GMT<br />
Server: Apache/2.0.52 (Red Hat)<br />
Accept-Ranges: bytes<br />
Content-Length: 3985<br />
Connection: close<br />
Content-Type: text/html; charset=ISO-8859-1
```

_This was tested on Red Hat Enterprise Linux 4 Update 5_
