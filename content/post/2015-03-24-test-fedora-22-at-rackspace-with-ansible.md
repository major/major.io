---
title: Test Fedora 22 at Rackspace with Ansible
author: Major Hayden
type: post
date: 2015-03-24T13:55:08+00:00
url: /2015/03/24/test-fedora-22-at-rackspace-with-ansible/
dsq_thread_id:
  - 3643818992
categories:
  - Blog Posts
tags:
  - ansible
  - fedora
  - rackspace

---
[<img src="/wp-content/uploads/2012/01/fedorainfinity.png" alt="Fedora Infinity Logo" width="105" height="102" class="alignright size-full wp-image-2712" />][1]Fedora 22 will be [arriving soon][2] and it's easy to test on Rackspace's cloud with my Ansible playbook:

  * <https://github.com/major/ansible-rax-fedora22>

As with the [previous playbook][3] I created for Fedora 21, this playbook will ensure your Fedora 21 instance is fully up to date and then perform the upgrade to Fedora 22.

**<span style="color: #D42020;">WARNING</span>: It's best to use this playbook against a non-production system. Fedora 22 is an alpha release at the time of this post's writing.**

This playbook should work well against other servers and virtual machines from other providers but there are a few things that are Rackspace-specific cleanups that might not apply to other servers.

 [1]: /wp-content/uploads/2012/01/fedorainfinity.png
 [2]: http://fedoraproject.org/wiki/Releases/22/Schedule
 [3]: https://github.com/major/ansible-rax-fedora21
