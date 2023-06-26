---
aliases:
- /2007/01/24/increase-mysql-connection-limit/
author: Major Hayden
date: 2007-01-24 17:21:37
tags:
- database
title: Increase MySQL connection limit
---

MySQL's default configuration sets the maximum simultaneous connections to 100. If you need to increase it, you can do it fairly easily:

For MySQL 3.x:

```
# vi /etc/my.cnf
set-variable = max_connections = 250
```

For MySQL 4.x and 5.x:

```
# vi /etc/my.cnf
max_connections = 250
```

Restart MySQL once you've made the changes and verify with:

```
echo "show variables like 'max_connections';" | mysql
```

**WHOA THERE:** Before increasing MySQL's connection limit, you really owe it to yourself (and your server), to [find out why you're reaching the maximum number of connections][1]. Over 90% of the MySQL servers that are hitting the maximum connection limit have a performance limiting issue that needs to be corrected instead.

 [1]: http://rackerhacker.com/2008/06/24/mysql-error-1040-too-many-connections/