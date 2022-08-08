---
title: 'clamdscan: corrupt or unknown clamd scanner error or memory/resource/perms problem'
author: Major Hayden
date: 2007-11-16T18:11:05+00:00
url: /2007/11/16/clamdscan-corrupt-or-unknown-clamd-scanner-error-or-memoryresourceperms-problem/
dsq_thread_id:
  - 3642773671
tags:
  - clamd
  - mail

---
A few days ago, I stumbled upon a server running qmail with qmail-scanner. The server was throwing out this error when a user on the server attempted to send an e-mail to someone else:

`451 qq temporary problem (#4.3.0)`

The one thing I love about qmail is its extremely descriptive error messages. Did I say descriptive? I meant cryptic.

Luckily, clamdscan was a bit more chatty in the general system logs:

`Nov 12 10:21:17 server X-Antivirus-MYDOMAIN-1.25-st-qms: server.somehost.com119488087677512190] clamdscan: corrupt or unknown clamd scanner error or memory/resource/perms problem - exit status 512/2` 

Okay, that helps a bit, but this one from /var/log/clamd.log was the big help:

`Mon Nov 12 12:20:29 2007 -> ERROR: Socket file /tmp/clamd.socket exists. Either remove it, or configure a different one.` 

I removed the /tmp/clamd.socket file and clamd began operating properly after a quick restart of the clamd service. This one was pretty easy, but it was not well documented (as I discovered from a little while of Google searching).