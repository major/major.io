---
aliases:
- /2007/07/01/repair-auto_increment-in-mysql/
author: Major Hayden
date: 2007-07-01 16:34:03
tags:
- database
- emergency
title: Repair auto_increment in MySQL
---

Table corruption in MySQL can often wreak havoc on the auto_increment fields. I'm still unsure why it happens, but if you find a table tries to count from 0 after a table corruption, just find the highest key in the column and add 1 to it (in this example, I'll say the highest key is 9500).

Just run this one SQL statement on the table:

`ALTER TABLE brokentablename AUTO_INCREMENT=9501;`

If you run a quick insert and then run `SELECT last_insert_id()`, the correct key number should be returned (9501 in this case).