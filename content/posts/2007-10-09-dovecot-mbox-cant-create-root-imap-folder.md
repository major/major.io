---
title: 'Dovecot: mbox: Can’t create root IMAP folder'
author: Major Hayden
type: post
date: 2007-10-10T01:05:52+00:00
url: /2007/10/09/dovecot-mbox-cant-create-root-imap-folder/
dsq_thread_id:
  - 3659565922
tags:
  - dovecot
  - mail

---
In some situations with dovecot running on your server, you may receive a message from your e-mail client stating that the "connection was interrupted with your mail server" or the "login process failed". This may happen even if you've created the e-mail account, created the mail spool, and set a password for the user.

If you check your /var/log/maillog, you will generally find errors like these:

```
Oct 7 09:37:45 mailserver pop3-login: Login: newuser [111.222.333.444]<br />
Oct 7 09:37:45 mailserver pop3(newuser): mbox: Can't create root IMAP folder /home/newuser/mail: Permission denied<br />
Oct 7 09:37:45 mailserver pop3(newuser): Failed to create storage with data: mbox:/var/spool/mail/newuser
```

Dovecot is telling you that it wants to store some mail-related data in the user's home directory, but it can't get access to the user's home directory. If the home directory doesn't exist, create it and set the permissions properly:

```
# mkdir /home/newuser<br />
# chown newuser:newuser /home/newuser<br />
# chmod 755 /home/newuser
```

If the directory is already there, double check the ownership and permissions on the directory. If filesystem acl's or filesystem quotas might be in play, be sure to check those as well.
