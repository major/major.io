---
aliases:
- /2013/04/26/automate-centos-6-deployments-with-cis-security-benchmarks-already-applied/
author: Major Hayden
date: 2013-04-26 14:15:24
dsq_thread_id:
- 3642807251
tags:
- centos
- development
- fedora
- github
- kickstart
- red hat
- rpm
- security
title: Automate CentOS 6 deployments with CIS Security Benchmarks already applied
---

A coworker heard me grumbling about Linux system administration standards and recommended that I review the [CIS Security Benchmarks][1]. After downloading the Red Hat Enterprise Linux 6 security benchmark PDF, I quickly started to see the value of the document. Some of the standards were the installation defaults, some were often forgotten settings, and some were completely brand new to me.

Automating the standards can be a little treacherous simply due to the number of things to adjust and check. I've created a kickstart for CentOS 6 and tossed it on Github:

  * <https://github.com/rackerhacker/securekickstarts>

Be sure to read the disclaimers in the [README][2] before getting started. Also, keep in mind that the kickstarts are in no way approved by or affiliated with the [Center for Internet Security][3] in any way. This is just something I'm offering up to the community in the hope that it helps someone.

 [1]: http://benchmarks.cisecurity.org/
 [2]: https://github.com/rackerhacker/securekickstarts/blob/master/README.md
 [3]: https://www.cisecurity.org/