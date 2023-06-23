---
aliases:
- /2007/07/05/bintar-argument-list-too-long/
author: Major Hayden
date: 2007-07-06 03:11:43
dsq_thread_id:
- 3642768598
tags:
- command line
title: '/bin/tar: Argument list too long'
---

If you find yourself stuck with over 30,000 files in a directory (text files in this example), packing them into a tar file can be tricky. You can get around it with this:

```
find . -name '*.txt' -print >/tmp/test.manifest
tar -cvzf textfiles.tar.gz --files-from /tmp/test.manifest
find . -name '*.txt' | xargs rm -v
```