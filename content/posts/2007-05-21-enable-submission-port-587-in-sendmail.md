---
title: Enable submission port 587 in Sendmail
author: Major Hayden
type: post
date: 2007-05-21T16:08:34+00:00
url: /2007/05/21/enable-submission-port-587-in-sendmail/
dsq_thread_id:
  - 3642767494
tags:
  - mail

---
To enable submission access on port 587 in sendmail, add the following to the sendmail.mc:

``DAEMON_OPTIONS(`Port=submission, Name=MSA, M=Ea')dnl``

Rebuild the sendmail.cf file and restart sendmail.