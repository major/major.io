---
aliases:
- /2008/06/18/remove-backticks-from-mysql-dumps/
author: Major Hayden
date: 2008-06-18 17:00:01
dsq_thread_id:
- 3645469818
tags:
- mysql
- sed
title: Remove backticks from MySQL dumps
---

I found myself in a peculiar situation last week. I'd been asked to downgrade a server from MySQL 4.1 to MySQL 3.23. Believe me, I tried to advise against the request, but I didn't succeed.

I made a MySQL 3.23 compatible dump with `--compatible=mysql323`, but the dump came out with backticks around the database names. This works with some 3.23 versions, but it doesn't work with others. Apparently RHEL 3's MySQL 3.23 is one of those versions where it simply won't work.

This sed line came in handy to strip the backticks from the `USE` lines in the dump:

```
sed -e "s/^USE \`\(.*\)\`/USE \1/g"
```