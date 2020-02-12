---
title: 'Two great signals: SIGSTOP and SIGCONT'
author: Major Hayden
type: post
date: 2009-06-15T18:16:19+00:00
url: /2009/06/15/two-great-signals-sigstop-and-sigcont/
dsq_thread_id:
  - 3642805656
categories:
  - Blog Posts
tags:
  - kernel
  - processes
  - sigcont
  - signals
  - sigstop

---
The best uses I've found for the SIGSTOP and SIGCONT signals are times when a process goes haywire, or when a script spawns too many processes at once.

You can issue the signals like this:

```
kill -SIGSTOP [pid]
kill -SIGCONT [pid]
```

Wikipedia has great definitions for [SIGSTOP][1]:

> When SIGSTOP is sent to a process, the usual behaviour is to pause that process in its current state. The process will only resume execution if it is sent the SIGCONT signal. SIGSTOP and SIGCONT are used for job control in the Unix shell, among other purposes. SIGSTOP cannot be caught or ignored.

and [SIGCONT][2]:

> When SIGSTOP or SIGTSTP is sent to a process, the usual behaviour is to pause that process in its current state. The process will only resume execution if it is sent the SIGCONT signal. SIGSTOP and SIGCONT are used for job control in the Unix shell, among other purposes.

In short, SIGSTOP tells a process to &#8220;hold on&#8221; and SIGCONT tells a process to &#8220;pick up where you left off&#8221;. This can work really well for rsync jobs since you can pause the job, clear up some space on the destination device, and then resume the job. The source rsync process just thinks that the destination rsync process is taking a long time to respond.

In the `ps` output, stopped processes will have a status containing _T_. Here's an example with `crond`:

```
# kill -SIGSTOP `pgrep crond`
# ps aufx | grep crond
root      3499  0.0  0.0 100328  1236 ?        Ts   Jun11   0:01 crond
# kill -SIGCONT `pgrep crond`
# ps aufx | grep crond
root      3499  0.0  0.0 100328  1236 ?        Ss   Jun11   0:01 crond
```

 [1]: http://en.wikipedia.org/wiki/SIGSTOP
 [2]: http://en.wikipedia.org/wiki/SIGCONT
