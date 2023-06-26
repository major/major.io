---
aliases:
- /2007/01/27/moving-mail-between-some-plesk-servers/
author: Major Hayden
date: 2007-01-27 18:29:24
tags:
- plesk
title: Moving mail between some Plesk servers
---

If you're migrating a domain, sometimes their mail will go to the old server for a while after you've changed the DNS. You can move their mail to the new server by following these steps:

1) Go to the user's Maildir directory

`cd /var/qmail/mailnames/<domain>/<user>/Maildir`

2) Tar their mail directories

`tar cvzf <user>.tar.gz cur new tmp`

3) Move to a web accessible location

`mv <user>.tar.gz /home/httpd/vhosts/<web-accessible-domain>/httpdocs/`

4) Log onto the second server and go to the user's Maildir directory

`cd /var/qmail/mailnames/<domain>/<user>/Maildir`

5) Retrieve the user's mail tar file that you created

`wget http://<web-accessible-domain>/<user>.tar.gz`

6) Un-tar the files to their correct locations

`tar xvzf <user>.tar.gz`

7) Remove the tar file

`rm <user>.tar.gz`

8) Go to the original server and remove the tar file

`rm /home/httpd/vhosts/<web-accessible-domain>/httpdocs/<user>.tar.gz`