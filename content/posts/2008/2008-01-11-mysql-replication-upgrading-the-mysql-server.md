---
title: 'MySQL Replication: Upgrading the MySQL server'
author: Major Hayden
date: 2008-01-11T23:44:54+00:00
url: /2008/01/11/mysql-replication-upgrading-the-mysql-server/
dsq_thread_id:
  - 3679003389
tags:
  - database
  - mysql

---
If you want to make a DBA nervous, just let them know that they need to upgrade MySQL servers that are replicating in a production environment. There's multiple ways to get the job done, but here is the safest route:

**First,** make sure you have dumped all of your databases properly. Verify that your backups are correct and intact, and that you have multiple copies of them.

**Next,** upgrade the slave servers individually to the newest version. After upgrading the first one, make sure the slave server is operating properly. If it is working properly, then you can continue to upgrade the other slaves.

**Once all of the slaves have been upgraded,** then you can upgrade the master. If a busy web application is sending write queries to the master, you may want to put up a temporary page that tells visitors that maintenance is being performed. Once all of the writes clear out, stop the master and upgrade it.

After the master starts up, be sure that the slaves reconnect, and you might want to perform a test write query. Verify that the write is performed on the slaves as it was done on the master.
