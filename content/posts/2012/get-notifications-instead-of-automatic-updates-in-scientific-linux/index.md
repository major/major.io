---
aliases:
- /2012/02/04/get-notifications-instead-of-automatic-updates-in-scientific-linux/
author: Major Hayden
date: 2012-02-04 19:01:54
tags:
- fedora
- scientific linux
- security
- yum
title: Get notifications instead of automatic updates in Scientific Linux
---

Scientific Linux installations have a package called `yum-autoupdate` by default and the package contains two files:

```
# rpm -ql yum-autoupdate
/etc/cron.daily/yum-autoupdate
/etc/sysconfig/yum-autoupdate
```


The cron job contains the entire script to run automatic updates once a day and the configuration file controls its behavior. However, you can't get the same functionality as Fedora's `yum-updatesd` package where you can receive notifications for updates rather than automatically updating the packages.

To get those notifications in Scientific Linux, just make two small edits to this portion of `/etc/cron.daily/yum-autoupdate`:

```
173           echo "    Starting Yum with command"
174           echo "     /usr/bin/yum -c $TEMPCONFIGFILE -e 0 -d 1 -y update"
175   fi
176   /usr/bin/yum -c $TEMPCONFIGFILE -e 0 -d 1 -y update > $TEMPFILE 2>&1
177   if [ -s $TEMPFILE ] ; then
```


Adjust the `update` commands to look like this:

```
173           echo "    Starting Yum with command"
174           echo "     /usr/bin/yum -c $TEMPCONFIGFILE -e 0 -d 1 -y check-update"
175   fi
176   /usr/bin/yum -c $TEMPCONFIGFILE -e 0 -d 1 -y check-update > $TEMPFILE 2>&1
177   if [ -s $TEMPFILE ] ; then
```


Since you won't be auto-updating with this script any longer, you may want to comment out the `EXCLUDE=` line in `/etc/sysconfig/yum-autoupdate` so that you'll receive notifications for all packages with updates. Also, to avoid having your changes updated with a newer `yum-autoupdate` package later, add the package to your list of excluded packages in `/etc/yum.conf`.