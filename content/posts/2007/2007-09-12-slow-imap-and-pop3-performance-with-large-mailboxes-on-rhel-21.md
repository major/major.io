---
title: Slow IMAP and POP3 performance with large mailboxes on RHEL 2.1
author: Major Hayden
date: 2007-09-12T13:00:32+00:00
url: /2007/09/12/slow-imap-and-pop3-performance-with-large-mailboxes-on-rhel-21/
dsq_thread_id:
  - 3648526582
tags:
  - mail

---
By default, Red Hat Enterprise Linux 2.1 comes with UW-IMAP which runs from xinetd. This is fine for most users, but when mailbox sizes creep upwards of 500MB, you may notice odd performance degradations and undelivered mail.

This is because UW-IMAP only supports [mbox][1] files in RHEL 2.1. This means your e-mail ends up in one big file which has each e-mail listed one after another. This is a simple way to handle mail, but it scales in a horrible fashion.

[Daniel Bernstein][2], the creator of [qmail][3], created [maildir][4], and (as much as I hate anything relating to qmail) it's the best method for storing mail that I've seen so far.

Mbox files are slower because the entire file must be scanned when the POP or IMAP daemon receive a request for an e-mail held within it. That means that the daemon must scan through all of the e-mails until the one that it wants is found. If sendmail wants to drop off e-mail for the user, it has to wait since the mail spool is locked. If it can't deliver the e-mail, it may bounce it after a period of time.

This is especially awful if a user receives a fair amount of e-mail and checks their e-mail from a mobile device. This means that their computer and the mobile device are making the mail daemons scan the mbox file repeatedly when they check in. It causes sendmail to back up, disk I/O skyrockets, and the server performance as a whole can suffer.

The solution is to move to a newer version of RHEL, hopefully RHEL 4 or 5 where Postfix and maildir support are available. The only fix on RHEL 2.1 is to ask the user to clear out their mailbox to reduce the amount of disk I/O required to pick up e-mail.

 [1]: http://en.wikipedia.org/wiki/Mbox
 [2]: http://en.wikipedia.org/wiki/Daniel_J._Bernstein
 [3]: http://en.wikipedia.org/wiki/Qmail
 [4]: http://en.wikipedia.org/wiki/Maildir
