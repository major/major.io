---
aliases:
- /2007/11/27/sort-e-mail-in-plesk-with-procmail/
author: Major Hayden
date: 2007-11-27 18:27:26
dsq_thread_id:
- 3642773445
tags:
- mail
- plesk
- procmail
- qmail
title: Sort e-mail in Plesk with procmail
---

One of my biggest beefs with Plesk's e-mail handling is the lack of server-side filtering. Plesk will only allow you to throw away e-mails marked as spam, but this won't work for me since SpamAssassin marks some mails as spam that actually aren't. If you set up filters in SquirrelMail or Horde, the filters will only work if you **always** log into the webmail interface to snag your e-mail.

Luckily, you can do some fancy work with procmail to have the filtering done server-side.

First, make sure procmail is installed on your server, and change to this directory:

/var/qmail/mailnames/yourdomain.com/yourusername/

Inside that directory, drop in a .procmailrc file which contains the following:

```
MAILDIR=/var/qmail/mailnames/yourdomain.com/yourusername/Maildir
DEFAULT=${MAILDIR}/
SPAMDIR=${MAILDIR}/.Junk/
:0
* ^X-Spam-Status: Yes.*
${SPAMDIR}
```

Once that file is in place, move the .qmail file out of the way, and replace it with this:

```
| /usr/local/psa/bin/psa-spamc accept
|preline /usr/bin/procmail -m -o .procmailrc
```

Please be aware that these changes will disappear if you make any adjustments to your mail configuration within Plesk. To get around this annoyance, just change the file attributes to immutable:

```
# chattr +i .qmail .procmailrc
```

_Credit for this trick goes to [Russ Wittmann][1]._

 [1]: http://www.russwittmann.com/2007/07/14/server-side-mail-filtering-using-qmailprocmail-under-plesk/