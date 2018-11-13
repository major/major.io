---
title: Argument list too long
author: Major Hayden
type: post
date: 2007-01-24T15:35:24+00:00
url: /2007/01/24/argument-list-too-long/
dsq_thread_id:
  - 3642764789
tags:
  - command line

---
If you have a ton of files in a directory and you need to remove them, but rm says that the "argument list [is] too long", just use find and xargs:

find . -name 'filename*' | xargs rm -vf
