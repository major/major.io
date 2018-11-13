---
title: 'Red Hat Perl Issues: unable to call function somefunction on undefined value'
author: Major Hayden
type: post
date: 2007-11-19T18:19:12+00:00
url: /2007/11/19/red-hat-perl-issues-unable-to-call-function-somefunction-on-undefined-value/
dsq_thread_id:
  - 3679012604
tags:
  - command line
  - perl
  - red hat
  - web

---
Apparently, a recent Red Hat Enterprise Linux update for ES3, 4 and 5 caused some Perl applications to throw errors like these:

`unable to call function <em>somefunction</em> on undefined value`

Of course, replace `somefunction` with your function of choice. To correct the issue, you can force CPAN to bring back a more sane version of Scalar::Util:

`# perl -MCPAN -e shell<br />
cpan> force install Scalar::Util`