---
title: 'CoreOS vs. Project Atomic: A Review'
author: Major Hayden
type: post
date: 2014-05-14T03:57:55+00:00
url: /2014/05/13/coreos-vs-project-atomic-a-review/
dsq_thread_id:
  - 3642807497
categories:
  - Blog Posts
tags:
  - containers
  - coreos
  - docker
  - fedora
  - linux
  - red hat
  - rpm
  - yum

---
<span style="color: #D42020; font-weight: bold;">This post hasn't been updated in quite some time.</span> Many of these comparisons still hold true but some don't. Updating this post is on my list of to-do's. _- MH 2015-04-25_

* * *

You've probably been living under a rock if you haven't heard about [Docker][1]. It simplifies the deployment and management of Linux containers better than anything else I've seen so far. Many ecosystems are growing with Docker at the core and two of the most popular hosting platforms for Docker are [CoreOS][2] and [Project Atomic][3].

Both platforms offer a very minimal operating system layer and they take different approaches to automating the deployment of containers across multiple hosts. They have quite a few similarities, like the dependence on [systemd][4] and [journald][5]. They also employ some interesting upgrade and package management mechanisms that make the host OS relatively expendable.

Every time I look at platforms like these, I tend to ask these questions:

  1. How easy is it to deploy the OS and containers on top of it?
  2. How do I manage a large fleet?
  3. How can I secure the OS in single-tenant and multi-tenant environments?

Without further ado, let's answer those questions about these two container hosting projects.

### Deployment

#### CoreOS

[Deploying CoreOS][6] is a bit unusual if you're used to installing from kickstarts, preseeds, or install ISO's. However, there's no shortage of installation methods. The simplest methods involve public cloud providers, like [Rackspace][7], Amazon, or Google (but I'm a little biased towards Rackspace's Cloud Servers since I helped build that product). You can also PXE boot the image or load it up on a server running KVM. If you spin up instances with a cloud provider, you can use [cloud-config][8] configuration files to automatically link up the instances and provision public ssh keys.

Once your CoreOS nodes are up, you can log in via ssh as the _core_ user. They share a key-value pair system called [etcd][9] that is clustered between all of the nodes. You can add data to etcd from any node and any other node can read that data. This is quite handy when you need a place to store small tidbits of information about containers or applications running within containers. You could use that information to write automation that will update load balancers to point to the right containers. The functionality still leaves a little to be desired - more on that later.

Deploying containers is very straightforward. For quick tests, you can use the standard `docker pull` and `docker run` commands to launch containers. However, if you do that, you really aren't using the features that make CoreOS unique. Managing containers the CoreOS way requires writing systemd unit files and [submitting them to the cluster via fleetctl][10]. You don't even need to run a `docker pull` before submitting and launching a container - CoreOS will handle that for you on the fly. It's a good idea to pull the containers ahead of time to save time when containers are launched on other nodes.

The real beauty of CoreOS is when a node fails or needs to be rebooted for an update. The containers running on a host that is going offline will be migrated to another node in the cluster. If you haven't pulled the container image down to each machine in the cluster, you'll be waiting a bit before the container comes up on another node. Here's the catch: it's up to you to adjust the load balancer configuration or write automation to handle it for you. Luckily, the CoreOS folks have some [example documentation][11] around automatic load balancer configuration at Amazon.

#### Project Atomic

CoreOS has a bit more time under its belt than Project Atomic and it shows when you examine the deployment methods. Project Atomic started in April 2014 and is less than a month old at the time this post was written. CoreOS was started in early 2013.

