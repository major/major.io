---
title: Counting open files per user
author: Major Hayden
date: 2007-09-26T17:13:44+00:00
url: /2007/09/26/counting-open-files-per-user/
dsq_thread_id:
  - 3642770159
tags:
  - command line

---
In the event that your system is running out of file descriptors, or you simply want to know what your users are doing, you can review their count of open files by running this command:

`lsof | grep ' root ' | awk '{print $NF}' | sort | wc -l`

Of course, if you want to drop the count and show the actual processes, you can run:

`lsof | grep ' root '`