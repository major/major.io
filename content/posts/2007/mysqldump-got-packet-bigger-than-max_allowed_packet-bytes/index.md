---
aliases:
- /2007/10/11/mysqldump-got-packet-bigger-than-max_allowed_packet-bytes/
author: Major Hayden
date: 2007-10-12 01:28:17
tags:
- database
- mysql
title: 'mysqldump: Got packet bigger than ‘max_allowed_packet’ bytes'
---

When you dump table data from MySQL, you may end up pulling a large chunk of data and it may exceed the MySQL client's max\_allowed\_packet variable. If that happens, you might catch an error like this:

```
mysqldump: Error 2020: Got packet bigger than 'max_allowed_packet' bytes when dumping table `tablename` at row: 1627
```

The default max\_allowed\_packet size is 25M, and you can adjust it for good within your my.cnf by setting the variable in a section for mysqldump:

```ini
[mysqldump]
max_allowed_packet = 500M
```