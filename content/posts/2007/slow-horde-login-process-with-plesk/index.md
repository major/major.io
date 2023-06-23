---
aliases:
- /2007/10/05/slow-horde-login-process-with-plesk/
author: Major Hayden
date: 2007-10-05 18:35:33
dsq_thread_id:
- 3642773885
tags:
- mail
- plesk
- web
title: Slow Horde login process with Plesk
---

I've seen quite a few situations where the Horde login process can take upwards of 45 minutes to log a user into the webmail interface. There's a few issues that can cause these extended delays, and most of them can be fixed rather easily:

**Too many filters / Giant whitelists and blacklists**

This is the biggest cause that I've seen. Some users will create gigantic white and black lists (upwards of 5,000 is my record that I've seen) and this makes Horde compare each and every message in the inbox against these lists upon login. This also applies to filters as Plesk does not use sieve/procmail for mail delivery. Horde is forced to do all of the filtering upon login (in some versions) and this can cause extreme delays.

**Mailbox is gigantic**

I've seen Horde logins take quite a while in mailboxes that are over 500MB in size. If the size of your e-mails is large, and you have a large mailbox with fewer e-mails, Horde can normally work quickly. But, if your inbox is full of tiny e-mails, Horde takes a long time to fully index your mail and display the list (even though it only displays 25-30 at a time).

**Too many users logged into Horde simultaneously**

In my opinion, Horde's CPU and memory requirements are too large for a webmail application. I've seen 30-40 simultaneous Horde sessions bring a dual-core box with 2-4GB of RAM and SCSI disks to its knees. Consider installing squirrelmail or roundcube webmail for some of your users and urge them to use it instead.

**IOwait caused by something else**

Sometimes the server can simply be bogged down with other requests from other daemons, and this slows Horde down. Make sure that your MySQL installation is tuned properly, and that users are not abusing scripts running through Apache.