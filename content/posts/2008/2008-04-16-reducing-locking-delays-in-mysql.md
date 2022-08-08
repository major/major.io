---
title: Reducing locking delays in MySQL
author: Major Hayden
date: 2008-04-16T17:32:50+00:00
url: /2008/04/16/reducing-locking-delays-in-mysql/
dsq_thread_id:
  - 3642772478
tags:
  - database

---
Before getting started, it's important to understand why [MySQL][1] uses [locks][2]. In short - MySQL uses locks to prevent multiple clients from corrupting data due to simultaneous writes while also protecting clients from reading partially-written data.

Some of you may be thinking, "Okay, this makes sense." If that's you, skip the next two paragraphs. If not, keep reading.

Analogies can help understand topics like these. Here's one that I came up with during a training class. Consider two people sitting in front of a notepad on a table. Let's say that a sentence like "The quick brown fox jumps over the lazy dog" is already written on the notepad. If both people want to read the sentence simultaneously, they can do so without getting in each other's way. A third or fourth person could show up and they could all read it at the same time.

Well, let's say one of the people at the table is writing a screenplay for [Cujo][3], and they want to change "lazy" to "crazy". That person erases the "l" in "lazy" and then adds a "cr" to the front to spell "crazy". So if the other person is reading the sentence while the first person is writing, they will see "lazy" turn into "azy", then "c_azy", and then finally, "crazy". This isn't a big issue in real life, but on the database level, this could be dangerous. If the person who was reading the sentence showed up during the middle of the letter changes, they would think that the dog was "azy", and they'd walk away wondering what the adjective "azy" means. To get around this, MySQL uses locking to block clients from reading data while it's being written and it blocks clients from writing data simultaneously.

Now that we're all familiar with what locks are, and why MySQL uses them, let's talk about some ways to reduce the delays caused by locking. Here's some situations you might be running up against:

**Writes are delayed because reads have locked the tables**

This is the most common occurrence from the servers that I have seen. When you run a `SHOW PROCESSLIST`, you may see a few reads at the top of the queue that are in the status of "Copying to tmp table" and/or "Sending data". On optimized servers running optimized queries, these should clear out quickly. If you're finding that they are not clearing out quickly, try the following:

  * Use `EXPLAIN` on your queries to be sure that they are optimized
  * Add indexes to tables that you query often
  * Reduce the amount of rows that are being returned per query
  * Upgrade the networking equipment between web and database servers (if applicable)
  * Consider faster hardware with larger amounts of RAM
  * Use [MySQLTuner][4] to check your current server's configuration for issues
  * Consider moving to InnoDB to utilize row-based locking

**Reads and writes are delayed because writes have locked the tables**

Situations like these are a little different. There's two main factors to consider here: either MySQL cannot write data to the disk fast enough, or your write queries (or tables) are not optimized. If you suspect a hardware issue, check your iowait with `sar` and see if it stays at about 10-20% or higher during the day. If it does, slow hardware may be the culprit. Try moving to SCSI disks and be sure to use RAID 5 or 10 for additional reliability and speed. SAN or DAS units may also help due to higher throughput and more disk spindles.

If you already have state-of-the-art hardware, be sure that your tables and queries are optimized. Run `OPTIMIZE TABLES` regularly if your data changes often to defragment the tables and clear out any holes from removed or updated data. Slow `UPDATE` queries suggest that you are updating too many rows, or you may be using a column in the WHERE clause that is not indexed. If you do a large amount of `INSERT` queries, use this syntax to enter multiple rows simultaneously:

```sql
INSERT INTO table (col1,col2) VALUES ('a','1'), ('b','2'), ('c','3');
```

This syntax tells MySQL to hold off on updating indexes until the entire query is complete. If you are updating a **very large** amount of rows, and you need to use multiple queries to avoid reaching the [max\_allowed\_packet][5] directive, you can do something like this:

```sql
ALTER TABLE table DISABLE KEYS;
INSERT INTO table (col1,col2) VALUES ('a','1'), ('b','2'), ('c','3');
~~~ many more inserts ~~~
ALTER TABLE table ENABLE KEYS;
```

This forces MySQL to not calculate any new index information until you re-enable the keys or run `OPTIMIZE TABLE`. If all of this does not help, consider using InnoDB as your storage engine. You can benefit from the row-level locking, which reduces locking in mixed read/write scenarios. In addition, InnoDB is able to write data much more efficiently than MyISAM.

 [1]: http://dev.mysql.com/
 [2]: http://dev.mysql.com/doc/refman/5.0/en/locking-issues.html
 [3]: http://www.imdb.com/title/tt0085382/
 [4]: http://rackerhacker.com/mysqltuner/
 [5]: http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#option_mysqld_max_allowed_packet
