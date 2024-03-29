---
aliases:
- /2007/05/27/forward-e-mail-sent-to-non-existent-users-in-postfix/
author: Major Hayden
date: 2007-05-27 16:43:08
tags:
- mail
title: Forward e-mail sent to non-existent users in Postfix
---

Normally, Postfix will reject e-mail sent to non-existent users if a catchall isn't present for the specific domain that is receiving mail. However, you can make a super catchall to catch any and all e-mail that Postfix receives for the domains in its mydestination list:

Add the following to /etc/postfix/main.cf:

```
luser_relay = root
local_recipient_maps =
```

Then reload the Postfix configuration:

```
# postfix reload
```

For more information: http://www.postfix.org/rewrite.html#luser_relay