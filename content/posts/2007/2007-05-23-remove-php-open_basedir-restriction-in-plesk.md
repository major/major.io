---
title: Remove PHP’s open_basedir restriction in Plesk
author: Major Hayden
type: post
date: 2007-05-23T17:21:58+00:00
url: /2007/05/23/remove-php-open_basedir-restriction-in-plesk/
dsq_thread_id:
  - 3642767504
tags:
  - plesk
  - security
  - web

---
If you have an open_basedir restriction that is causing issues with a domain, you can remove the restriction easily. First, put the following text in /home/httpd/vhosts/[domain]/conf/vhost.conf:

```apache
<Directory /home/httpd/vhosts/[domain]/httpdocs>
php_admin_value open_basedir none
</Directory>
```

If there was already a vhost.conf in the directory, then just reload Apache. Otherwise, run the magic wand:

```
/usr/local/psa/admin/bin/websrvmng -av
```

Then reload Apache:

```
/etc/init.d/httpd reload
```
