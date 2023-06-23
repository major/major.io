---
aliases:
- /2007/02/07/getting-the-smtp-auth-id-with-plesk/
author: Major Hayden
date: 2007-02-07 12:54:29
dsq_thread_id:
- 3642765151
tags:
- plesk
title: Getting the SMTP Auth ID with Plesk
---

If you think an e-mail account has been hacked in Plesk, use this to hunt down which one it could be:

```
cat /var/log/messages | grep -i smtp_auth | grep "logged in" | awk {' print $11 '} | awk -F / {' print $6"@"$5 '} | sort | uniq -c | sort -n | tail
```