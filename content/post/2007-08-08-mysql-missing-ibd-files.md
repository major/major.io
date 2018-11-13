---
title: 'MySQL: Missing *.ibd files'
author: Major Hayden
type: post
date: 2007-08-09T00:22:40+00:00
url: /2007/08/08/mysql-missing-ibd-files/
dsq_thread_id:
  - 3644065371
tags:
  - database

---
Using the InnoDB engine can be tricky due to the ibdata files' rather untraditional behavior. Instead of storing data in MYI and MYD files for each table, InnoDB stores everything in one (or several) large files starting with ibdata1. Of course, MySQL nerds know that you can adjust this behavior slightly with innodb\_file\_per_table, but you can [read up][1] on this at [your leisure][2].

If you've restored the ibdata files from a previous backup, or if you just toss the .frm files into a database directory, you might find this when you start MySQL:

`ERROR 1016 (HY000): Can't open file: 'files.ibd' (errno: 1)`

Any good MySQL DBA will find out what error #1 means:

`# perror 1<br />
OS error code   1:  Operation not permitted`

This error sure sounds like a permission error. Go ahead and check your permissions in /var/lib/mysql, but you'll probably find that they're properly set.

**So, why is the operation not permitted?**

MySQL is actually hiding the actual problem behind an incorrect error. The actual issue is that the tables described in your .frm files are not present in the InnoDB tablespace (the ibdata files). This may occur if you restore the .frm files, but you don't restore the correct ibdata files.

**What's the solution?**

The easiest fix is to obtain a mysqldump backup of your original data. When you import it, MySQL will create your .frm files and populate the ibdata files for you without any fuss. You'll be up and running in no time.

If you don't have mysqldump backups, then you've just realized how important it is to have a flatfile backup of your databases. :-) If you can restore your original ibdata file that you backed up with your .frm's, you should be able to stop MySQL, put the old ibdata file and transaction logs back, and start MySQL. However, if multiple databases have InnoDB tables, you're going to be reverting them to their previous state. This could cause BIG problems if you're not careful. You will want to begin running this on a regular basis:

`mysqldump -Q --opt -A --single-transaction -u username -p > mysqldump.sql`

> As a sidenote, this error utterly stumped this DBA. I've never run into this issue before, and I assumed that the server was supposed to have tablespaces per table, but I couldn't find any mention in the /etc/my.cnf file. I found the [solution on MySQL's site][3] after some intense Google action.

 [1]: http://dev.mysql.com/doc/refman/5.0/en/multiple-tablespaces.html
 [2]: http://bignerdranch.com/
 [3]: http://forums.mysql.com/read.php?22,68927,69008#msg-69008
