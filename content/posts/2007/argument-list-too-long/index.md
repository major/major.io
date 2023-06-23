---
aliases:
- /2007/01/24/argument-list-too-long/
author: Major Hayden
date: 2007-01-24 15:35:24
dsq_thread_id:
- 3642764789
tags:
- command line
title: Argument list too long
---

If you have a ton of files in a directory and you need to remove them, but rm says that the "argument list [is] too long", just use find and xargs:

```
find . -name 'filename*' | xargs rm -vf
```