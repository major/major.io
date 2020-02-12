---
title: Table ‘mysql.proc’ doesn’t exist
author: Major Hayden
type: post
date: 2007-11-29T18:37:55+00:00
url: /2007/11/29/table-mysqlproc-doesnt-exist/
dsq_thread_id:
  - 3642773410
tags:
  - database
  - mysql

---
After I was asked to create a stored procedure on a MySQL 5.0.45 installation last week, I received the following error:

`ERROR 1146 at line 24: Table 'mysql.proc' doesn't exist`

The server had the default MySQL 4.1.20 that comes with Red Hat Enterprise Linux 4, and it was upgraded to MySQL 5.0.45. After the upgrade, the `mysql_upgrade` script wasn't run, so the privilege tables were wrong, and the special tables for procedures and triggers did not exist.

To fix the problem, I ran:

`# /usr/bin/mysql_upgrade`

After about 20 seconds, the script completed and I was able to add a stored procedure without a problem.
