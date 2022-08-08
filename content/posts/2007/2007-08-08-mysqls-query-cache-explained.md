---
title: MySQL’s query cache explained
author: Major Hayden
date: 2007-08-09T01:42:58+00:00
url: /2007/08/08/mysqls-query-cache-explained/
dsq_thread_id:
  - 3642769142
tags:
  - database

---
An often misused and misunderstood aspect of MySQL is the query cache. I've seen blog post after blog post online talking about query caching as the most integral and important feature in MySQL. Many of these same posts advocate cranking the variables to the max to give you "ultimate performance." One of the worst things you can do to a MySQL server is crank your variables up and hope for the best. I'll try to clear some things up here.

The MySQL query cache is available in MySQL 4.0, 4.1, 5.0, 5.1, and 6.0 (3.23 has no query cache). The goal of the query cache is to hold result sets that are retrieved repeatedly. Since the data is held in memory, MySQL only feeds the data from memory (which is fast) into your application without digging into the tables themselves (which is slow). The result set from the query you're running and the query in the query cache must be completely identical, or MySQL will pull the data as it traditionally does from the tables.

Queries and result sets must meet certain criteria to make it into the query cache:

  * Must not be prepared statements (See 12.7. [SQL Syntax for Prepared Statements][1])
  * Subqueries are not cached, only the outer query is cached
  * Queries that are run from stored procedures, functions, or triggers are not cached (applies to versions 5.0+ only)
  * The result set must be equal to or smaller than the query\_cache\_limit (more on this below)
  * The query cannot refer to the mysql database
  * Queries cannot use user variables, user-defined functions, temporary tables or tables with column-level privileges

Besides these rules, all other queries are approved to enter the query cache. This includes wild things such as views, joins, and queries with subqueries.

The MySQL query cache is controlled by several variables:

  * **query\_alloc\_block_size** (defaults to 8192): the actual size of the memory blocks created for result sets in the query cache (don't adjust)
  * **query\_cache\_limit** (defaults to 1048576): queries with result sets larger than this won't make it into the query cache
  * **query\_cache\_min\_res\_unit** (defaults to 4096): the smallest size (in bytes) for blocks in the query cache (don't adjust)
  * **query\_cache\_size** (defaults to 0): the total size of the query cache (disables query cache if equal to 0)
  * **query\_cache\_type** (defaults to 1): 0 means don't cache, 1 means cache everything, 2 means only cache result sets on demand
  * **query\_cache\_wlock_invalidate** (defaults to FALSE): allows SELECTS to run from query cache even though the MyISAM table is locked for writing

Explaining the query\_cache\_type is a little rough. If the query\_cache\_type is 0:

  * and the query\_cache\_size is 0: no memory is allocated and the cache is disabled
  * and the query\_cache\_size is greater than 0: the memory **is** allocated but the cache is disabled

If the query\_cache\_type is 1:

  * and the query\_cache\_size is 0: no memory is allocated and the cache is disabled
  * and the query\_cache\_size is greater than 0: the cache is enabled and all queries that don't use [SQL\_NO\_CACHE][2] will be cached automatically

If the query\_cache\_type is 2:

  * and the query\_cache\_size is 0: no memory is allocated and the cache is disabled
  * and the query\_cache\_size is greater than 0: the cache is enabled and queries must use [SQL_CACHE][2] to be cached

Now that we have the variables behind us, how can we tell if we're using the query cache appropriately? Each time a query runs against the query cache, the server will increment the Qcache\_hits status variable instead of Com\_select (which is incremented when a normal SELECT runs). If the table changes for any reason, its data is rendered invalid and is dropped from the query cache.

It's vital to understand the performance implications of the query cache:

**Purging the cache**

If the query cache fills completely, it will be flushed entirely - this is a significant performance hit as many memory addresses will have to be adjusted. Check your Qcache\_lowmem\_prunes in your status variables and increase the query\_cache\_size if you find yourself pruning the query cache more than a few times per hour.

**Query cache utilization**

There's a simple formula to calculate your query cache efficiency in percentage form:

`Qcache_hits / (Com_select + Qcache_hits) x 100`

A query cache efficiency percentage of 20% or less points to a performance problem. You may want to shrink your result sets by building more restrictive queries. If that isn't possible, then you can increase your query\_cache\_limit so that more of your larger result sets actually make it into the cache. Keep in mind, however, that this will increase your prunes (see the previous paragraph) and can reduce performance. Increasing the query\_cache\_limit by small amounts and then recalculating your efficiency is a good idea.

**Fighting fragmentation**

As queries move in and out of the query cache, the memory may become fragmented. This is normally signified by an increase in slow queries, but your query cache efficiency percentage still remains high. In this situation, run `FLUSH QUERY CACHE` from the MySQL client and keep monitoring your efficiency. If this doesn't help, you may be better off flushing the cache entirely with `RESET QUERY CACHE`.

> I've tried to piece quite a bit of documentation and DBA knowledge into this article, but you may benefit from reviewing the following documentation sections on MySQL.com: [5.2.3. System Variables][3], [5.2.5 Status Variables][4], and [6.5.4. The MySQL Query Cache][5].

 [1]: http://dev.mysql.com/doc/refman/5.0/en/sqlps.html
 [2]: http://dev.mysql.com/doc/refman/5.0/en/query-cache-in-select.html
 [3]: http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html
 [4]: http://dev.mysql.com/doc/refman/5.0/en/server-status-variables.html
 [5]: http://dev.mysql.com/doc/refman/5.0/en/query-cache.html
