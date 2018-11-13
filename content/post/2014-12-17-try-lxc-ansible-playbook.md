---
title: Try out LXC with an Ansible playbook
author: Major Hayden
type: post
date: 2014-12-17T13:50:26+00:00
url: /2014/12/17/try-lxc-ansible-playbook/
dsq_thread_id:
  - 3642807773
categories:
  - Blog Posts
tags:
  - ansible
  - command line
  - containers
  - fedora
  - linux
  - lxc
  - virtualization

---
[<img src="/wp-content/uploads/2014/08/image-ansible-300x300.png" alt="Ansible logo" width="300" height="300" class="alignright size-medium wp-image-5157" srcset="/wp-content/uploads/2014/08/image-ansible-300x300.png 300w, /wp-content/uploads/2014/08/image-ansible-150x150.png 150w, /wp-content/uploads/2014/08/image-ansible.png 700w" sizes="(max-width: 300px) 100vw, 300px" />][1]The world of containers is constantly evolving lately. The latest turn of events involves the CoreOS developers when they announced [Rocket][2] as an alternative to [Docker][3]. However, [LXC][4] still lingers as a very simple path to begin using containers.

When I talk to people about LXC, I often hear people talk about how difficult it is to get started with LXC. After all, Docker provides an easy-to-use image downloading function that allows you to spin up multiple different operating systems in Docker containers within a few minutes. It also comes with a daemon to help you manage your images and your containers.

Managing LXC containers using the basic LXC tools isn't terribly easy - I'll give you that. However, managing LXC through [libvirt][5] makes the process much easier. I [wrote a little about this][6] earlier in the year.

I decided to turn the LXC container deployment process into an [Ansible playbook][7] that you can use to automatically spawn an LXC container on any server or virtual machine. At the moment, only Fedora 20 and 21 are supported. I plan to add CentOS 7 and Debian support soon.

Clone the repository to get started:

```
git clone https://github.com/major/ansible-lxc.git
cd ansible-lxc
ansible-playbook -i hosts playbook.yml
```


If you're running the playbook on the actual server or virtual machine where you want to run LXC, there's no need to alter the `hosts` file. You will need to adjust it if you're running your playbook from a remote machine.

As the playbook runs, it will install all of the necessary packages and begin assembling a Fedora 21 chroot. It will register the container with libvirt and do some basic configuration of the chroot so that it will work as a container. You'll end up with a running Fedora 21 LXC container that is using the built-in default NAT network created by libvirt. The playbook will print out the IP address of the container at the end. The default password for root is _fedora_. I wouldn't recommend leaving that for a production use container. ;)

All of the normal `virsh` commands should work on the container. For example:

```
# Stop the container gracefully
virsh shutdown fedora21
# Start the container
virsh start fedora21
```


Feel free to install the virt-manager tool and manage everything via a GUI locally or via X forwarding:

```
yum -y install virt-manager dejavu* xorg-x11-xauth
# OPTIONAL: For a better looking virt-manager interface, install these, too
yum -y install gnome-icon-theme gnome-themes-standard
```


 [1]: /wp-content/uploads/2014/08/image-ansible.png
 [2]: https://coreos.com/blog/rocket/
 [3]: https://www.docker.com/
 [4]: https://linuxcontainers.org/
 [5]: https://libvirt.org/drvlxc.html
 [6]: /2014/04/21/launch-secure-lxc-containers-on-fedora-20-using-selinux-and-svirt/
 [7]: https://github.com/major/ansible-lxc
