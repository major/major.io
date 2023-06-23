---
aliases:
- /2007/01/11/rebuilding-the-qmail-queue/
author: Major Hayden
date: 2007-01-11 22:37:07
dsq_thread_id:
- 3642764714
tags:
- mail
title: Repairing the qmail queue
---

There are three main things to remember when it comes to the qmail queue:

1. Don't mess with the qmail queue while qmail is running.
2. Don't mess with the qmail queue while qmail is stopped.
3. Don't mess with the qmail queue **ever**.

The qmail application keeps a database (sort of) of the pieces of mail it expects to be in the queue (and on the filesystem). Many python scripts (like mailRemove.py) claim they will speed up your qmail queue by removing failure notices and tidying up the queue files. Most of the time, these scripts work just fine, but sometimes they remove something they shouldn't and then qmail can't find the file.

What does qmail do when it can't find the file that corresponds to an item in the queue? It stops delivering mail, eats the CPU, and cranks the load average up. Impressive, isn't it?

Should you find yourself with an impressively hosed qmail queue, do the following (and say goodbye to every e-mail in your queue):

```
/etc/init.d/qmail stop
cd /var/qmail/queue
rm -rf info intd local mess remote todo
mkdir mess
for i in `seq 0 22`; do
mkdir mess/$i
done
cp -r mess info
cp -r mess intd
cp -r mess local
cp -r mess remote
cp -r mess todo
chmod -R 750 mess todo
chown -R qmailq:qmail mess todo
chmod -R 700 info intd local remote
chown -R qmailq:qmail intd
chown -R qmails:qmail info local remote
/etc/init.d/qmail start
```

**Just in case you missed it,** this will delete **all mail messages** that exist in your queue. But, then again, you're not going to get those messages anyways (thanks qmail!), so repairing the queue is your only option.