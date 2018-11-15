---
title: Qmail-smtpd spawns many processes and uses 100% of CPU
author: Major Hayden
type: post
date: 2007-08-22T02:47:18+00:00
url: /2007/08/21/qmail-smtpd-spawns-many-processes-and-uses-100-of-cpu/
dsq_thread_id:
  - 3672428806
tags:
  - emergency
  - mail
  - plesk

---
It's not abnormal for qmail act oddly at times with Plesk, and sometimes it can use 100% of the CPU. However, if you find qmail's load to be higher than usual with a small volume of mail, there may be a fix that you need.

First off, check for two files in **/var/qmail/control** called **dh512.pem** and **dh1024.pem**. If they are present, well, then this article won't be able to help you. You have a different issue that is causing increased CPU load (check for swap usage and upgrade your disk's speed).

If the files aren't there, do the following:

```
# cd /var/qmail/control
# cp dhparam512.pem dh512.pem
# cp dhparam1024.pem dh1024.pem
# /etc/init.d/qmail restart
# /etc/init.d/xinetd restart
```

At this point, your CPU load should be reduced once the currently running processes for qmail clear out.

So why is this fix required? Without dh512.pem and dh1024.pem, qmail has to create certificate and key pairs when other mail servers or mail users connect to qmail via TLS. If qmail is forced to generate them on the fly, you will get a big performance hit, and your load will be much higher than it could be. By copying the dhparam files over, you will pre-populate the SSL key and certificate for qmail to use, and all it has to do is pick it up off the file system rather than regenerating it each time.

Further reading:

[SWsoft Forums: Qmail-smtpd spawning many processes, using full cpu][1]

 [1]: http://forum.swsoft.com/printthread.php?threadid=40173
