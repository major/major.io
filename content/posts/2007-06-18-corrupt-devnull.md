---
title: Corrupt /dev/null
author: Major Hayden
type: post
date: 2007-06-19T02:49:56+00:00
url: /2007/06/18/corrupt-devnull/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642768042
categories:
  - Blog Posts
tags:
  - command line
  - emergency

---
If you find that /dev/null is no longer a block device, and it causes issues during init on Red Hat boxes, you will need to follow these steps to return things to normal:

* Reboot the server
* When grub appears, edit your kernel line to include `init=/bin/bash` at the end
* Allow the server to boot into the emergency shell
* Run the following three commands

```
# rm -rf /dev/null
# mknod /dev/null c 1 3
# chmod 666 /dev/null
```

You should be back to normal. Make sure that the root users on your server don't use **cp** or **mv** with /dev/null as this will cause some pretty ugly issues.
