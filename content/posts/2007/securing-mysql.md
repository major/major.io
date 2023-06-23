---
aliases:
- /2007/01/04/securing-mysql/
author: Major Hayden
date: 2007-01-05 01:46:19
dsq_thread_id:
- 3679079088
tags:
- database
- security
title: Securing MySQL
---

If you work on enough servers, you discover that a lot of people put the security of their MySQL server on the back burner. With the importance of databases for dynamic sites, MySQL's security is arguably more important than anything else on the server. If someone were able to shut off the server, or worse, steal sensitive data, the entire server - and possibly the owner - could be in jeopardy.

Here are some basic tips to secure a MySQL server on any distribution:

**Create a strong root password**

By default on almost all distributions, MySQL comes with an empty root password. Sometimes the root logins are restricted to the localhost only, which will help somewhat, but anyone with shell access or a knack for writing PHP scripts can do anything to the MySQL server. However you set the root password, set it and make it strong.

**Cut off network access**

As with any daemon, the more exposure it has to the internet, the higher the chance of it being hacked and brute forced. If your users need network access to MySQL, then restrict it by at least altering the MySQL permissions to their IP only. The better solution would be to restrict it via a firewall and permissions. If you users don't need any network access to MySQL, add the following to your my.cnf:

```ini
listen = 127.0.0.1
```

Restart MySQL and it shouldn't be listening on any network addresses except the localhost. This won't affect any PHP scripts on your server.

**Force the use of named pipes**

Removing MySQL's ability to even bind to the network is a great security measure. All access to MySQL will be done through a filesystem socket, which is /var/lib/mysql/mysql.sock on most systems. This will require your PHP scripts to refer to your host as "localhost" and not "127.0.0.1".

**Review your user list often**

Every once in a while, check the list of users authorized to log into your MySQL server and be sure that when the list changes, the changes are valid. Be careful when allowing GRANT access to certain users.

**Backup often**

How often should you backup your MySQL databases? Well, ask yourself how important your data is to you. If your MySQL server is generally busy all of the time, you may want to run a slave server and do backups from that server to reduce the amount of table-locking that mysqldump requires. If your MySQL server is not terribly busy, then you can run mysqldumps pretty often on the server.