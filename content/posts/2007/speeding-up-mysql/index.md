---
aliases:
- /2007/05/20/speeding-up-mysql/
author: Major Hayden
date: 2007-05-21 03:44:33
tags:
- database
- development
title: Speeding up MySQL
---

If there's one question I get a lot, it would be "Hey, how can I speed up MySQL?" There's absolutely no end-all, be-all answer to this question. Instead a combination of many factors contribute to the overall performance of any SQL server. However, here's a list of my recommendations for great MySQL performance. They're arranged from the biggest gains to smallest gains:

**Query Optimization**

I know - you were hoping I'd talk about hardware to start this thing off, but optimizing queries is the #1 way to get a MySQL server in gear. MySQL gives you great tools, like the slow query log, multiple status variables, and the EXPLAIN statement. Put these three things together and your queries will be on their way to a more optimized state. I'll go into great detail about query optimization in a later post.

**Memory / System Architecture**

We all know MySQL likes RAM, and the more you give it (to a point) the better the performance will be. If you consider the alternative to memory, which is swapping on disk, it's obvious to see the gains.

So why did I add system architecture to this section? Well, if you have 32-bit Redhat, you can only allocate 2GB per process with the standard kernel. If you jump up to the SMP or hugemem kernel (in ES 2.1, you need the hugemem kernel for this to work), you can allocate 3GB per process. There is a caveat - MySQL can only use 2GB per buffer in 32-bit land. In a 64-bit OS with an appropriate Redhat kernel, you can allocate much larger buffers, and this can be tremendously helpful to tables which use the InnoDB engine. The memory allocation abilities are a great benefit, but also keep in mind that you will also get a boost in math performance within MySQL due to the 64-bit architecture. It's a win-win!

**Disk Performance**

Running a critical database on IDE or SATA drives just doesn't cut it any more. A SCSI or SAS drive is required for the best performance. Although you hope that MySQL doesn't touch the disk much, it's important to remember that you need to make backups often, and you may need to restore data. Also, if your site is write-intensive, the disk performance is much more important than you think. It will reduce the time that tables are locked, and it will also reduce the time for backups and restores.

**CPU**

Although CPU comes last, don't forget how important it can be. If you run a high number of complex queries and perform a lot of mathematical operations, you're going to need a CPU that can handle this load. Dual CPU's or dual core CPU's will help out even more, since MySQL can use multiple CPU cores to perform simultaneous operations. Keep in mind that 64-bit will outperform 32-bit in MySQL, and also allow for greater memory allocations (look in the Memory section above).

**_Final Note:_**

Keep in mind that these are **general** suggestions, and these suggestions may not apply to all users. For example, on sites that are heavily read-intensive, you may find that CPU speed is more important than disk speed. Also, if you're not using all of the available memory on your server, but your performance is still sagging, adding more memory won't help. Consult with a DBA and find out where your server's slowdowns are, then make a change with your queries or with your hardware. Remember, throwing more hardware at the problem will not always solve it.