---
aliases:
- /2007/07/29/add-spam-filtering-for-all-users-in-plesk/
author: Major Hayden
date: 2007-07-30 02:46:10
tags:
- plesk
title: Add spam filtering for all users in Plesk
---

These two commands will enable SpamAssassin for all users on a Plesk 8 server:

```
# mysql -u admin -p`cat /etc/psa/.psa.shadow` psa
mysql> update mail set spamfilter = 'true' where postbox = 'true';
# /usr/local/psa/admin/bin/mchk --with-spam
```

Thanks to Sean R. for this one!