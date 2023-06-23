---
aliases:
- /2008/10/13/ext3_dx_add_entry-directory-index-full/
author: Major Hayden
date: 2008-10-13 17:00:51
dsq_thread_id:
- 3642805293
tags:
- emergency
- filesystem
- fsck
title: 'ext3_dx_add_entry: Directory index full!'
---

I found a server last week that was having severe issues with disk I/O to the point where most operations were taking many minutes to complete. The server wasn't under much load, but a quick run of `dmesg` threw quite a bit of these lines out onto the screen:

`EXT3-fs warning (device sda5): ext3_dx_add_entry: Directory index full!`

After a thorough amount of searching, I couldn't find out what the error actually meant. As with most errors starting with `EXT3-fs warning`, I figured that a fsck might be the best option.

During the fsck, several inodes were repaired and the check completed after 10-15 minutes. I jotted down some notes about the directories that popped up on the screen during the fsck. The server rebooted it came up without any problems.

I reviewed the directories that appeared during the fsck and they were full of files. Some of the directories contained upwards of 200,000 files. Many of the files were moved into lost+found after the fsck, so they had to be restored from their backups. I still don't know what caused the original issue as the hardware checked out fine. If you run into this error, a fsck should help, but make sure that you have backups handy.