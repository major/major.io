---
aliases:
- /2007/05/20/joomla-and-plesk-permissions/
author: Major Hayden
date: 2007-05-21 03:13:23
dsq_thread_id:
- 3642766883
tags:
- plesk
- security
- web
title: Joomla and Plesk permissions
---

Thanks to a highly awesome technician on my team, we've discovered the perfect permissions setup for Joomla and Plesk:

Change the umask in '/etc/proftpd.conf' to '002' and add the 'apache' user to the 'psacln' group. Then, update the directory permissions:

```
cd /home/httpd/vhosts/[domain.com]
chown -R [username]:psacln httpdocs
chmod -R g+w httpdocs
find httpdocs -type d -exec chmod g+s {} \;
```

Joomla also complains about some PHP settings, sometimes including not being able to write to '/var/lib/php/session'. To fix the issues, make some adjustments to the vhost.conf for the domain:

```apache
<Directory /home/httpd/vhosts/[domain]/httpdocs>
php_admin_flag magic_quotes_gpc on
php_admin_flag display_errors on
php_admin_value session.save_path /tmp
</Directory>
```

If the vhost.conf is brand new, then run:

```
/usr/local/psa/admin/bin/websrvmng -av
```

Make sure Apache runs with your new configuration:

```
# httpd -t (check your work)
# /etc/init.d/httpd reload
```

Credit for this goes to Bryan T.