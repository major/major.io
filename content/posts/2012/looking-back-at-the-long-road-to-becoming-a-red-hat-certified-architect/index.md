---
aliases:
- /2012/02/13/looking-back-at-the-long-road-to-becoming-a-red-hat-certified-architect/
author: Major Hayden
date: 2012-02-13 15:00:41
tags:
- centos
- certifications
- fedora
- advice
- linux
- rackspace
- red hat
- rpm
- sysadmin
title: Looking back at the long road to becoming a Red Hat Certified Architect
---

The grades came back last Friday and I've passed the last exam in the requirements to become a [Red Hat Certified Architect (RHCA)][1]. I was fortunate enough to be part of Rackspace's RHCA pilot program and we took our first exam back at the end of 2010. It's definitely a good feeling to be finished and I'm definitely ready to give back some knowledge to the readers of this blog.

**First things first:** there are going to be many part of this post which probably aren't as specific as you'd like. A lot of that is due to the NDA that all Red Hat examinees agree to when they take an exam. We aren't allowed to talk about what was on the exam or our experiences during the exam. If we do, penalties range from smaller things like losing certifications all the way up to serious stuff like legal action. It goes without saying that I want to protect the security of the exams, I don't want to lose my certifications, and I don't want to hire a lawyer. Please try to keep this in mind if you yearn for more specifics than I'm able to give.

**Red Hat Certified Engineer**

The [RHCSA][2] and [RHCE][3] exams are the first step on the path to the RHCA. You can't take any of the RHCA prerequisite exams without it. These exams cover a really broad spectrum of material including apache configuration, NFS, iptables and mail services. The two links above will take you to the exam objectives for each exam.

I've always recommended the RHCE exam for Linux administrators who are trying to sharpen their skills and get to the next level whether they use Red Hat or not. The exam covers a lot of good material that makes a solid foundation for any Linux user without throwing in too many Red Hat-specific knowledge.

The exam (like all Red Hat exams) is fully practical. There are no multiple choice questions or essays. You'll have to meet all of the objectives by logging into a local Red Hat system and making the system do what it needs to do.

Quick tips for the RHCSA/RHCE exams:

  * Keep your eye on the clock. Time can really get away from you if you get stuck in the weeds on a problem that should be relatively straightforward.
  * Leave time at the end to check your work. When you set up a lot of services, it's inevitable that you might configure a service for one problem that breaks the functionality required by a problem you completed already.
  * Always reboot before you leave. We all forget to use `chkconfig` when we're in a hurry.
  * Practice, practice, practice. There's not one objective on this exam that you can't test in a VM on your own.

**Red Hat Enterprise System Monitoring and Performance Tuning**

Our group at Rackspace started off with [EX442][4] and it was a very difficult way to start off the RHCA track. Take a look at the objectives and you'll see that much of the exam is related to tweaking system performance and then monitoring that performance with graphs and raw data. You'll have to turn a lot of knobs on the kernel and you'll need to know where to store these configurations so they'll be persistent.

In addition, the objective regarding TCP buffers and related settings is a real challenge. You'll have to wrestle with some math that appears to be relatively simple, but can get confusing quickly. Some of the settings can't really be checked to know if your setting is correct. The objectives mention tuning disk scheduling - you don't really have the time or tools to know if your setting is ideal.

Quick tips for EX442:

  * Use the documentation available to you. Install the `kernel-doc` package while you practice and during the exam.
  * Be careful with your math. You have a Linux machine in front of you! Don't forget about `bc`.
  * Watch your units. Know the difference between a kilobyte (KB) and a kibibyte (KiB).
  * Make comments in files where you adjust kernel configurations. It will help you keep track of which question the kernel adjustment is meant to satisfy.

**Red Hat Enterprise Storage Management**

I'm surprised to say this now, but I actually enjoyed [EX436][5]. I've always used other clustering tools like heartbeat and pacemaker, but I've never had the need to use the Red Hat Cluster Suite. Although RHCS definitely has a lot of quirks and rough edges, it's pretty solid once you get familiar with the GUI and command line tools.

You get the opportunity to mess around with some pretty useful technology like iSCSI, GFS, and clustered LVM. These are things that you're probably already using or will be using soon in a large server environment. The web interface for RHCS is quite peculiar and you may find yourself wanting to put your fist through the screen when you're staring down the endless animated GIFs when the cluster is syncing its configuration. Do your best to be patient because you certainly don't want to short circuit the cluster sync.

Quick tips for EX436:

  * Be patient. You'll feel like the RHCS web interface is mocking you when you're pressed for time.
  * Watch the clock. It's extremely easy to burn a lot of time on this exam if you get stuck on a particular problem.
  * Double check your entries in the web interface. Make sure you're doing things in the right order and that you've set up the prerequisites before adding services to the cluster. If you get it wrong, you could put your cluster into a weird state.
  * Use man pages. If you don't mess with GFS a lot, the man pages will save you in a pinch.

**Red Hat Enterprise Deployment and Systems Management**

If there's one exam where time management is critical, it's [EX401][6]. Importing data into the Satellite Server takes quite a bit of time and there's almost nothing you can do to speed it up. It probably goes without saying, but as with most long-running tasks, you'll want to run it in screen. The last thing you'd ever want is to abort the import due to an errant click or CTRL-C (I did it while practicing - it's aggravating).

