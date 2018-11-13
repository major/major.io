---
title: Disable reverse lookups with qmail in Plesk
author: Major Hayden
type: post
date: 2007-04-05T16:00:53+00:00
url: /2007/04/05/disable-reverse-lookups-with-qmail-in-plesk/
dsq_thread_id:
  - 3642766313
tags:
  - mail
  - plesk

---
To disable reverse lookups in qmail with Plesk, simply add -Rt0 to the `server_args` line in /etc/xinetd.d/smtp_psa

`<br />
service smtp<br />
{<br />
        socket_type     = stream<br />
        protocol        = tcp<br />
        wait            = no<br />
        disable         = no<br />
        user            = root<br />
        instances       = UNLIMITED<br />
        server          = /var/qmail/bin/tcp-env<br />
        server_args     = <strong>-Rt0</strong> /usr/sbin/rblsmtpd  -r sbl-xbl.spamhaus.org /var/qmail/bin/relaylock /var/qmail/bin/qmail-smtpd /var/qmail/bin/smtp_auth /var/qmail/bin/true /var/qmail/bin/cmd5checkpw /var/qmail/bin/true<br />
}<br />
`

Once that's been saved, simply restart xinetd:

`# /etc/init.d/xinetd restart`

**WATCH OUT!** This change will be overwritten if you change certain mail settings in Plesk, like MAPS protection.
