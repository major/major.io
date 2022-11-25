---
title: 'Can’t find file: ‘horde_sessionhandler.MYI’'
author: Major Hayden
date: 2007-04-19T16:38:49+00:00
url: /2007/04/19/cant-find-file-horde_sessionhandlermyi/
dsq_thread_id:
  - 3679053656
tags:
  - database
  - plesk

---
If you get this error, you've most likely done a file-based MySQL backup restore, and the InnoDB files are hosed. The horde_sessionhandler table isn't a MyISAM table at all - it's actually an InnoDB table. The easiest way to fix the issue is to stop MySQL and trash the .frm:

```
# /etc/init.d/mysqld stop
# rm /var/lib/mysql/horde/horde_sessionhandler.frm
```

Now start MySQL and re-create the table:

```
# /etc/init.d/mysqld start
# mysql -u admin -p`cat /etc/psa/.psa.shadow`
```

Here's the SQL statements to run:

```sql
CREATE TABLE horde_sessionhandler (session_id VARCHAR(32) NOT NULL, session_lastmodified INT NOT NULL, session_data LONGBLOB, PRIMARY KEY (session_id)) ENGINE = InnoDB;
GRANT SELECT, INSERT, UPDATE, DELETE ON horde_sessionhandler TO horde@localhost;
```

You're good to go!
