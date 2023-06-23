---
aliases:
- /2012/03/15/compare-commits-between-two-git-branches/
author: Major Hayden
date: 2012-03-15 15:00:24
dsq_thread_id:
- 3642806905
tags:
- bash
- command line
- development
- git
- github
- shell
title: Compare commits between two git branches
---

I found myself stuck in a particularly nasty situation a few weeks ago where I had two git branches with some commits that were mixed up. Some commits destined for a branch called development ended up in master. To make matters worse, development was rebased on top of master and the history was obviously mangled.

My goal was to find out which commits existed in development but didn't exist anywhere in master. From there, I needed to find out which commits existed in master that didn't exist in development. That would give me all of the commits that needed to be in the development branch.

I constructed this awful looking bash mess to figure out which commits were in development but not in master:



I had a list of commits that existed in development but not in master:

```
965cf71 Trollface
acda854 Some patch 2
bf1f3e2 Some patch 1
db1980c Packaging
```


From there, I could swap `MASTER` and `DEV` to figure out which commits existed in master but not in development. Only a couple of commits showed up and these were the ones which were committed and pushed to master inadvertently. After a couple of careful cherry picks and reversions, my branches were back to normal.