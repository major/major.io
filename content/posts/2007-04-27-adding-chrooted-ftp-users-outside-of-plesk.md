---
title: Adding chrooted FTP users outside of Plesk
author: Major Hayden
type: post
date: 2007-04-27T15:51:59+00:00
url: /2007/04/27/adding-chrooted-ftp-users-outside-of-plesk/
dsq_thread_id:
  - 3642766718
tags:
  - ftp
  - plesk
  - security

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
