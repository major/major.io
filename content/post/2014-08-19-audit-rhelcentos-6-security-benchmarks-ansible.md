---
title: Audit RHEL/CentOS 6 security benchmarks with ansible
author: Major Hayden
type: post
date: 2014-08-19T12:00:35+00:00
url: /2014/08/19/audit-rhelcentos-6-security-benchmarks-ansible/
dsq_thread_id:
  - 3642807712
categories:
  - Blog Posts
tags:
  - ansible
  - centos
  - development
  - fedora
  - github
  - infosec
  - redhat

---
[<img src="/wp-content/uploads/2014/08/image-ansible-150x150.png" alt="Ansible logo" width="150" height="150" class="alignright size-thumbnail wp-image-5157" srcset="/wp-content/uploads/2014/08/image-ansible-150x150.png 150w, /wp-content/uploads/2014/08/image-ansible-300x300.png 300w, /wp-content/uploads/2014/08/image-ansible.png 700w" sizes="(max-width: 150px) 100vw, 150px" />][1]Securing critical systems isn't easy and that's why security benchmarks exist. Many groups and communities distribute recommendations for securing servers, including [NIST][2], the [US Department of Defense (DoD)][3], and the [Center for Internet Security (CIS)][4].

Although NIST and DoD are catching up quickly with newer OS releases, I've found that the CIS benchmarks are updated very regularly. CIS distributes auditing tools (with paid memberships) that require Java and they're cumbersome to use, especially on servers where Java isn't normally installed.

### A better way to audit security benchmarks

I set out to create an Ansible playbook that would allow users to audit and (carefully!) remediate servers. The result is [on GitHub][5]. _Before we go any further, I'd just like to state that I'm not affiliated with CIS in any way and this repository hasn't been endorsed by CIS. Use it at your own risk._

Getting the playbook onto a machine is easy:

```
git clone https://github.com/major/cis-rhel-ansible.git
```


<strong style="color: #D42020;">PLEASE review the <a href="https://github.com/major/cis-rhel-ansible/blob/master/README.md">README</a> and <a href="https://github.com/major/cis-rhel-ansible/blob/master/NOTES.md">NOTES</a> files in the GitHub repository prior to running the playbook.</strong>

[<img src="/wp-content/uploads/2014/08/What-Did-You-Do-Chris-Farley-Gif.gif" alt="What-Did-You-Do-Chris-Farley-Gif" width="320" height="180" class="aligncenter size-full wp-image-5159" />][6]

<strong style="color: #D42020;">Seriously. I mean it. This playbook could knock production environments offline.</strong>

The tasks are split into sections (just like the CIS benchmarks themselves) and each section is split into Level 1 and 2 requirements.

### Benchmark levels

Level 1 requirements provide good security improvements without a tremendous amount of intrusion into production workloads. With that said, they can still cause issues.

Level 2 requirements provide stronger security improvements but they can adversely affect production server environments. This is where you find things like [SELinux][7], [AIDE][8] (including disabling prelinking), and some [kernel tweaks for IPv6][9].

### How to use it

I strongly recommend some dry runs with Ansible's [check mode][10] before trying to modify a production system. Also, you can run the playbook against a freshly-installed system and then deploy your applications on top of it. Find out what breaks and disable certain benchmarks that get in the way.

The entire playbook takes less than a minute to run locally on a Rackspace Performance Cloud Server. Your results may vary over remote ssh connections, but I was seeing the playbooks complete over ssh within three to four minutes.

You can also review the [variables file][11] to find all the knobs you need to get more aggressive in your audits. If you spot something potentially destructive that needs a variable added, let me know (or submit a pull request).

### It's open source

The entire repository is licensed under [Apache License 2.0][12], so please feel free to submit issues, pull requests, or patches.

 [1]: /wp-content/uploads/2014/08/image-ansible.png
 [2]: https://web.nvd.nist.gov/view/ncp/repository
 [3]: http://iase.disa.mil/stigs/Pages/index.aspx
 [4]: http://benchmarks.cisecurity.org/downloads/
 [5]: https://github.com/major/cis-rhel-ansible
 [6]: /wp-content/uploads/2014/08/What-Did-You-Do-Chris-Farley-Gif.gif
 [7]: https://github.com/major/cis-rhel-ansible/blob/master/cis/tasks/section_01_level2.yml#L113
 [8]: https://github.com/major/cis-rhel-ansible/blob/master/cis/tasks/section_01_level2.yml#L78
 [9]: https://github.com/major/cis-rhel-ansible/blob/master/cis/tasks/section_04_level2.yml#L18
 [10]: http://docs.ansible.com/playbooks_checkmode.html
 [11]: https://github.com/major/cis-rhel-ansible/blob/master/group_vars/all
 [12]: https://www.apache.org/licenses/LICENSE-2.0.html
