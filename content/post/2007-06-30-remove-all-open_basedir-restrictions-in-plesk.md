---
title: Remove all open_basedir restrictions in Plesk
author: Major Hayden
type: post
date: 2007-06-30T15:54:49+00:00
url: /2007/06/30/remove-all-open_basedir-restrictions-in-plesk/
dsq_thread_id:
  - 3642768370
tags:
  - plesk
  - security

---
If you want to remove all of the open\_basedir restrictions for all sites in Plesk, simply create a file called /etc/httpd/conf.d/zzz\_openbasedir_removal.conf and add this text within it:

<pre><DirectoryMatch /var/www/vhosts/(.*)/httpdocs/&gt;
        php_admin_value open_basedir none
</DirectoryMatch&gt;</pre>

Just a note, this isn't a terribly great idea from a security standpoint. :-)
