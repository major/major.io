---
aliases:
- /2007/08/08/urchin-warning-task-scheduler-disabled/
author: Major Hayden
date: 2007-08-09 00:48:20
tags:
- web
title: 'Urchin: Warning! Task scheduler disabled.'
---

When Urchin's task scheduler fails, you'll notice big gaps in your data within Urchin. If your logs rotate out before someone catches the problem, then your data is gone, and unless you have it backed up, you're out of luck. I've scoured the internet (and Urchin gurus) and I've yet to find a complete explanation for the occasional death of Urchin's task scheduler.

You'll see the "Warning! Task scheduler disabled." error in bright red print in Urchin's configuration menu when you click the "Run/Schedule" tab. It appears right below the gleaming "Run Now" button. If you click "Run Now", Urchin will tell you again that the task scheduler is disabled.

To correct the problem, completely stop Urchin as root:

```
# /etc/init.d/urchin stop
-- OR --
# /usr/local/urchin/bin/urchinctl stop
```

Now, change to the /usr/local/urchin/bin directory and run:

```
# ./urchinctl status
```

If the Urchin webserver is running, but the task scheduler isn't (which is the most likely situation), run:

```
# ./urchinctl -s start
# ./urchinctl status
Urchin webserver is running
Urchin scheduler is running
```

You should be all set. Credit for this fix goes to [Urchin's site][1].

 [1]: http://www.google.com/support/urchin45/bin/answer.py?answer=28337&topic=7401