---
aliases:
- /2008/01/15/mysqltuner-revision-26-is-now-available/
author: Major Hayden
date: 2008-01-15 14:00:22
tags:
- database
- development
- mysql
- mysqltuner
title: MySQLTuner Revision 26 is now available
---

As some subversion users may have noticed, revision 23 of MySQLTuner was released quietly on Sunday. Thanks to [Mike Jackson][1], a few bugs from revision 23 were smashed today and revision 26 was released this morning.

To pick up the new script, [visit the MySQLTuner site][2].

Here's some of the new features:

**&raquo; Shows banner of enabled and disabled storage engines**

Near the top of the MySQLTuner output, you'll find a line like this:

`</p>
<pre>[**] Status: -Archive -BDB -Federated +InnoDB -ISAM -NDBCluster</pre>
<p>`

Of course, this is shown in color within the terminal, but all enabled storage engines are shown in green with a plus sign at the front. Disabled storage engines are shown in red and are prepended with a minus sign.

**&raquo; Recommends disabling unused storage engines**

If MySQLTuner finds storage engines enabled that are not in use, it will recommend that they are disabled to save resources:

`</p>
<pre>[!!] InnoDB is enabled but isn't being used</pre>
<p>`

**&raquo; Calculates total data corresponding to storage engines**

Any storage engines in use are shown with the total amount of data stored using those engines:

`</p>
<pre>[**] Data in MyISAM tables: 9G
[**] Data in InnoDB tables: 189M
[**] Data in MEMORY tables: 0B</pre>
<p>`

**&raquo; Displays exact counts in addition to percentages**

For some results where percents are shown, exact counts are being displayed as well:

`</p>
<pre>[OK] Slow queries: 0% (1/4M)
[OK] Highest usage of available connections: 56% (17/30)</pre>
<p>`

**&raquo; Initial InnoDB support**

As an initial step towards InnoDB support, the innodb\_buffer\_pool_size is compared to the total amount of InnoDB data stored on the server:

`</p>
<pre>[OK] InnoDB data size / buffer pool: 189.7M/384.0M</pre>
<p>`

**&raquo; Other minor changes**

  * Added additional section headers to further organize the output
  * Merged the total buffers lines into one for more compact output
  * Added MySQL 5.1 to the supported list to prepare for upcoming GA release
  * For filesize amounts less than 1024 bytes, the "B" letter is shown to represent bytes
  * InnoDB log file recommendation removed due to bad implementations based on recommendations
  * Switches from spaced indents to tabbed indents

 [1]: http://barking-dog.net/
 [2]: http://mysqltuner.com/