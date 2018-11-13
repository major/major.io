---
title: Plesk and MySQL 5
author: Major Hayden
type: post
date: 2008-01-30T18:29:18+00:00
url: /2008/01/30/plesk-and-mysql-5/
dsq_thread_id:
  - 3678998777
tags:
  - database
  - mysql
  - plesk

---
One of the questions I receive the most is: "What version of Plesk works with MySQL 5?" The minimum version of Plesk for MySQL 5 is **8.1.0**. If you install MySQL 5 on a version prior to 8.1.0, you may be able to access then panel in the other 8.x versions, but your upgrades will fail miserably.

In case you're curious about a slightly older system, full MySQL 4 support was available in Plesk **7.5.3**. However, MySQL 4 is supported on some distributions as far back as **7.1**:

Fedora Core 2

Mandrake 10

SuSE 9.0

FreeBSD 5.2.1

Check out SWSoft/Parallel's site for more information about MySQL [4][1] and [5][2] support.

 [1]: http://kb.swsoft.com/en/305
 [2]: http://kb.swsoft.com/en/1792
