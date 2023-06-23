---
aliases:
- /2008/03/21/importing-mysql-dumps-made-on-64-bit-servers/
author: Major Hayden
date: 2008-03-21 17:51:56
dsq_thread_id:
- 3642772606
tags:
- database
- mysql
title: Importing MySQL dumps made on 64-bit servers
---

It's tough to find examples of dumps that can't be properly reimported on other servers. However, if you have a 64-bit server, and you make a MySQL dump file from it, you may see this issue when importing the dump on a 32-bit MySQL server:

```
ERROR 1118 (42000) at line 1686: Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. You have to change some columns to TEXT or BLOBs
```

You really don't have any options in this situation. You'll need to adjust your table on the 64-bit server for good and then make a new dump file, or you will just have to live with the fact that it can't be imported into a 32-bit instance of MySQL.