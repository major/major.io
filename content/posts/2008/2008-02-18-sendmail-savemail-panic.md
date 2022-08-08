---
title: 'sendmail: savemail panic'
author: Major Hayden
date: 2008-02-18T18:56:37+00:00
url: /2008/02/18/sendmail-savemail-panic/
dsq_thread_id:
  - 3642770955
tags:
  - mail
  - sendmail

---
If you see a large mail queue and your system's I/O is increasing, you may find messages like these in your syslog:

`Losing q5/qfg9N5EwE3004499: savemail panic<br />
SYSERR(root): savemail: cannot save rejected email anywhere`

In this situation, there's some reason why sendmail cannot deliver e-mail to the postmaster address. There's a few issues that can create this problem:

  * Missing postmaster alias in /etc/aliases
  * Hard disk is full
  * The mail spool for the postmaster has the wrong ownership
  * The mbox file for the postmaster is over 2GB and procmail can't deliver the e-mail

First, correct the situation that is preventing sendmail from delivering the e-mail to the postmaster user. Then, stop sendmail, clear the e-mail queue, and start sendmail again.

I found this issue on a Red Hat Enterprise Linux 4 server and then found the solution on [Brandon's][1] site.

 [1]: http://www.brandonhutchinson.com/savemail_panic_in_Sendmail.html
