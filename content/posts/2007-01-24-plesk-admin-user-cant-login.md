---
title: Plesk admin user can’t login
author: Major Hayden
type: post
date: 2007-01-24T15:35:37+00:00
url: /2007/01/24/plesk-admin-user-cant-login/
dsq_thread_id:
  - 3642764739
tags:
  - security

---
Okay, so you've verified that the correct admin password is being used, but you still can't login? Most likely the account has been locked out. You can reset the account by running the following SQL statement:

```
echo "use psa; truncate lockout;" | mysql -u root -p\`cat /etc/psa/.psa.shadow\`
```
