---
aliases:
- /2015/08/14/research-paper-securing-linux-containers/
author: Major Hayden
date: 2015-08-14 20:45:50
tags:
- centos
- containers
- docker
- fedora
- giac
- information security
- kubernetes
- linux
- lxc
- networking
- red hat
- sans
- security
title: 'Research Paper: Securing Linux Containers'
---

It seems like there's a new way to run containers every week. The advantages and drawbacks of each approach are argued about on mailing lists, in IRC channels, and in person, around the world. However, the largest amount of confusion seems to be around security.

### Launching secure containers

I've written about launching secure containers on this blog many times before:

  * [Launch secure LXC containers on Fedora 20 using SELinux and sVirt][1]
  * [Improving LXC template security][2]
  * [Try out LXC with an Ansible playbook][3]

However, my goal this time around was to do something more comprehensive and slightly more formal. After getting my [GSEC and GCUX][6] certifications from [SANS/GIAC][7], there was an option to enhance the certification to a gold status by [writing a peer-reviewed research paper][8] on a topic related to the exam. It was a great experience to go through the review process and get feedback on the technical material as well as the structure of the paper itself.

### The paper

Without further ado, here are links to the _Securing Linux Containers_ paper:

  * [PDF version without watermarks][9]
  * [PDF version from SANS][10] _(has some watermarks and SANS/GIAC extra pages)_

The paper is written for readers who have some level of familiarity with Linux and some virtualization technologies. It's a useful paper even for people who haven't worked with containers.

It starts with an overview of Linux containers and how they differ from other types of virtualization, such as KVM or Xen. From there, it covers how to secure the host system underneath the containers and how to provide security within the containers themselves. There's also a section on how to start a simple container on CentOS 7 and inspect the security controls inside and outside the container.

### Licensing

I'm also very proud to announce that the paper is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC-BY-SA)][12]. You are free to quote it as much as you like (even for commercial purposes), but I'd ask that you maintain the same license and attribute me as the author.

### Thank you

This paper wouldn't have been possible without some serious help from these awesome people:

  * **Richard Carbone** was my advisor from SANS and he helped tremendously
  * **Dan Walsh** reviewed the content and gave me several pointers on topics to add and adjust
  * **Paul Voccio, Antony Messerli, and Brad McConnell** from Rackspace also provided feedback
  * My mother, **Neta Greene**, is the best educator I know and she fueled my interest in writing and sharing with others

### Feedback

Please let me know if you spot any errors or areas that need clarification. This is one of my favorite topics and I enjoy talking about it. Find me on Freenode IRC as _mhayden_ and I'll be glad to talk more there.

 [1]: /2014/04/21/launch-secure-lxc-containers-on-fedora-20-using-selinux-and-svirt/
 [2]: /2015/06/18/improving-lxc-template-security/
 [3]: /2014/12/17/try-lxc-ansible-playbook/
 [5]: /wp-content/uploads/2015/08/GCUX.Gold_.hi_.res_.png
 [6]: http://www.giac.org/certified-professional/major-hayden/138471
 [7]: http://www.giac.org/
 [8]: http://www.giac.org/certifications/gold
 [9]: /wp-content/uploads/2015/08/Securing-Linux-Containers-GCUX-Gold-Paper-Major-Hayden.pdf
 [10]: https://www.sans.org/reading-room/whitepapers/linux/securing-linux-containers-36142
 [11]: /wp-content/uploads/2015/08/by-sa.png
 [12]: http://creativecommons.org/licenses/by-sa/4.0/
