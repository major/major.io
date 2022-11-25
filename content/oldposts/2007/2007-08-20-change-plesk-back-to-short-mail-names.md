---
title: Change Plesk back to short mail names
author: Major Hayden
date: 2007-08-21T00:46:50+00:00
url: /2007/08/20/change-plesk-back-to-short-mail-names/
dsq_thread_id:
  - 3646071994
tags:
  - mail

---
If you have to use short e-mail usernames in Plesk (which is a bad idea), and someone accidentally sets the server to use full usernames, you can force Plesk to go back. You can't do this in the interface, however. Plesk realizes that duplicate mail names exist, and it wont allow the change.

Plesk will say something like:

_Unable to allow the use of short mail names for POP3/IMAP accounts. There are mail names matching the encrypted passwords._

Forcing it back is easy with one SQL statement:

```
# mysql -u admin -p`cat /etc/psa/.psa.shadow` psa
mysql> UPDATE misc set val='enabled' where param='allow_short_pop3_names';
```

Keep in mind that users logging in with shortnames will get into the same mailbox if they have the same username and password.

Additional reading:

[How can I change back the option "Use of short and full POP3/IMAP mail account names is allowed" forcedly?][1]

 [1]: http://kb.swsoft.com/en/888?st=advc
