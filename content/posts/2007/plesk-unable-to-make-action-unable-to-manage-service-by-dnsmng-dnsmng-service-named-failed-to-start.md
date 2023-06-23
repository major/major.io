---
aliases:
- /2007/08/02/plesk-unable-to-make-action-unable-to-manage-service-by-dnsmng-dnsmng-service-named-failed-to-start/
author: Major Hayden
date: 2007-08-03 02:43:35
dsq_thread_id:
- 3645268076
tags:
- plesk
title: 'Plesk: Unable to make action: Unable to manage service by dnsmng: dnsmng:
  Service named failed to start'
---

This error means that Plesk attempted to make a DNS change and reload named, but it failed. The problem generally lies within some seemingly innocent RPM's that are causing problems with Plesk's installation of bind.

Check your /var/log/messages for lines like these:

```
named[xxx]: could not configure root hints from 'named.root': file not found
named[xxx]: loading configuration: file not found
named[xxx]: exiting (due to fatal error)
named: named startup failed
```

In this case, do a quick check for these RPM's and remove them if they are on the system:

* bind-chroot
* caching-nameserver

```
# rpm -ev bind-chroot
# rpm -ev caching-nameserver
```