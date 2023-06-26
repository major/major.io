---
aliases:
- /2007/05/21/enable-submission-port-587-in-sendmail/
author: Major Hayden
date: 2007-05-21 16:08:34
tags:
- mail
title: Enable submission port 587 in Sendmail
---

To enable submission access on port 587 in sendmail, add the following to the sendmail.mc:

``DAEMON_OPTIONS(`Port=submission, Name=MSA, M=Ea')dnl``

Rebuild the sendmail.cf file and restart sendmail.