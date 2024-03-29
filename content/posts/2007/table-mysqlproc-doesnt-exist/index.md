---
aliases:
- /2007/11/29/table-mysqlproc-doesnt-exist/
author: Major Hayden
date: 2007-11-29 18:37:55
tags:
- database
- mysql
title: Table ‘mysql.proc’ doesn’t exist
---

After I was asked to create a stored procedure on a MySQL 5.0.45 installation last week, I received the following error:

`ERROR 1146 at line 24: Table 'mysql.proc' doesn't exist`

The server had the default MySQL 4.1.20 that comes with Red Hat Enterprise Linux 4, and it was upgraded to MySQL 5.0.45. After the upgrade, the `mysql_upgrade` script wasn't run, so the privilege tables were wrong, and the special tables for procedures and triggers did not exist.

To fix the problem, I ran:

`# /usr/bin/mysql_upgrade`

After about 20 seconds, the script completed and I was able to add a stored procedure without a problem.