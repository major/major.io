---
title: SIGTERM vs. SIGKILL
author: Major Hayden
type: post
date: 2010-03-18T13:25:59+00:00
url: /2010/03/18/sigterm-vs-sigkill/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642806049
categories:
  - Blog Posts

---
Sending signals to processes using `<a href="http://en.wikipedia.org/wiki/Kill_(command)">kill</a>` on a Unix system is not a new topic for most systems administrators, but I've been asked many times about the difference between `kill` and `kill -9`.

Anytime you use `kill` on a process, you're actually sending the process a signal (in almost all situations &#8211; I'll get into that soon). Standard C applications have a [header file][1] that contains the steps that the process should follow if it receives a particular signal. You can get an entire list of the available signals on your system by checking the man page for `kill`.

Consider a command like this:

<pre lang="html">kill 2563</pre>

This would send a signal called [SIGTERM][2] to the process. Once the process receives the notice, a few different things can happen:

  * the process may stop immediately
  * the process may stop after a short delay after cleaning up resources
  * the process may keep running indefinitely

The application can determine what it wants to do once a SIGTERM is received. While most applications will clean up their resources and stop, some may not. An application may be configured to do something completely different when a SIGTERM is received. Also, if the application is in a bad state, such as waiting for disk I/O, it may not be able to act on the signal that was sent.

Most system administrators will usually resort to the more abrupt signal when an application doesn't respond to a SIGTERM:

<pre lang="html">kill -9 2563</pre>

The `-9` tells the `kill` command that you want to send signal #9, which is called [SIGKILL][3]. With a name like that, it's obvious that this signal carries a little more weight.

Although SIGKILL is defined in the same signal header file as SIGTERM, it cannot be ignored by the process. In fact, the process isn't even made aware of the SIGKILL signal since the signal goes straight to <del datetime="2010-03-18T18:02:01+00:00">the kernel</del> init. At that point, init will stop the process. The process never gets the opportunity to catch the signal and act on it.

However, the kernel may not be able to successfully kill the process in some situations. If the process is waiting for network or disk I/O, the kernel won't be able to stop it. [Zombie processes][4] and processes caught in an [uninterruptible sleep][5] cannot be stopped by the kernel, either. A reboot is required to clear those processes from the system.

 [1]: http://en.wikipedia.org/wiki/Signal.h
 [2]: http://en.wikipedia.org/wiki/SIGTERM
 [3]: http://en.wikipedia.org/wiki/SIGKILL
 [4]: http://en.wikipedia.org/wiki/Zombie_process
 [5]: http://en.wikipedia.org/wiki/Uninterruptible_sleep
