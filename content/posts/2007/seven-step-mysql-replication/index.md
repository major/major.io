---
aliases:
- /2007/12/31/seven-step-mysql-replication/
author: Major Hayden
date: 2007-12-31 17:51:03
dsq_thread_id:
- 3642773309
tags:
- database
- mysql
title: Seven Step MySQL Replication
---

MySQL replication may sound complicated, but it can be done easily. Here's a quick 7-step guide:

1) Create a replication user on the master:

```
 GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY 'password';
```


2) On the master server, add the following to the `[mysqld]` section in my.cnf and restart MySQL:

```
server-id = 1
relay_log=mysqldrelay
log-bin
expire_logs_days = 7
```


3) On the slave server, add the following to the `[mysqld]` sesion in my.cnf and restart MySQL:

```
server-id = 2
```


4) Create a mysqldump file on the master server which includes a global lock:

```
 databases.sql
```


5) Configure the slave:

```
# mysql -u user -ppassword
mysql> CHANGE MASTER TO MASTER_HOST='master host name', MASTER_USER='repl', MASTER_PASSWORD='repl';
```


6) Move the dump to the slave server and import it:

```
mysql -u user -ppassword < databases.sql
```


7) Start the slave:

```
mysql -u user -ppassword
mysql> START SLAVE;
```