There are other test objectives which you can either complete or partially complete while you wait for the import to finish.

Also, take the time to really dig into the Satellite Server web interface while your practicing for the exam. Knowing where to find the most common configuration items will really save some time when you're in the exam. You can sometimes get pretty bogged down in the interface so don't forget to use multiple tabs to keep your work organized.

I felt like this exam was the easiest out of the bunch since you could go back and test every single question with good time management. _Did I mention how important time management was on this exam already?_ If I forgot to mention it earlier, be sure to focus on time management for this test.

Quick tips for EX401:

  * Time management will make or break you on this test. Keep an eye on the clock and make sure you've done absolutely every piece of the exam that you can while you wait for the server to do its work.
  * Scour the web interface. Keep a mental map in your mind where the big chunks of configuration items are.
  * Go back and test everything. If you manage your time well, you should have enough time to verify each and every objective on this exam.

**Red Hat Enterprise Directory Services and Authentication**

At first, [EX423][7] looks pretty straightforward. Red Hat's authentication configuration tools make LDAP authentication setup pretty easy. However, this exam comes with a lot of curveballs.

The GUI interface for the Directory Services component is a little frustrating to use. I found that the GUI stopped responding to keyboard input occasionally unless I clicked on another window and came back. If you misconfigure the SSL certificates in the interface, your LDAP server is down for the count. If you don't input the correct data into the setup scripts at the beginning, you might not notice it until much later when it's either too difficult to dig yourself out of the hole or it's too late to start over with a clean configuration.

I didn't feel pressed for time on this exam too much and that was pretty refreshing after taking the EX401 test. It's extremely critical to watch what you type and click on this exam. Some mistakes can be quickly corrected while others may require you to blow away the LDAP server configuration and re-provision the whole thing.

Quick tips for EX423:

  * Always watch what you're typing. A simple mistake can lead to confusion or bigger issues down the road.
  * Don't ignore the LDIF objectives. As you practice, you'll find that manipulating LDIF files is a little more involved than you expected.
  * Practice starting over. Throw out your Directory Services configuration and get the experience of what it's like to start over and get back in the game.

**Red Hat Enterprise Security: Network Services**

There's no sugar coating it - [EX333][8] is a beast. It's a six hour exam broken into two three-hour chunks. It covers a ton of material and I refer to it as "the RHCE on steroids." You might argue that I thought it was hard since it was the last test and I was ready to be finished, but I really think this exam is a tough one.

Practicing for the Kerberos and DNS objectives was the hardest for me. I just couldn't understand Kerberos, no matter how hard I tried. The realization that I would really have to learn it soon set in. I dug into the Kerberos design documentation on MIT's site, read the summaries on Wikipedia, and scoured the documentation available in the Kerberos RPM packages. Once I understood _why_ Kerberos is set up the way it is and _why_ the security measures are present, everything began to come together. I was able to remember the steps not because I was memorizing them, but because I understood how Kerberos worked.

When you're working through the DNS objectives, keep an eye out for punctuation. I blew through a good 20 minutes in what seemed like the blink of an eye when I forgot a period in my TSIG key configuration while studying. Make sure you use the resources available to you, like `system-config-bind` and sample configs in `/usr/share/doc/bind*/examples/`. Get to know commands like `dig` really well.

If you're overwhelmed by OpenSSL's command line syntax, check out the `/etc/pki/tls/misc/CA` script. There are some handy comments at the top of the script that explain how to use it. You can also pluck OpenSSL commands right out of the script if you need to run them yourself.

  * Don't just memorize. Do some research to understand how everything fits together.
  * Manage your time. DNS and Kerberos have lots of small nuances that can become time sinks when done incorrectly.
  * Use the available documentation and tools. Try practicing without study materials so that you're forced to use the docs and tools available within the server.

**Ranking the exams**

A couple of folks on Twitter asked me to rank the exams from most difficult to least difficult. Keep in mind that these are a little subjective since I was more familiar with some objectives than others for certain tests.

  * **EX333 - Enterprise Security: Network Services:** a tubload of material and a very long exam
  * **EX442 - System Monitoring and Performance Tuning:** very difficult to check your work, lots of calculations
  * **EX423 - Directory Services and Authentication:** not a lot of material to cover, but tons of curveballs
  * **EX436 - Storage Management:** the web interface made things much easier, lots of documentation available
  * **EX401 - Deployment and Systems Management:** every objective can be tested, I build RPM's already

 [1]: http://www.redhat.com/training/certifications/rhca/
 [2]: http://www.redhat.com/training/courses/ex200/examobjective
 [3]: http://www.redhat.com/training/courses/ex300/examobjective
 [4]: http://www.redhat.com/training/courses/ex442/examobjective
 [5]: http://www.redhat.com/training/courses/ex436/examobjective
 [6]: http://www.redhat.com/training/courses/ex401/examobjective
 [7]: http://www.redhat.com/training/courses/ex423/examobjective
 [8]: http://www.redhat.com/training/courses/ex333/examobjective