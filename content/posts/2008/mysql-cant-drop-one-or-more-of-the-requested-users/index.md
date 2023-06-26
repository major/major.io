---
aliases:
- /2008/06/11/mysql-cant-drop-one-or-more-of-the-requested-users/
author: Major Hayden
date: 2008-06-11 23:59:37
tags:
- mysql
- security
title: 'MySQL: Can’t drop one or more of the requested users'
---

MySQL has quite a few cryptic error messages, and this one is one of the best:

```
mysql> DROP USER 'forums'@'db1.myserver.com';
ERROR 1268 (HY000): Can't drop one or more of the requested users
```

Naturally, I was quite interested to know why MySQL wasn't going to allow me to remove this user. There was nothing special about the user, but then again, this wasn't a server that I personally managed, so I wasn't sure what kind of configuration was in place.

It's always a good idea to get your bearings, so I checked the current grants:

    mysql> SHOW GRANTS FOR 'forums'@'db1.myserver.com';
    +----------------------------------------------------------------------+
    | Grants for forums@db1.myserver.com                                   |
    +----------------------------------------------------------------------+
    | GRANT USAGE ON *.* TO 'forums'@'db1.myserver.com' WITH GRANT OPTION  |
    +----------------------------------------------------------------------+
    1 row in set (0.00 sec)

The GRANT OPTION was causing my grief. It was the only privilege that the user had on the server. I revoked the privilege and attempted to drop the user yet again:

```
mysql> REVOKE GRANT OPTION ON *.* FROM 'forums'@'db1.myserver.com';
Query OK, 0 rows affected (0.00 sec)
mysql> DROP USER 'forums'@'db1.myserver.com';
Query OK, 0 rows affected (0.00 sec)
```

It's key to remember that revoking the GRANT OPTION is a completely separate process. Revoking ALL PRIVILEGES doesn't include GRANT OPTION, so be sure to specify it separately:

```
mysql> REVOKE ALL PRIVILEGES, GRANT OPTION ON *.* FROM 'user'@'host';
```