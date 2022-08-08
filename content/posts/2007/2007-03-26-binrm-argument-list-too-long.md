---
title: '/bin/rm: Argument list too long'
author: Major Hayden
date: 2007-03-26T17:16:55+00:00
url: /2007/03/26/binrm-argument-list-too-long/
dsq_thread_id:
  - 3642766058
tags:
  - command line

---
If you have too many files to remove, try this trick:

```
find . -name '*' | xargs rm -v
```
