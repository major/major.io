---
title: Parse kernel.org changelogs with wget and grep
author: Major Hayden
type: post
date: 2009-12-15T23:14:47+00:00
url: /2009/12/15/parse-kernel-org-changelogs-with-wget-and-grep/
dsq_thread_id:
  - 3674886086
categories:
  - Blog Posts
tags:
  - grep
  - kernel
  - one liner
  - shell
  - wget

---
I try to keep up with the latest kernel update from [kernel.org][1], but parsing through the output can be a pain if there are a lot of changes taking place. Here's a handy one-liner to make it easier to read:

```
wget --quiet -O - http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.31.8 | grep -A 4 ^commit | grep -B 1 "^--" | grep -v "^--"
```

It should give you some output like this:

```
Linux 2.6.31.8
    ext4: Fix potential fiemap deadlock (mmap_sem vs. i_data_sem)
    signal: Fix alternate signal stack check
    SCSI: scsi_lib_dma: fix bug with dma maps on nested scsi objects
    SCSI: osd_protocol.h: Add missing #include
    SCSI: megaraid_sas: fix 64 bit sense pointer truncation
    ..
```

 [1]: http://kernel.org/
