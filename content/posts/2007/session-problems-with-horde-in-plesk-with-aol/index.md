---
aliases:
- /2007/09/27/session-problems-with-horde-in-plesk-with-aol/
author: Major Hayden
date: 2007-09-28 02:06:52
tags:
- mail
- plesk
- web
title: Session problems with Horde in Plesk with AOL
---

Since AOL sends their users' traffic through proxy servers, this can cause problems with Horde's session handling in Plesk. The problem arises when the user's IP changes during the middle of the session.

You may see an error message in Horde that looks like this:

> Your Internet Address has changed since the beginning of your Mail session. To protect your security, you must login again.

You'll normally have this variable in /etc/psa-horde/horde/conf.php:

`# $conf['auth']['checkip'] = true;`

You can disable this ip check functionality which breaks sessions for AOL users by setting it to false:

`# $conf['auth']['checkip'] = false;`