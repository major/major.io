---
title: Issues with mysqldump and views in Plesk
author: Major Hayden
type: post
date: 2007-08-18T17:40:00+00:00
url: /2007/08/18/issues-with-mysqldump-and-views-in-plesk/
dsq_thread_id:
  - 3642769593
tags:
  - database
  - plesk

---
By default, views in MySQL 5.x are created with a security definer set to the root user. However, Plesk drops the root user from MySQL and replaces it with the admin user. When this happens, your views cannot by dumped by mysqldump since the root user (the security definer for the view) doesn't exist in the mysql.user table.

You receive an error similar to the following:

```
mysqldump: Couldn't execute 'SHOW FIELDS FROM `some_tablename`': There is no 'root'@'localhost' registered (1449)
```

Usually, if you run a `SHOW CREATE VIEW tablename`, you'll see something like this:

```sql
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `some_tablename` AS select distinct `some_database`.`some_tablename`.`some_column` AS `alias` from `some_tablename`
```

You have two options in this situation:

  * Change the security definer for each of your views to 'admin'@'localhost'. Any new views you create will need to be adjusted as well.
  * Create a root user in MySQL with the same privileges as the admin user and use the root user's login to run mysqldump.
