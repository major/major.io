---
aliases:
- /2007/06/14/500-oops-error-from-vsftpd/
author: Major Hayden
date: 2007-06-14 23:14:51
tags:
- ftp
- security
title: 500 OOPS error from vsftpd
---

If you find yourself with the ever-so-peculiar **500 OOPS** error from vsftpd when you attempt to login over SSH, there could be a few different things at play. Generally, this is the type of error you will get:

```
500 OOPS: cannot change directory:/home/someuser
500 OOPS: child died
```

You can search for a solution in this order:

**Home Directory**

Does the user's home directory even exist? Check `/etc/passwd` for the current home directory for the user and see what's set:

```
# grep someuser /etc/passwd
someuser:x:10001:2524::/var/www/someuser:/bin/bash
```

In this case, does `/var/www/someuser` exist? If it doesn't, fix that and then move onto the next solution if you're still having problems.

**File/Directory Permissions**

Be sure that the user that you are logging in as actually has permissions to be in the directory. This affects users that have home directories of `/var/www/html` because the execute bit normally isn't set for the world on `/var/www` or `/var/www/html`. Make sure that the appropriate permissions and ownerships are set, and this should help eliminate the issue.

**SELINUX**

If SELINUX is rearing its ugly head on the server, this can be a problem. Check your current SELINUX status and disable it if necessary:

```
# setenforce
Enforcing
# setenforce 0
```

Try to login over FTP again and you should have a success. If you want to turn off SELINUX entirely, adjust `/etc/sysconfig/selinux` (RHEL4) or `/etc/selinux/config` (RHEL5).