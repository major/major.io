---
aliases:
- /2015/02/09/lessons-learned-kernel-bisection/
author: Major Hayden
date: 2015-02-09 14:39:08
tags:
- development
- fedora
- git
- kernel
- linux
title: Lessons learned from a kernel bisection
---

I'm far from being a kernel developer, but I found myself staring down a [peculiar touchpad problem][2] with my new Dell XPS 13. Before kernel 3.17, the touchpad showed up as a standard PS/2 mouse, which certainly wasn't ideal. That robbed the pad of its multi-touch capabilities. Kernel 3.17 added the right support for the pad but freezes began to occur somewhere between 3.17 and 3.19.

## Bisecting

It became apparent that bisecting the kernel would be required. If you're not familiar with [bisection][3], it's a process than can help you narrow down where a particular piece of software picked up a bug. You tell git which revision you know is good and you also tell it which revision has a problem. Git will pick a revision right in the middle and let you re-test. If the test is good, you mark the revision as good and git scoots to the middle between the two known good revisions. The same thing happens if you mark the revision as a bad one.

You'll eventually find yourself staring down fewer and fewer commits until you isolate the commit that is causing problems. From there, you'll need to write a new patch to fix the bug or consider reverting the problematic patch entirely.

## Lessons learned

Making mistakes during a kernel bisection are quite painful since the build times are fairly extensive. Kernel builds on my laptop took about a half hour and a 32-core Rackspace Cloud Server still took about 10 minutes to compile and package the kernel.

### Come up with a solid test plan

Before you get started, define a good test plan so that you know what a good or bad revision should look like. In my case, the touchpad froze when I applied more than one finger to the touchpad or tried to do multi-finger taps and clicks. It's even better if you can figure out a way to run a script to test the revision. If you can do that, git can automated the bisection for you and you'll be done really quickly.

### Build the project consistently

Ensure that you build the software project the same way each time. In my case, I was careful to use the same exact kernel config file and use the same script to build the kernel for each round of bisection. Introducing changes in the build routine could sway your results and cause you to mislabel a good or bad revision.

### Write the upcoming revisions to a file

You can protect yourself from many mistakes by writing the list of revisions in your bisection to a file. That would allow you to come back to the bisection after a mistake and pick up where you left off. You could use something like this:

```


That file will help in case you accidentally run a `git bisect reset` or delete the repository. I cannot confirm or deny that anything like that happened during my work. :)


 [2]: /2015/02/03/linux-support-dell-xps-13-9343-2015-model/
 [3]: http://git-scm.com/docs/git-bisect