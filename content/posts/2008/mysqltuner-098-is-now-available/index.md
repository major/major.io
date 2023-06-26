---
aliases:
- /2008/07/21/mysqltuner-098-is-now-available/
author: Major Hayden
date: 2008-07-21 17:17:14
tags:
- database
- mysql
- mysqltuner
title: MySQLTuner 0.9.8 is now available
---

MySQLTuner 0.9.8 is now available for [download][1] and it is full of new changes! So far, MySQLTuner has been downloaded almost 24,000 times. Thanks for making it so popular.

**Easy download!**

You can download it simply by running `wget mysqltuner.pl`. You will automatically be redirected to the script.

**Access servers remotely**

If you have multiple servers that you need to tune and monitor, simply download MySQLTuner onto one machine. You can run it against other servers by specifying a hostname, port, and login credentials. Two new options are available: `--host` and `--port`.

**Pass login credentials on the command line**

Two new options are available: `--user` and `--pass`. You can pass a username and password on the command line to log in quickly. This can be especially helpful in conjunction with cron.

**Manually set the amount of RAM and swap memory installed**

I've received a few bug reports where users on certain virtual environments saw incorrect memory calculations when they ran MySQLTuner. You can now set the current amount of RAM and swap memory installed with `--forcemem` and `--forceswap` respectively. (Thanks to Jason Gill for the patch and the bug report!)

**Checking for updates is now optional**

Some operating system distributions and environments can't allow for automatic update checking due to security concerns, so I've made update checks optional. The `--skipversion` option has been removed and it was replaced with `--checkversion`. _As a side note, the only data that I collected was the version number being run and the IP from which the update originated. This data has only been used for aggregate statistical purposes._

As you might imagine, MySQLTuner 1.0 is just around the corner. I've been holding out for the MySQL 5.1 GA release, but I may release the script sooner. Don't worry - as soon as MySQL 5.1 becomes a GA release, I'll be hard at work to support any new optimization options which it provides.

 [1]: http://rackerhacker.com/mysqltuner/