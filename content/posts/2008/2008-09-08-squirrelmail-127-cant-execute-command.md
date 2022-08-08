---
title: 'SquirrelMail: 127 Can’t execute command'
author: Major Hayden
date: 2008-09-08T17:16:00+00:00
url: /2008/09/08/squirrelmail-127-cant-execute-command/
dsq_thread_id:
  - 3642771963
tags:
  - php
  - plesk
  - sendmail
  - squirrelmail

---
I found a Plesk 8.3 server running RHEL 4 last month that was presenting errors when users attempted to send e-mail via SquirrelMail:

```
ERROR:
Email delivery error
Server replied: 127 Can't execute command '/usr/sbin/sendmail -i -t -fsomeuser@somedomain.com'.
```

The error was appearing because safe\_mode was enabled and SquirrelMail was unable to drop e-mails into /usr/sbin/squirrelmail. After disabling safe\_mode on the server, the users were able to send e-mails via SquirrelMail.
