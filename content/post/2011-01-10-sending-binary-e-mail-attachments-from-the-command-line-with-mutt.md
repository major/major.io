---
title: Sending binary e-mail attachments from the command line with mutt
author: Major Hayden
type: post
date: 2011-01-11T01:10:58+00:00
url: /2011/01/10/sending-binary-e-mail-attachments-from-the-command-line-with-mutt/
dsq_thread_id:
  - 3642806418
categories:
  - Blog Posts
tags:
  - command line
  - email
  - mutt

---
E-mailing a binary e-mail attachment from a Linux server has always been difficult for me because I never found a reliable method to get it done. I've used `uuencode` to pipe data into `mail` on various systems but the attachment is often unreadable by many e-mail clients.

Someone finally showed me a simple, fool-proof method to send binary attachments reliably from various Linux systems:

```


If you e-mail doesn't arrive, remember to consider the size of the file that you're sending and the restrictions of the receiver's e-mail server. Keep in mind that encoding the binary attachment will cause the size of the e-mail to creep up a bit more (about 1.37x plus a little extra with [Base64][1]).

 [1]: http://en.wikipedia.org/wiki/Base64#MIME
