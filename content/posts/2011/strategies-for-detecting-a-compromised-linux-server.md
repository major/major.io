---
aktt_notify_twitter:
- false
aliases:
- /2011/03/09/strategies-for-detecting-a-compromised-linux-server/
author: Major Hayden
date: 2011-03-10 02:52:16
dsq_thread_id:
- 3642806498
tags:
- general advice
- linux
- networking
- security
- sysadmin
title: Strategies for detecting a compromised Linux server
---

There are few things which will rattle systems administrators more than a compromised server. It gives you the same feeling that you would have if someone broke into your house or car, except that it's much more difficult (with a server) to determine how to clean up the compromise and found out how the attacker gained access. In addition, leaving a compromise in place for an extended period can lead to other problems:

  * your server could be used to gain access other servers
  * data could be stolen from your server's databases or storage devices
  * an attacker could capture data from your server's local network
  * denial of service attacks could be launched using your server as an active participant

The best ways to limit your server's attack surface are pretty obvious: limit network access, keep your OS packages up to date, and regularly audit any code which is accessible externally or internally. As we all know, your server can still become compromised even with all of these preventative measures in place.

Here are some tips which will allow you to rapidly detect a compromise on your servers:

**Abnormal network usage patterns and atypical bandwidth consumption**

Most sites will have a fairly normal traffic pattern which repeats itself daily. If your traffic graph suddenly has a plateau or spikes drastically during different parts of the day, that could signify that there is something worth reviewing. Also, if your site normally consumes about 2TB of traffic per month and you're at the 1.5TB mark on the fifth day of the month, you might want to examine the server more closely.

On the flip side, look for dips in network traffic as well. This may mean that a compromise is interfering with the operation of a particular daemon, or there may be a rogue daemon listening on a trusted port during certain periods.

Many compromises consist of simple scripts which scan for other servers to infect or participate in large denial of service attacks. The scans may show up as a large amount of packets, but the denial of service attacks will usually consume a large amount of bandwidth. Keeping tabs on network traffic is easily done with open source software like [munin][1], [cacti][2], or [MRTG][3].

**Unusual open ports**

If you run a web server on port 80, but `netstat -ntlp` shows something listening on various ports over 1024, those processes are worth reviewing. Use commands like `lsof` to probe the system for the files and network ports held open by the processes. You can also check within `/proc/[pid]` to find the directory where the processes were originally launched.

Watch out for processes started within directories like `/dev/shm`, `/tmp` or any directories in which your daemons have write access. You might see that some processes were started in a user's home directory. If that's the case, it might be a good time to reset that user's password or clear out their ssh key. Review the output from `last` authentication logs to see if there are account logins from peculiar locations. If you know the user lives in the US, but there are logins from various other countries over a short period, you've got a serious problem.

I've used applications like [chkrootkit][4] and [rkhunter][5] in the past, but I still prefer a keen eye and `netstat` on most occasions.

**Command output is unusual**

I've seen compromises in the past where the attacker actually took the time to replace integral applications like `ps`, `top` and `lsof` to hide the evidence of the ongoing compromise. However, a quick peek in `/proc` revealed that there was a lot more going on.

If you suspect a compromise like this one, you may want to use the functionality provided by `rpm` to verify the integrity of the packages currently installed. You can quickly hunt for changed files by running `rpm -Va | grep ^..5`.

Keeping tabs on changing files can be a challenge, but applications like [tripwire][6] and good ol' [logwatch][7] can save you in a pinch.

**Summary**

We can all agree that the best way to prevent a compromise is to take precautions before putting anything into production. In real life, something will always be forgotten, so detection is a must. It's critical to keep in mind that _monitoring a server means more than keeping track on uptime_. Keeping tabs on performance anomalies will allow you to find the compromise sooner and that keeps the damage done to a minimum.

 [1]: http://munin-monitoring.org/
 [2]: http://www.cacti.net/
 [3]: http://oss.oetiker.ch/mrtg/
 [4]: http://www.chkrootkit.org/
 [5]: http://www.rootkit.nl/projects/rootkit_hunter.html
 [6]: http://www.tripwire.org/
 [7]: http://www.logwatch.org/