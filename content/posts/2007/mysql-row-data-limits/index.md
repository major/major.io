---
aliases:
- /2007/01/04/mysql-row-data-limits/
author: Major Hayden
date: 2007-01-05 01:24:17
tags:
- database
title: MySQL Row & Data Limits
---

As most folks know, by default, MySQL limits the size of a MyISAM table at 4GB. Where does this limit come from? It's the maximum of a 32-bit address:

> 2<sup>32</sup> = 4,294,967,296 bytes = 4GB

How is this 4GB allocated? Well here's the math:

> row count X row length = 4GB max

Basically, if your rows don't contain much information, you can cram a lot of rows into a table. On the flip side, if you don't plan on having too many rows, you can cram a lot of information in each row.

Here's where things get ugly. If you have a MyISAM table and you exceed the maximum data length for the table, it may or may not tell you that you've exceeded the limit (depending on the version). If it doesn't tell you, your data will actually become corrupt.

So, how can you find out what a table's limit is? Run `show table status like 'tablename'` and check the value for `Max_data_length`. The default, of course, is `4294967295`.

How can the `Max_data_length` be increased? Just run something like `alter table tablename max_rows = 200000000000 avg_row_length = 50`. This example would increase your `Max_data_length` to 1,099,511,627,775.