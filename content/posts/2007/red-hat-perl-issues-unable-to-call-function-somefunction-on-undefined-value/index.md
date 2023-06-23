---
aliases:
- /2007/11/19/red-hat-perl-issues-unable-to-call-function-somefunction-on-undefined-value/
author: Major Hayden
date: 2007-11-19 18:19:12
dsq_thread_id:
- 3679012604
tags:
- command line
- perl
- red hat
- web
title: 'Red Hat Perl Issues: unable to call function somefunction on undefined value'
---

Apparently, a recent Red Hat Enterprise Linux update for ES3, 4 and 5 caused some Perl applications to throw errors like these:

```
unable to call function somefunction on undefined value
```

Of course, replace `somefunction` with your function of choice. To correct the issue, you can force CPAN to bring back a more sane version of Scalar::Util:

```
# perl -MCPAN -e shell
cpan> force install Scalar::Util
```