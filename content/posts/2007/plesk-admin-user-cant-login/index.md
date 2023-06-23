---
aliases:
- /2007/01/24/plesk-admin-user-cant-login/
author: Major Hayden
date: 2007-01-24 15:35:37
dsq_thread_id:
- 3642764739
tags:
- security
title: Plesk admin user can’t login
---

Okay, so you've verified that the correct admin password is being used, but you still can't login? Most likely the account has been locked out. You can reset the account by running the following SQL statement:

```
echo "use psa; truncate lockout;" | mysql -u root -p\`cat /etc/psa/.psa.shadow\`
```