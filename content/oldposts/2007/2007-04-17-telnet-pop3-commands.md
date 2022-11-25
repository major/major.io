---
title: Telnet POP3 Commands
author: Major Hayden
date: 2007-04-17T22:28:19+00:00
url: /2007/04/17/telnet-pop3-commands/
dsq_thread_id:
  - 3679055268
tags:
  - command line
  - mail

---
If you ever need to communicate with a POP3 server via telnet to test it, here's some commands you can use:

```
USER userid
PASS password
STAT
LIST
RETR msg#
TOP msg# #lines
DELE msg#
RSET
QUIT
```
