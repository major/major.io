---
title: Reset MySQL root password
author: Major Hayden
date: 2007-03-26T03:27:33+00:00
url: /2007/03/25/reset-mysql-root-password/
dsq_thread_id:
  - 3679060411
tags:
  - database
  - security

---
If you've forgotten the root password for a MySQL server, but you know the system root, you can reset the MySQL root password pretty easily. Just remember to work quickly since the server is wide open until you finish working.

First, add `skip-grant-tables` to the `[mysqld]` section of /etc/my.cnf and restart the MySQL server.

Next, run `mysql` from the command line and use the following SQL statement:

```sql
UPDATE mysql.user SET Password=PASSWORD('newpwd') WHERE User='root';<br />
FLUSH PRIVILEGES;
```

Remove the `skip-grant-tables` from /etc/my.cnf and leave the server running. There's no need to restart it.
