---
title: 'Private: Forcefully clearing the qmail queue'
author: Major Hayden
type: post
date: 2007-07-18T14:58:47+00:00
draft: true
private: true
url: /2007/07/18/forcefully-clearing-the-qmail-queue/
dsq_thread_id:
  - 3642768694
categories:
  - Blog Posts
tags:
  - command line
  - mail
  - plesk

---
If you have the need to forcefully delete everything in the qmail queue, simply run this shell script (thanks to Florian on this one):

`#!/bin/sh</p>
<h1>remove everything - STOP QMAIL FIRST!</h1>
<p>/sbin/service qmail stop<br />
for i in bounce info intd local mess remote todo; do<br />
find /var/qmail/queue/$i -type f -exec rm {} \;<br />
done<br />
/sbin/service qmail start`