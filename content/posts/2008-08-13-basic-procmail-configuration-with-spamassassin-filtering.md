---
title: Basic procmail configuration with spamassassin filtering
author: Major Hayden
type: post
date: 2008-08-13T17:00:48+00:00
url: /2008/08/13/basic-procmail-configuration-with-spamassassin-filtering/
dsq_thread_id:
  - 3678975558
categories:
  - Blog Posts
tags:
  - postfix
  - procmail
  - sendmail
  - spamassassin

---
I've used this extremely basic procmail configuration a million times, and it's a great start for any server configuration. It passes e-mails through spamassassin (if they're smaller than 256KB) and then filters any e-mail marked as spam to /dev/null:

```
LOGFILE=/var/log/procmail.log
DROPPRIVS=yes</p>
<p>:0fw
| /usr/bin/spamc</p>
<p>:0
* ^X-Spam-Status: Yes
/dev/null
```

Of course, you can make this much more complicated with some additional customization.
