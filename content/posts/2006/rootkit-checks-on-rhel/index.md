---
aliases:
- /2006/12/26/rootkit-checks-on-rhel/
author: Major Hayden
date: 2006-12-27 04:01:45
dsq_thread_id:
- 3679082461
tags:
- security
title: Rootkit Checks on RHEL
---

If you think you have a rooted RHEL box, you'll want to run the usual rkhunter, chkrootkit, and you will want to inspect for rogue processes. However, if the rootkit hasn't exposed its malfeasance yet, how do you know it's there?

```
rpm -Va
```

RPM's verify functionality can tell you what's happened to files installed by an RPM since they were installed. Changes in permissions, file sizes, locations, and ownership can all be detected. Here's some example output:

```
.M.......   /etc/cups
S.5....TC c /etc/cups/cupsd.conf
.......TC c /etc/cups/printers.conf
.M.......   /var/spool/cups/tmp
S.5....T. c /etc/sysconfig/system-config-securitylevel
S.5....T. c /etc/xml/catalog
S.5....T. c /usr/share/sgml/docbook/xmlcatalog
........C   /var/lib/scrollkeeper
S.?......   /usr/lib/libcurl.so.3.0.0
```

So what do the letters mean?

```
S   file Size differs
M   Mode differs (includes permissions and file type)
5   MD5 sum differs
D   Device major/minor number mismatch
L   readLink(2) path mismatch
U   User ownership differs
G   Group ownership differs
T   mTime differs
c   %config configuration file.
d   %doc documentation file.
g   %ghost file (i.e. the file contents are not included in the package payload).
l   %license license file.
r   %readme readme file.
```

Lots of MD5's and ownerships will change from time to time, but watch out for any action in important executables, such as /bin/ls or /bin/passwd - if these have changed, you may be rooted.