---
aliases:
- /2014/10/03/easily-test-fedora-21-rackspace-cloud/
author: Major Hayden
date: 2014-10-03 20:24:19
dsq_thread_id:
- 3651144027
tags:
- ansible
- fedora
- linux
- rackspace
title: Test Fedora 21 at Rackspace with Ansible
---

[<img src="/wp-content/uploads/2012/01/fedorainfinity.png" alt="Fedora Infinity Logo - Fedora 21" width="105" height="102" class="alignright size-full wp-image-2712" />][1]Fedora 21 reached Alpha status last month and will [reach beta status][2] at the end of October. There are plenty of [new features planned][3] for the final release.

You can test Fedora 21 now using Rackspace's Cloud Servers. I've assembled a small Ansible playbook that will automate the upgrade process from Fedora 20 to 21 and it takes around 7-9 minutes to complete.

The Ansible playbook is on GitHub along with instructions: [ansible-rax-fedora21][4]

 [1]: /wp-content/uploads/2012/01/fedorainfinity.png
 [2]: https://fedoraproject.org/wiki/Releases/21/Schedule
 [3]: https://fedoraproject.org/wiki/Releases/21/ChangeSet
 [4]: https://github.com/major/ansible-rax-fedora21