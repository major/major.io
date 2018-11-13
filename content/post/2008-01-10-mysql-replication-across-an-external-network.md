---
title: 'MySQL Replication: Across an external network'
author: Major Hayden
type: post
date: 2008-01-10T18:51:39+00:00
url: /2008/01/10/mysql-replication-across-an-external-network/
dsq_thread_id:
  - 3654636923
tags:
  - database
  - mysql

---
While many people might find replicating over an external network to be an odd concept, it does have some uses. For example, if you need to replicate data for local access at certain locations, it may be helpful. Also, if you have a dedicated server, you can replicate to your home to run backups.

First off, you're going to need security for the connection. This is easily done with SSL. On the master, simply add the following lines to the `[mysqld]` section and restart the master:

`ssl-ca=cacert.pem<br />
ssl-cert=server-cert.pem<br />
ssl-key=server-key.pem`

To have the slaves use SSL connections to the master server, simply add on `MASTER_SSL=1` to the `CHANGE MASTER` statement on the slave.

Another aspect to consider is bandwidth usage. This may be a priority if your remote areas have slow downlinks, or if you are charged for your bandwidth usage. You can compress the MySQL traffic very easily. Simply add the following to the MySQL configuration file in the `[mysqld]` section:

`slave_compressed_protocol = 1`

**With both of these changes,** keep in mind that there is a significant CPU overhead required to compress and/or encrypt data. Determine carefully what your application requires and test your configuration thoroughly.
