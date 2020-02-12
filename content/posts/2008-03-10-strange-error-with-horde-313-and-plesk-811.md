---
title: Strange error with Horde 3.1.3 and Plesk 8.1.1
author: Major Hayden
type: post
date: 2008-03-11T02:49:05+00:00
url: /2008/03/10/strange-error-with-horde-313-and-plesk-811/
dsq_thread_id:
  - 3678993852
tags:
  - horde
  - php
  - plesk

---
I saw a ticket the other day where a customer received this error from Horde when trying to expand items on the left pane of the interface:

`Fatal error: Cannot use string offset as an array in /www/horde/lib/Horde/Block/Layout/Manager.php on line 389`

It turns out that Plesk 8.1.1 bundles Horde 3.1.3 which has an occasional bug within the interface. Upgrading to Plesk 8.2.0 corrects the issue as Horde 3.1.4 is installed with the upgrade.

See [Horde's bug page][1] for more information.

 [1]: http://bugs.horde.org/ticket/?id=4070
