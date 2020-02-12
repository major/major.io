---
title: Learn octal file permissions easily with stat
author: Major Hayden
type: post
date: 2013-12-10T13:41:40+00:00
url: /2013/12/10/learn-octal-file-permissions-easily-with-stat/
dsq_thread_id:
  - 3671596051
categories:
  - Blog Posts
tags:
  - command line
  - linux
  - sysadmin

---
My SANS classmates were learning how to set and recognize file permissions on a Linux server and we realized it would be helpful to display the octal value of the permissions next to the normal _rwx_ display. Fortunately, a quick search revealed that `stat` could deliver this information:

```
# stat -c "%a %A %n" /usr/sbin/* | head
755 -rwxr-xr-x /usr/sbin/accessdb
755 -rwxr-xr-x /usr/sbin/acpid
755 -rwxr-xr-x /usr/sbin/addgnupghome
755 -rwxr-xr-x /usr/sbin/addpart
777 lrwxrwxrwx /usr/sbin/adduser
755 -rwxr-xr-x /usr/sbin/agetty
755 -rwxr-xr-x /usr/sbin/alternatives
755 -rwxr-xr-x /usr/sbin/anacron
755 -rwxr-xr-x /usr/sbin/apachectl
755 -rwxr-xr-x /usr/sbin/applygnupgdefaults
```


The first octal digit (for setuid, setgid, and sticky) is left off for any files without those bits set.