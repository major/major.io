---
title: 'Plesk: Error opening /var/lib/squirrelmail/prefs/default_pref'
author: Major Hayden
type: post
date: 2007-10-09T00:44:48+00:00
url: /2007/10/08/plesk-error-opening-varlibsquirrelmailprefsdefault_pref/
dsq_thread_id:
  - 3642773793
tags:
  - mail
  - plesk
  - web

---
On brand new Plesk 8.2.x installations or on servers that have been upgraded to Plesk 8.2.x, you might run into this error when you attempt to log into squirrelmail after it was installed via RPM:

> `Error opening /var/lib/squirrelmail/prefs/default_pref<br />
Could not create initial preference file!<br />
/var/lib/squirrelmail/prefs/ should be writable by user apache<br />
Please contact your system administrator and report this error.`

No matter what you do to the /var/lib/squirrelmail/prefs/default_pref file, even if you chmod 777 the file, you will still get the error. If you check the /etc/php.ini, you will normally find `safe_mode` set to **on**.

`;<br />
; Safe Mode<br />
;<br />
safe_mode = Off`

Simply change `safe_mode` to **off** and reload Apache. If you try to log into squirrelmail again, it should complete successfully. I've tested this on Red Hat Enterprise Linux 4:

`# rpm -q squirrelmail<br />
squirrelmail-1.4.8-4.0.1.el4`
