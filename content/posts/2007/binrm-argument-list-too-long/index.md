---
aliases:
- /2007/03/26/binrm-argument-list-too-long/
author: Major Hayden
date: 2007-03-26 17:16:55
dsq_thread_id:
- 3642766058
tags:
- command line
title: '/bin/rm: Argument list too long'
---

If you have too many files to remove, try this trick:

```
find . -name '*' | xargs rm -v
```