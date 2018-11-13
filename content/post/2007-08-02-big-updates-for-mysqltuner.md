---
title: Big updates for mysqltuner
author: Major Hayden
type: post
date: 2007-08-03T02:35:16+00:00
url: /2007/08/02/big-updates-for-mysqltuner/
dsq_thread_id:
  - 3679039006
tags:
  - database

---
If you haven't checked out my automated mysqltuner.pl script, head on over to [mysqltuner.com][1] and give it a try. The script is written in Perl, and it's an automated way to optimize your MySQL variables for the best performance. It's like being able to ask a DBA to fix your variables, except the script is free, it doesn't require coffee to function (only Perl), and it gives immediate results.

Changes for tonight:

  * Fixed some of the logic for key buffer calculations
  * Added a warning if MySQL hasn't been running very long
  * Additional detailed explanations
  * Checks for max\_seeks\_for_key variable

 [1]: http://mysqltuner.com
