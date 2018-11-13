---
title: 'Reduce iowait in Plesk: put qmail’s queue on a ramdisk'
author: Major Hayden
type: post
date: 2008-03-14T18:16:57+00:00
url: /2008/03/14/reduce-iowait-in-plesk-put-qmails-queue-on-a-ramdisk/
dsq_thread_id:
  - 3642771041
tags:
  - iowait
  - mail
  - plesk
  - qmail

---
I really dislike qmail. But, since I use Plesk, I'm stuck with it. However, I found a way to improve it's awful mail queue performance by putting the mail queue onto a ramdisk. This is actually pretty darned easy to do.

First, toss a line like this into your /etc/fstab:

`</p>
<pre>none    /mailqueue      tmpfs   defaults,size=100m,nr_inodes=999k,mode=775      0       0</pre>
<p>`

This will make a 100MB ramdisk on /mailqueue. Now, just symlink /var/qmail/mqueue to /mailqueue and move your e-mail over:

\# mount /mailqueue

\# chmod 750 /mailqueue

\# chown qmailq:qmail /mailqueue

\# mv /var/qmail/mqueue /var/qmail/mqueue-old

\# ln -s /mailqueue /var/qmail/mqueue

\# rsync -av /var/qmail/mqueue-old /mailqueue

This has significantly cut the iowait on my server during heavy e-mail periods. In addition, tools like [qmHandle][1] now fly through my mail queue and give me reports very quickly.

 [1]: http://sourceforge.net/projects/qmhandle
