---
aliases:
- /2007/08/22/pop3-server-disconnects-immediately-after-login/
author: Major Hayden
date: 2007-08-23 03:54:52
dsq_thread_id:
- 3679029872
tags:
- mail
title: POP3 server disconnects immediately after login
---

When connecting to your server's POP3 service, your client might provide this error just after authentication:

`The connection to the server was interrupted.`

Your best bet is to check the mail log and see exactly what the problem is:

```
web pop3-login: Login: john [192.168.0.5]
pop3(john): Invalid mbox file /var/spool/mail/john: No such file or directory
pop3(john): Failed to create storage with data: mbox:/var/spool/mail/john
dovecot: child 29864 (pop3) returned error 89
```

In this case, the mbox file has become corrupt (possible from malformed 'From' headers). You have the option of repairing the issues within the file, or you can simply create a new mail spool for the user.