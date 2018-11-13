---
title: Correcting Horde problems after upgrading to PHP 5 on Plesk 7.5.x
author: Major Hayden
type: post
date: 2007-08-11T02:08:49+00:00
url: /2007/08/10/correcting-horde-problems-after-upgrading-to-php-5-on-plesk-75x/
dsq_thread_id:
  - 3679034003
tags:
  - plesk
  - web

---
With Plesk 7.5.x, a PHP upgrade to version 5 will cause some issues with Horde. These issues stem from problems with the pear scripts that Horde depends on.

To fix it, run these commands:

`# pear upgrade DB<br />
# cp -a /usr/share/pear/DB.php /usr/share/pear/DB/ /usr/share/psa-horde/pear/`

> Credit for this fix goes to Mike J.