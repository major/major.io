---
aliases:
- /2006/12/28/cant-kill-sendmail-processes/
author: Major Hayden
date: 2006-12-29 00:35:18
dsq_thread_id:
- 3651535328
tags:
- mail
title: Can’t Kill Sendmail Processes
---

If you find yourself in the sticky situation where `kill -9` still won't kill a sendmail process, check the process list. If `ps fax` returns a "D" status code, you won't be able to stop the process. It's in an "uninterruptable sleep" state which cannot be killed.

What can you do to fix this? Check for file locking. Are files in the mail queue directory locked? Are the files in the mail queue mounted over NFS (by an idiotic administrator)? If so, the only fix is to set sendmail to not start on reboot, then reboot the box.