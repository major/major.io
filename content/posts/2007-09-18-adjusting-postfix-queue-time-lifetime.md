---
title: Adjusting postfix queue time / lifetime
author: Major Hayden
type: post
date: 2007-09-18T22:55:38+00:00
url: /2007/09/18/adjusting-postfix-queue-time-lifetime/
dsq_thread_id:
  - 3642770079
tags:
  - mail

---
If you want to adjust how long postfix will hold a piece of undeliverable mail in its queue, just adjust **bounce\_queue\_lifetime**. This variable is normally set to five days by default, but you can adjust it to any amount that you wish. You can set the value to zero, but that will cause e-mails that cannot be immediately sent to be rejected to their senders.

[Postfix Configuration Parameters: bounce\_queue\_lifetime][1]

 [1]: http://www.postfix.org/postconf.5.html#bounce_queue_lifetime