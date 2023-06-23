---
aliases:
- /2007/08/10/using-wildcard-subdomains-in-plesk/
author: Major Hayden
date: 2007-08-11 02:19:09
dsq_thread_id:
- 3642769296
tags:
- plesk
title: Using wildcard subdomains in Plesk
---

In some situations, you may want to have domain.com as well as *.domain.com point to the same site in Plesk. Plesk will automatically set up hosting for domain.com and www.domain.com within the Apache configuration, but you can direct all subdomains for a particular domain to a certain virtual host fairly easily.

**DNS**

Add a CNAME or A record for *.domain.com which points to domain.com (for a CNAME), or the domain's IP (for an A record.

**Apache Configuration**

Edit the /var/www/vhosts/domain.com/conf/vhost.conf or /home/httpd/vhosts/domain.com/conf/vhost.conf file and enter this information:

`ServerAlias *.domain.com`

If the vhost.conf didn't exist before, you will need to run:

`# /usr/local/psa/admin/bin/websrvmng -av`

Whether the vhost.conf was new or not, you will need to reload the Apache configuration:

`# /etc/init.d/httpd reload`

> Credit for this fix goes to [SWSoft's KB #955][1]

 [1]: http://kb.swsoft.com/en/955