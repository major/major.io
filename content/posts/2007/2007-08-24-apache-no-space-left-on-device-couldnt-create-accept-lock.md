---
title: 'Apache: No space left on device: Couldn’t create accept lock'
author: Major Hayden
date: 2007-08-24T21:55:30+00:00
url: /2007/08/24/apache-no-space-left-on-device-couldnt-create-accept-lock/
dsq_thread_id:
  - 3642769718
tags:
  - apache
  - emergency
  - quotas
  - semaphore
  - web

---
This error completely stumped me a couple of weeks ago. Apparently someone was adjusting the Apache configuration, then they checked their syntax and attempted to restart Apache. It went down without a problem, but it refused to start properly, and didn't bind to any ports.

Within the Apache error logs, this message appeared over and over:

<pre lang="html">[emerg] (28)No space left on device: Couldn't create accept lock</pre>

Apache is basically saying &#8220;I want to start, but I need to write some things down before I can start, and I have nowhere to write them!&#8221; If this happens to you, check these items in order:

**1. Check your disk space**

This comes first because it's the easiest to check, and sometimes the quickest to fix. If you're out of disk space, then you need to fix that problem. :-)

**2. Review filesystem quotas**

If your filesystem uses quotas, you might be reaching a quota limit rather than a disk space limit. Use `repquota /` to review your quotas on the root partition. If you're at the limit, raise your quota or clear up some disk space. Apache logs are usually the culprit in these situations.

**3. Clear out your active semaphores**

Semaphores? What the heck is a semaphore? Well, it's actually an [apparatus for conveying information by means of visual signals][1]. But, when it comes to programming, [semaphores are used for communicating between the active processes of a certain application][2]. In the case of Apache, they're used to communicate between the parent and child processes. If Apache can't write these things down, then it can't communicate properly with all of the processes it starts.

I'd assume if you're reading this article, Apache has stopped running. Run this command as root:

<pre lang="html"># ipcs -s</pre>

If you see a list of semaphores, Apache has not cleaned up after itself, and some semaphores are stuck. Clear them out with this command:

<pre lang="html"># for i in `ipcs -s | awk '/httpd/ {print $2}'`; do (ipcrm -s $i); done</pre>

Now, in almost all cases, Apache should start properly. If it doesn't, you may just be completely out of available semaphores. You may want to increase your available semaphores, and you'll need to tickle your kernel to do so. Add this to /etc/sysctl.conf:

<pre lang="html">kernel.msgmni = 1024
kernel.sem = 250 256000 32 1024</pre>

And then run `sysctl -p` to pick up the new changes.

Further reading:

[Wikipedia: Semaphore (Programming)][2]

[Apache accept lock fix][3]

 [1]: http://en.wikipedia.org/wiki/Semaphore
 [2]: http://en.wikipedia.org/wiki/Semaphore_%28programming%29
 [3]: http://www.webpipe.net/howto/Apache_accept_lock_fix
