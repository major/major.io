---
aliases:
- /2007/04/17/telnet-pop3-commands/
author: Major Hayden
date: 2007-04-17 22:28:19
dsq_thread_id:
- 3679055268
tags:
- command line
- mail
title: Telnet POP3 Commands
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