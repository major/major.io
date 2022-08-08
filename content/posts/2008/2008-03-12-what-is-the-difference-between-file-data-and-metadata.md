---
title: What is the difference between file data and metadata?
author: Major Hayden
date: 2008-03-12T18:01:59+00:00
url: /2008/03/12/what-is-the-difference-between-file-data-and-metadata/
dsq_thread_id:
  - 3654725665
tags:
  - command line
  - filesystem

---
Just in case some of you out there enjoy nomenclature and theory behind Linux filesystems, here's some things to keep in mind. The modification time (mtime) of a file describes when the actual data blocks that hold the file changed. The changed time (ctime) of a file describes when the metadata was last changed.

Also, metadata is stored within a different location than the data blocks. The metadata fits in the inode while the file's data goes within data blocks. The inode information contains the owner, owner's group, time related data (atime, ctime, mtime), and the mode (permissions).

The name of the file itself is actually stored within the file that makes up the directory. And, the directory is simply a file that masquerades as a directory once the filesystem is mounted and read.
