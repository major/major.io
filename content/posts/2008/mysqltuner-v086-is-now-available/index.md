---
aliases:
- /2008/02/26/mysqltuner-v086-is-now-available/
author: Major Hayden
date: 2008-02-27 03:24:52
tags:
- database
- mysql
- mysqltuner
title: MySQLTuner v0.8.6 is now available
---

Version 0.8.6 of MySQLTuner is [now available][1]. It contains a few bug fixes and readability improvements:

**Newlines are placed between the sections for increased readability**

Each section now contains extra lines to set the sections apart. It makes the output a little longer, but easier to read as well.

**Storage engine status color bug**

Even if the -nocolor option was passed, the storage engine statuses were being shown in color.

**Excluded information_schema from storage engine calculations**

The information_schema database was causing extra MEMORY tables to show up in the calculations. They're now excluded when the calculations are being made.

Shawn Ashlee has also been added as a contributor as he's been a constant help for the project. He's recommended implementation ideas and he has worked to create internal MySQLTuner RPM's for use at Rackspace. Thanks, Shawn!

 [1]: http://mysqltuner.com/