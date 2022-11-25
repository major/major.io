---
title: Preventing Plesk 8.2.x from adding up2date sources
author: Major Hayden
date: 2007-10-04T18:29:14+00:00
url: /2007/10/04/preventing-plesk-82x-from-adding-up2date-sources/
dsq_thread_id:
  - 3679019557
tags:
  - plesk

---
One of the most annoying (and explosive) changes in Plesk 8.2 is the automatic addition of up2date sources for its use. As of 8.2.0, the packages are not signed, and they generate errors with up2date. Also, Plesk often keeps adding the sources over and over to /etc/sysconfig/rhn/sources, and this causes additional errors and delays when you use up2date.

You can disable this behavior entirely by running the following:

`# echo ALLOW_TO_USE_UP2DATE=no > /root/.autoinstallerrc`

This will instruct Plesk's autoinstaller to not add any sources to the up2date sources list.
