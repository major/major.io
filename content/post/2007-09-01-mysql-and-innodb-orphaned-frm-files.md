---
title: 'MySQL and InnoDB: Orphaned .frm files'
author: Major Hayden
type: post
date: 2007-09-02T01:52:00+00:00
url: /2007/09/01/mysql-and-innodb-orphaned-frm-files/
dsq_thread_id:
  - 3642769753
tags:
  - database

---
If an .frm file that corresponds to an InnoDB table gets deleted without using DROP TABLE, MySQL won't let you create a new table with the same name. You'll find this in the error log:

`InnoDB: Error: table test/parent already exists in InnoDB internal<br />
InnoDB: data dictionary. Have you deleted the .frm file<br />
InnoDB: and not used DROP TABLE? Have you used DROP DATABASE<br />
InnoDB: for InnoDB tables in MySQL version <= 3.23.43?
InnoDB: See the Restrictions section of the InnoDB manual.
InnoDB: You can drop the orphaned table inside InnoDB by
InnoDB: creating an InnoDB table with the same name in another
InnoDB: database and moving the .frm file to the current database.
InnoDB: Then MySQL thinks the table exists, and DROP TABLE will
InnoDB: succeed.`

Luckily, the error tells you exactly how to fix the problem! Simply make a new database and create a table that matches your old .frm file. Stop MySQL, move the .frm file from the new database's directory back to the old database's directory. Start MySQL, and then run DROP TABLE like normal.

This will remove the table from the ibdata tablespace file and allow you to create a new table with the same name.

Further reading:

[13.2.17.1. Troubleshooting InnoDB Data Dictionary Operations][1]

 [1]: http://dev.mysql.com/doc/refman/5.0/en/innodb-troubleshooting-datadict.html
