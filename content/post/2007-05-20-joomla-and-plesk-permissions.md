---
title: Joomla and Plesk permissions
author: Major Hayden
type: post
date: 2007-05-21T03:13:23+00:00
url: /2007/05/20/joomla-and-plesk-permissions/
dsq_thread_id:
  - 3642766883
tags:
  - plesk
  - security
  - web

---
Thanks to a highly awesome technician on my team, we've discovered the perfect permissions setup for Joomla and Plesk:

Change the umask in '/etc/proftpd.conf' to '002' and add the 'apache' user to the 'psacln' group. Then, update the directory permissions:

`cd /home/httpd/vhosts/[domain.com]<br />
chown -R [username]:psacln httpdocs<br />
chmod -R g+w httpdocs<br />
find httpdocs -type d -exec chmod g+s {} \;`

Joomla also complains about some PHP settings, sometimes including not being able to write to '/var/lib/php/session'. To fix the issues, make some adjustments to the vhost.conf for the domain:

`<Directory /home/httpd/vhosts/[domain]/httpdocs><br />
php_admin_flag magic_quotes_gpc on<br />
php_admin_flag display_errors on<br />
php_admin_value session.save_path /tmp<br />
</Directory>`

If the vhost.conf is brand new, then run:

`/usr/local/psa/admin/bin/websrvmng -av`

Make sure Apache runs with your new configuration:

`# httpd -t (check your work)<br />
# /etc/init.d/httpd reload`

Credit for this goes to Bryan T.
