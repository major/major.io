---
aliases:
- /2007/05/20/mysql-connections-in-sleep-state/
author: Major Hayden
date: 2007-05-21 03:26:11
tags:
- database
- development
- web
title: MySQL connections in sleep state
---

On some servers, you may notice that MySQL is consuming CPU and memory resources when it's not processing any queries. During these times, running a `mysqladmin processlist` will show many processes in the 'sleep' state for many minutes.

These issues occur because of code that uses a persistent connection to the database. In PHP, this is done with mysql_pconnect. This causes PHP to connect to the database, execute queries, remove the authentication for the connection, and then leave the connection open. Any per-thread buffers will be kept in memory until the thread dies (which is 28,800 seconds in MySQL by default). There's three ways to handle this type of issue:

**Fix the code**

This is the #1 most effective way to correct the problem. Persistent connections are **rarely** needed. The only time when they would be even mildly useful is if your MySQL server has a huge latency. For example, if your web server takes > 250ms to make contact with your MySQL server, this setting might save you fractions of a second. Then again, if your web server and MySQL server are so far apart to where latency is even a consideration, you have more problems than I can help you with.

**Restrict the connections**

If push comes to shove, and you have users on a server who are abusing their MySQL privileges with mysql_pconnect, then you can pull the plug on their shenanigans with GRANT. You can reduce the maximum simultaneous connections for their database user, and they'll find themselves wanting to make code changes pretty quickly. MySQL doesn't queue extra connections for users who have passed their maximum, so they get a really nice error stating that they have exceeded their max connections. To set up this grant, just do something like the following:

`GRANT ALL PRIVILEGES ON database.* TO 'someuser'@'localhost' WITH MAX_USER_CONNECTIONS = 20;`

**Reduce the timeouts**

If changing the code isn't an option, and you don't feel mean enough to restrict your users (however, if they were causing a denial of service on my MySQL server, I'd have no problem restricting them), you can reduce the _wait_timeout_ and _interactive_timeout_ variables. The wait\_timeout affects non-interactive connections (like TCP/IP and Unix socket) and interactive\_timeout affects interactive connections (if you don't know what these are, you're not alone). The defaults of these are fairly high (usually 480 minutes) and you can drop them to something more reasonable, like 30-60 seconds. Web visitors shouldn't notice the difference - it will just cause the next page load to start a new connection to the database server.