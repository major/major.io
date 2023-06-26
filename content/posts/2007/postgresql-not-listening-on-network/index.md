---
aliases:
- /2007/05/21/postgresql-not-listening-on-network/
author: Major Hayden
date: 2007-05-21 15:04:12
tags:
- database
title: Postgresql not listening on network
---

On some operating systems, postgresql is not configured to listen on the network. To enable the TCP/IP connections, edit the /var/lib/pgsql/data/postgresql.conf and change the following:

```
tcpip_socket = true
port = 5432
```

Restart postgresql and you should be all set:

```
/etc/init.d/postgresql restart
```