There are [two deployment methods][12] available for Project Atomic: QEMU (KVM) and VirtualBox. Both deployment methods work equally well, but I prefer KVM. Once the image has launched, you can set a root password (it's blank by default) and add public ssh keys.

Much like CoreOS, you can deploy containers using the standard docker commands. Also like CoreOS, this doesn't allow you to get the benefits from Project Atomic. The project centers around a new piece of software called [geard][13]. It allows you to [link different containers together][14] and work with them as a unit. You can do this on a single host or across multiple hosts using relatively simple json files.

This concept was difficult to understand at first, but it made sense once I read through their [MongoDB example][15] and thought about geard's integration with OpenShift. It might be useful to bundle apache and MariaDB together as a unit and allow them to move through a cluster together. That would be handy for most LAMP applications like WordPress. There are good benefits for managing enterprise applications (think JBoss) where there are multiple middleware stacks involved.

### Management

#### CoreOS

There's very little to manage within CoreOS. Updates are handled using an A/B system where updates are staged and reboots are automated. Rollbacks can be done during bootup if an update went badly. Multiple [update strategies][16] are available within CoreOS. I've run some five-node clusters for a few weeks now and I haven't noticed any updates that have caused a problem. As I said before, updates are done carefully within a cluster to ensure that services aren't disrupted unnecessarily.

If you search CoreOS for a package manager, you won't find one. Also, you won't find compilers, python, perl or ruby. They do provide quick access to many of those tools using a [Fedora container called "toolbox"][17] started by [systemd-nspawn][18]. It's a great way to dig through errors or test out some scripts.

There's no GUI component of CoreOS, but it does offer a handy management system called [fleet][19]. A client, fleetctl, allows you to list all of your running containers (called units, due to the systemd unit files) as well as all of your nodes. You can add new units, start/stop units, or destroy units entirely using fleetctl. The tool worked nearly flawlessly for me. I submitted a malformed systemd unit file and had a difficult time getting it cleaned up.

#### Project Atomic

Just like CoreOS, Project Atomic isn't your average Linux system. Fedora and Red Hat users will spot a familiar filesystem layout along with yum, but that's where many of the similarities stop. Both `/usr` and `var` are mounted read only so don't even try using yum. You'll update these systems using a new method: [rpm-ostree][20].

Long story short, the idea behind rpm-ostree is similar to tossing your OS into a git repository. Running rpm-ostree causes the tool to sync down a tree of data that you'd normally get by running yum or rpm. It runs a three-way merge after the download and it applies new binaries to the system afterwards. You can revert to a previous revision relatively easily and it helps to make the base system mostly expendable. After all, your containers and their storage is much more critical.

There's a helpful GUI called [cockpit][21] that gives you a great status readout on all of your connected servers. It lacks some functionality in the container and gear management arena, but it's very useful for a pre-release application. One of the best features is the ability to open a console for your containers right there in the web browser. I find it to be more intuitive and more useful than more mature Docker GUI's like [shipyard][22].

Atomic's base OS is very close to Fedora 20. It's so close that you can actually [build your own Project Atomic][23] host from an existing Fedora 20 system. This leads me to think that additional management features will be coming soon.

### Security

#### CoreOS

Authentication in CoreOS is mainly done with public ssh keys for now. Once you log in as the core user, you can become root without a password using `sudo`. I couldn't find any options for using LDAP, Kerberos, or other centralized authentication mechanisms. Without a package manager, you may be stuck building a bastion as a container on top of CoreOS in enterprise environments.

You'll also find that systemd is built without SELinux, AppArmor and audit support. Seccomp is included, but I'd expect that on any system running containers as a bare minimum. [IMA][24] is also included but I haven't found how or if it's being used on a CoreOS system.

#### Project Atomic

Security seems to be much more of a focus within Project Atomic. That's probably related to the more fully-featured Linux OS under the hood. SELinux is enabled by default and you'll find IMA, audit and libwrap available from systemd. Running containers have SELinux contexts applied and [SVirt][25] is used to enforce boundaries between containers. Cockpit and SELinux don't get along well yet and you'll be forced to run the dreaded `setenforce 0` if you want to use cockpit.

Access to the instance itself is done via a blank root password. That would normally give me the chills but it makes more sense when you consider that the project has only been around for a month. You can add in public ssh keys (after setting a root password) and cockpit has some options for attaching to a domain in the interface. That might be a hint to future kerberos support coming in future releases

### Wrapping Up

Both of these projects are definitely going to be on my radar over the coming months. I've looked for more ways to treat operating systems like a launching platform for VM's and containers over the past few years and these platforms seem to have the right idea.

If you want something a bit more fully functional right now and you're willing to do some additional work to configure your containers, give CoreOS a try. I really wish that CoreOS would do some more inventory management work for you so that _presence_ or _sidekick_ units wouldn't be necessary. The documentation is extensive but the CoreOS concepts are still difficult to grasp. If CoreOS gets more closely integrated with OpenStack or another automation platform, it could be a smash hit.

Project Atomic isn't production ready but it has a long runway ahead. If the project can match CoreOS on the functionality of etcd/fleet while adding on the concept of joined Docker containers, it could be a real success. Time will tell if it will stand alone or become the next version of OpenShift.

_I've been using these projects for about a month and I might not have used them to their fullest. Feel free to leave some comments if I've left something out or if there's something I really ought to review for a follow-up post._

 [1]: https://www.docker.io/
 [2]: https://coreos.com/
 [3]: http://www.projectatomic.io/
 [4]: http://www.freedesktop.org/wiki/Software/systemd/
 [5]: http://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
 [6]: https://coreos.com/docs/
 [7]: https://coreos.com/docs/running-coreos/cloud-providers/rackspace/
 [8]: https://coreos.com/docs/running-coreos/cloud-providers/rackspace/#cloud-config
 [9]: https://coreos.com/using-coreos/etcd/
 [10]: https://coreos.com/docs/launching-containers/launching/launching-containers-fleet/
 [11]: https://coreos.com/docs/launching-containers/launching/fleet-example-deployment/#service-files
 [12]: http://www.projectatomic.io/download/
 [13]: https://openshift.github.io/geard/
 [14]: https://www.openshift.com/blogs/geard-the-intersection-of-paas-docker-and-project-atomic
 [15]: https://openshift.github.io/geard/deploy_with_geard.html
 [16]: https://coreos.com/docs/cluster-management/setup/update-strategies/
 [17]: http://coreos.com/docs/cluster-management/debugging/install-debugging-tools/
 [18]: http://www.freedesktop.org/software/systemd/man/systemd-nspawn.html
 [19]: http://coreos.com/using-coreos/clustering/
 [20]: http://rpm-ostree.cloud.fedoraproject.org/#/
 [21]: https://fedoraproject.org/wiki/Changes/CockpitManagementConsole
 [22]: http://shipyard-project.com/
 [23]: http://www.projectatomic.io/blog/2014/04/build-your-own-atomic-host-on-fedora-20/
 [24]: http://linux-ima.sourceforge.net/
 [25]: http://selinuxproject.org/page/SVirt
