---
title: After Plesk upgrade, “Cannot initialize InnoDB”
author: Major Hayden
date: 2008-05-01T17:00:09+00:00
url: /2008/05/01/after-plesk-upgrade-cannot-initialize-innodb/
dsq_thread_id:
  - 3651763053
tags:
  - database
  - plesk

---
Upgrading Plesk from 7.5.x to 8.x will change your Plesk-related MySQL tables from MyISAM to InnoDB. This allows for better concurrency in the Plesk panel when a lot of users are logged in simultaneously. However, some server administrators will disable InnoDB support in MySQL to save resources. This will cause problems after the upgrade.

Plesk may display an error on a white page that looks something like:

> Cannot initialize InnoDB

This could mean that InnoDB support was disabled when MySQL was started. To correct this issue, search through the /etc/my.cnf for this line:

`skip-innodb`

If you find it in your configuration, remove it, and then restart MySQL. To test that InnoDB is enabled, you can refresh the Plesk page, or you can log into MySQL and run `SHOW ENGINES`. The output from the `SHOW ENGINES` statement should show **YES** on the line with InnoDB.

Should **DISABLED** appear instead, you may have an issue with your InnoDB configuration in your /etc/my.cnf. Be sure to check for innodb\_data\_file_path and make sure that it is set to an appropriate value.

A value of **NO** is not a good sign. This means that your version of MySQL was compiled without InnoDB support. This means that it cannot be enabled at runtime because MySQL wasn't built with any support for InnoDB. Be sure to recompile MySQL with `--with-innodb` or obtain a new package for your operating system which includes InnoDB support.

If you suspect that your MySQL InnoDB configuration is incorrect, you may want to review this documentation on MySQL's site:

For MySQL 5: [13.2.3. InnoDB Configuration][1]

For MySQL 4/3.23: [13.2.4. InnoDB Configuration][2]

 [1]: http://dev.mysql.com/doc/refman/5.0/en/innodb-configuration.html
 [2]: http://dev.mysql.com/doc/refman/4.1/en/innodb-configuration.html
