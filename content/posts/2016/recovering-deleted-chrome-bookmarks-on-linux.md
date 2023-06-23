---
aliases:
- /2016/02/26/recovering-deleted-chrome-bookmarks-on-linux/
author: Major Hayden
date: 2016-02-26 15:31:15
dsq_thread_id:
- 4613596137
tags:
- chrome
- fedora
- linux
title: Recovering deleted Chrome bookmarks on Linux
---

After getting a bit overzealous with cleaning up bookmarks in Chrome, I discovered that I deleted a helpful Gerrit filter for OpenStack reviews. I worked hard to create the filter and I definitely needed it back.

Chrome keeps a file called `Bookmarks.bak` inside its configuration directory. You can find this file here:

```
/home/[username]/.config/google-chrome/Default/Bookmarks.bak        # If using Chrome stable
/home/[username]/.config/google-chrome-beta/Default/Bookmarks.bak   # If using Chrome beta
```


The file is stored in JSON format. Open it up in your favorite text editor and search for your deleted bookmark.