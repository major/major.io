---
aliases:
- /2015/08/05/automated-testing-for-ansible-cis-playbook-on-rhelcentos-6/
author: Major Hayden
date: 2015-08-05 13:13:52
dsq_thread_id:
- 4005367241
tags:
- ansible
- centos
- development
- rhel
- security
title: Automated testing for Ansible CIS playbook on RHEL/CentOS 6
---

[<img src="/wp-content/uploads/2014/08/image-ansible-150x150.png" alt="Ansible logo" width="150" height="150" class="alignright size-thumbnail wp-image-5157" srcset="/wp-content/uploads/2014/08/image-ansible-150x150.png 150w, /wp-content/uploads/2014/08/image-ansible-300x300.png 300w, /wp-content/uploads/2014/08/image-ansible.png 700w" sizes="(max-width: 150px) 100vw, 150px" />][1]I started working on the Ansible CIS playbook for CentOS and RHEL 6 [back in 2014][2] and I've made a few changes to increase quality and make it easier to use.

First off, the role itself is no longer a submodule. You can now just clone the repository and get rolling. This should reduce the time it takes to get started.

Also, all pull requests to the repository now go through integration testing at Rackspace. Each pull request goes through the gauntlet:

  * Syntax check on Travis-CI
  * Travis-CI builds a server at Rackspace
  * The entire Ansible playbook runs on the Rackspace Cloud Server
  * Results are sent back to GitHub

The testing process usually takes under five minutes.

_Stay tuned: Updates are coming for RHEL and CentOS 7. ;)_

 [1]: /wp-content/uploads/2014/08/image-ansible.png
 [2]: /2014/08/19/audit-rhelcentos-6-security-benchmarks-ansible/