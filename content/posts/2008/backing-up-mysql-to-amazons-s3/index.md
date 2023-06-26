---
aliases:
- /2008/06/05/backing-up-mysql-to-amazons-s3/
author: Major Hayden
date: 2008-06-06 00:18:49
tags:
- mysql
- perl
title: Backing up MySQL to Amazon’s S3
---

I received an e-mail from [Tim Linden][1] about a [post he made in his blog][2] about backing up MySQL data to [Amazon's S3][3].

The article goes over installing the Net::Amazon::S3 Perl module via WHM (which is handy for the cPanel users). However, if you're not a cPanel user, you can install it via CPAN:

```
# perl -MCPAN -e 'install Net::Amazon::S3'
```

If you'd rather install it through Webmin, go to the 'Others' section, and click 'Perl Modules'.

Also, Tim mentions configuring a [Firefox extension for accessing S3][4] that works very well. However, I find myself using Safari most often, so I prefer to use [Jungle Disk][5] or [Transmit][6] on my Mac.

Overall, it's a great post, and I'm glad Tim told me about it!

 [1]: http://www.timlinden.com/
 [2]: http://www.timlinden.com/blog/server/backup-mysql-amazon-s3/
 [3]: http://en.wikipedia.org/wiki/Amazon_S3
 [4]: http://www.rjonna.com/ext/s3fox.php
 [5]: http://www.jungledisk.com/
 [6]: http://www.panic.com/transmit/