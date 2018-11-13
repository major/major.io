---
title: 'mysqldump: Got packet bigger than ‘max_allowed_packet’ bytes'
author: Major Hayden
type: post
date: 2007-10-12T01:28:17+00:00
url: /2007/10/11/mysqldump-got-packet-bigger-than-max_allowed_packet-bytes/
dsq_thread_id:
  - 3642770347
tags:
  - database
  - mysql

---
When you dump table data from MySQL, you may end up pulling a large chunk of data and it may exceed the MySQL client's max\_allowed\_packet variable. If that happens, you might catch an error like this:

``mysqldump: Error 2020: Got packet bigger than 'max_allowed_packet' bytes when dumping table `tablename` at row: 1627``

The default max\_allowed\_packet size is 25M, and you can adjust it for good within your my.cnf by setting the variable in a section for mysqldump:

`[mysqldump]<br />
max_allowed_packet = 500M`
