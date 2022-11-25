---
title: 'mchk: Unable to initialize quota settings for someuser@somedomain.com'
author: Major Hayden
date: 2008-04-14T17:00:21+00:00
url: /2008/04/14/mchk-unable-to-initialize-quota-settings-for-someusersomedomaincom/
dsq_thread_id:
  - 3678991006
tags:
  - mail
  - plesk

---
If you're working in Plesk and you receive this error:

**mchk: Unable to initialize quota settings for someuser@somedomain.com**

Run this command to fix the issue, but be patient:

```
find /var/qmail/mailnames -type d -name '.*' ! -name '.spamassassin' -ls -exec touch '{}'/maildirfolder \; -exec chown popuser:popuser '{}'/maildirfolder \;
```

> Thanks to [Mike Jackson][1] for this one.

 [1]: http://barking-dog.net/
