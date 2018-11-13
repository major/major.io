---
title: 'rpmdb: Lock table is out of available locker entries'
author: Major Hayden
type: post
date: 2007-05-27T16:38:32+00:00
url: /2007/05/27/rpmdb-lock-table-is-out-of-available-locker-entries/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642767513
categories:
  - Blog Posts
tags:
  - bdb
  - command line
  - emergency
  - fedora
  - python
  - red hat
  - rpm
  - up2date
  - yum

---
If up2date throws some horrible Python errors and rpm says "rpmdb: Lock table is out of available locker entries", you can restore your system to normality with the following:

The errors:

```
rpmdb: Lock table is out of available locker entries
error: db4 error(22) from db->close: Invalid argument
error: cannot open Packages index using db3 - Cannot allocate memory (12)
error: cannot open Packages database in /var/lib/rpm</pre>

Make a backup of /var/lib/rpm in case you break something:

```


Remove the Berkeley databases that rpm uses:

```


Make rpm rebuild the databases from scratch (may take a short while):

```


Now, check rpm to make sure everything is okay:

```


**Why does this happen?**

When rpm accesses the Berkeley database files, it makes temporary locker entries within the tables while it searches for data. If you control-c your rpm processes often, this issue will occur much sooner because the locks are never cleared.
