---
title: 'Dovecot: libsepol.so.1: failed to map segment from shared object: Cannot allocate memory'
author: Major Hayden
type: post
date: 2008-01-22T18:47:21+00:00
url: /2008/01/22/dovecot-libsepolso1-failed-to-map-segment-from-shared-object-cannot-allocate-memory/
dsq_thread_id:
  - 3645798259
tags:
  - dovecot
  - mail

---
You may catch this error when you attempt to start dovecot on a Red Hat Enterprise Linux 5.1 system with the 64-bit architecture:

```
dovecot: imap-login: imap-login: error while loading shared libraries: libsepol.so.1: failed to map segment from shared object: Cannot allocate memory
dovecot: pop3-login: pop3-login: error while loading shared libraries: libsepol.so.1: failed to map segment from shared object: Cannot allocate memory
```

If you start dovecot, the main dovecot daemon will run with one auth child process, but there will be no POP/IMAP processes started. To fix the issue, open the /etc/dovecot.conf and adjust the following directive:

```
login_process_size = 64
```

Restart dovecot after making the change:

```
# /etc/init.d/dovecot restart
```

This was tested on RHEL 5.1 x86_64.
