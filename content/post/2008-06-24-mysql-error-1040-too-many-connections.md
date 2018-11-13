---
title: 'MySQL: ERROR 1040: Too many connections'
author: Major Hayden
type: post
date: 2008-06-24T17:00:47+00:00
url: /2008/06/24/mysql-error-1040-too-many-connections/
dsq_thread_id:
  - 3642771606
categories:
  - Blog Posts
tags:
  - mysql

---
If you run a fairly busy and/or badly configured MySQL server, you may receive something like this when attempting to connect:

```
# mysql
ERROR 1040: Too many connections</pre>

MySQL is telling you that it is handling the maximum connections that you have configured it to handle. By default, MySQL will handle 100 connections simultaneously. This is very similar to the situation when Apache reaches the MaxClients setting. You won't even be able to connect to MySQL to find out what is causing the connections to be used up, so you will be forced to restart the MySQL daemon to troubleshoot the issue.

What causes MySQL to run out of connections? Here's a list of reasons that may cause MySQL to run out of available connections, listed in order of what you should check:

**Bad MySQL configuration**

Verify that you have set MySQL's buffers and caches to appropriate levels for the type of data you're storing and the types of queries that you are running. One quick way to check this information is via [MySQLTuner][1]. The script will tell you how well your server is performing along with the corrections you should make. Running the script only takes a few moments and it doesn't require a DBA to decipher the results.

**Data storage techniques**

Remember that MySQL works best when moving vertically, not horizontally. If you have a table with 20 columns, breaking it into two tables with 10 columns each will improve performance. Even if you need to join the two tables together to get your data, it will still perform at a higher level. Also, use the right data types for the right data. If you're storing an integer only, don't use a CHAR or VARCHAR data type. If your integer will be small, then use something like a TINYINT or SMALLINT rather than INT. This means MySQL will use less memory, pull less data from the disk, and have higher performing joins.

**Slow queries**

These are generally pretty easy to fix. If you have queries that don't use indexes, or if queries run slowly with indexes in place, you need to rethink how you're pulling your data. Should your data be split into multiple tables? Are you pulling more data than you need? Keep these questions in mind, enable the slow query log, and re-work your queries to find where the bottlenecks occur.

**Division of labor**

Most people who use MySQL have a dynamic site written in a scripting language, like PHP, Perl or Python. It's obvious that your server will need to do some work to parse the scripts, send data back to the client, and communicate with MySQL. If you find that your server is overworked, consider moving MySQL to its own dedicated hardware. Among many other things, this will reduce your disk I/O, allow you to better utilize memory, and it will help you when you need to scale even further. Be sure to keep your MySQL server close to your web servers, however, as increased latency will only make your performance problem first.

**Right hardware**

Do you have the right hardware for the job? Depending on your budget, you may need to make the move for hardware that gives you better I/O throughput and more useable cores. MySQL is a multi-threaded application, so it can utilize multiple cores to serve data quickly. Also, writing logs, reading tables, and adjusting indexes are disk-intensive tasks that need fast drives to perform well. When you look for a dedicated server for MySQL, be sure to choose multiple-core machines with low latency RAM, fast drives (SCSI/SAS), and a reliable network interface.

By reviewing these bottlenecks, you can reduce the load on your MySQL server without increasing your maximum connections. Simply increasing the maximum connections **is a very bad idea**. This can cause MySQL to consume unnecessary resources on your server and it may lead to an unstable system (crash!).

 [1]: http://rackerhacker.com/mysqltuner/
