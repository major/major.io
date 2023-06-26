---
aliases:
- /2007/06/30/remove-all-open_basedir-restrictions-in-plesk/
author: Major Hayden
date: 2007-06-30 15:54:49
tags:
- plesk
- security
title: Remove all open_basedir restrictions in Plesk
---

If you want to remove all of the open\_basedir restrictions for all sites in Plesk, simply create a file called /etc/httpd/conf.d/zzz\_openbasedir_removal.conf and add this text within it:

```apache
<DirectoryMatch /var/www/vhosts/(.*)/httpdocs/>
        php_admin_value open_basedir none
</DirectoryMatch>
```

Just a note, this isn't a terribly great idea from a security standpoint. :-)