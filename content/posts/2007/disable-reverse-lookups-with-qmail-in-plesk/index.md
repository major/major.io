---
aliases:
- /2007/04/05/disable-reverse-lookups-with-qmail-in-plesk/
author: Major Hayden
date: 2007-04-05 16:00:53
dsq_thread_id:
- 3642766313
tags:
- mail
- plesk
title: Disable reverse lookups with qmail in Plesk
---

To disable reverse lookups in qmail with Plesk, simply add -Rt0 to the `server_args` line in /etc/xinetd.d/smtp_psa

```

service smtp
{
        socket_type     = stream
        protocol        = tcp
        wait            = no
        disable         = no
        user            = root
        instances       = UNLIMITED
        server          = /var/qmail/bin/tcp-env
        server_args     = <strong>-Rt0</strong> /usr/sbin/rblsmtpd  -r sbl-xbl.spamhaus.org /var/qmail/bin/relaylock /var/qmail/bin/qmail-smtpd /var/qmail/bin/smtp_auth /var/qmail/bin/true /var/qmail/bin/cmd5checkpw /var/qmail/bin/true
}
```

Once that's been saved, simply restart xinetd:

```
# /etc/init.d/xinetd restart
```

**WATCH OUT!** This change will be overwritten if you change certain mail settings in Plesk, like MAPS protection.