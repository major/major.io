---
aliases:
- /2008/03/24/setting-the-maximum-mail-size-in-qmail/
author: Major Hayden
date: 2008-03-24 18:54:35
tags:
- mail
- plesk
- qmail
title: Setting the maximum mail size in qmail
---

On a Plesk server, the maximum size for an individual e-mail sent through qmail is unlimited. You can limit this size by adding a number to the /var/qmail/control/databytes file.

If you wanted to limit this to something like 10MB, you can just run the following command:

```
echo "10485760" > /var/qmail/control/databytes
```

This will limit the size of messages (including attachments) to 10MB as a maximum.