---
title: Finding usernames and passwords in Plesk DB
author: Major Hayden
date: 2007-01-26T15:12:22+00:00
url: /2007/01/26/finding-usernames-and-passwords-in-plesk-db/
dsq_thread_id:
  - 3642764938
tags:
  - plesk

---
Need a username and password from the Plesk DB? Use this one-liner:

```sql
select REPLACE(sys_users.home,'/home/httpd/vhosts/','') AS domain,sys_users.login,accounts.password from sys_users LEFT JOIN accounts on sys_users.account_id=accounts.id;
```
