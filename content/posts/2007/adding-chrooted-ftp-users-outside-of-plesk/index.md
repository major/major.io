---
aliases:
- /2007/04/27/adding-chrooted-ftp-users-outside-of-plesk/
author: Major Hayden
date: 2007-04-27 15:51:59
tags:
- ftp
- plesk
- security
title: Adding chrooted FTP users outside of Plesk
---

To add a chrooted FTP user outside of Plesk properly, you need to:

* Create the user with the home directory as the root of what they can access
* Give the user a password
* Make their primary group psacln
* Add them to the psaserv group as well

```
# useradd username -d /var/www/html/website/slideshow/
# echo "password" | passwd username --stdin
Changing password for user username.
passwd: all authentication tokens updated successfully.
# usermod -g psacln username
# usermod -G psaserv username
# lftp username:password@localhost
lftp username@localhost:/> cd ..
lftp username@localhost:/>
```