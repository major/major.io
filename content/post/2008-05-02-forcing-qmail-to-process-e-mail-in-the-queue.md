---
title: Forcing qmail to process e-mail in the queue
author: Major Hayden
type: post
date: 2008-05-02T17:00:51+00:00
url: /2008/05/02/forcing-qmail-to-process-e-mail-in-the-queue/
dsq_thread_id:
  - 3642771211
tags:
  - mail
  - plesk

---
Normally, qmail will be able to process the mail queue without any interaction from the system administrator, however, if you want to force it to process everything that is in the queue right now, you can do so:

`` kill -ALRM `pgrep qmail-send` ``

If for some peculiar reason you don't have pgrep on your server, you can go about it a slightly different way:

`` kill -ALRM `ps ax | grep qmail-send | grep -v grep | awk '{print $1}'` ``

Your logs should begin filling up with data about e-mails rolling through the queue.
