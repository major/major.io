---
author: Major Hayden
date: '2023-05-25'
summary: |
  CoreOS provides a fast track to running containers with a light weight immutable OS
  underneath. This doesn't mean that you can't keep it around as a pet instance. 🐕
tags:
  - cloud
  - containers
  - coreos
  - docker
  - fedora
  - podman
  - toolbox
  - wireguard
title: CoreOS as a pet
---

Anyone working with containers has likely heard of [CoreOS](https://fedoraproject.org/coreos/) by this point
Haven't heard about it?
Don't despair.
I'll catch you up on what you missed.

Fedora CoreOS offers a really fast pathway to running containers on hardware, in virtual machines, or in clouds.
It delivers a lightweight operating system with all of the container technology that you need for running simple containers or launching a kubernetes deployment.

But that's not the best part.

CoreOS really shines due to its **immutable OS layer**[^mostly_immutable].
The OS underneath your containers ships as a single unit and it automatically updates itself much like your mobile phone.
An update rolls down, CoreOS sets it up as a secondary OS, reboots into that new update, and rolls back to the original one if there were any issues.

Many people use CoreOS as the workhorse underneath kubernetes.
Red Hat uses it underneath [OpenShift](https://docs.openshift.com/container-platform/4.13/installing/installing_bare_metal/installing-bare-metal.html#creating-machines-bare-metal_installing-bare-metal) as well.
It's even supported by the super light weight kubernetes distribution [k3s](https://k3s.io/).

But can you use CoreOS as a _pet_ type instance that you use and maintain for long periods of time just like any other server?
**Absolutely!**

# What's this _pet_ stuff about?

Whether you like it or not, there's a cattle versus pets paradigm that took hold in the world of IT at some point.
The basic ideas are these:

* When you take care of cattle, you take care of them as a group.
  Losing one or more of them would make you sad, but you know you have many others.
* As for pets, you spend a lot of time taking care of them and playing with them.
  If you lost one, it would be devastating.

A fleet of web servers could be treated like cattle.
Keep lots of them online and replace any instances that have issues.

On the other hand, databases or tier zero systems (everyone feels if it they went down) are like pets.
You carefully build, maintain, and monitor these.

# How does CoreOS fit in?

Many people do use CoreOS as a container hosting platform as part of a bigger system.
It works really well for that.
But it's great as a regular cloud server, too.

You can run a single node CoreOS deployment and manage containers via the tools that you know and love.
For example, [docker-compose](https://github.com/docker/compose) works great on CoreOS.
I even used it to host my own [Mastodon deployment](/p/self-hosted-mastodon-second-try/).

You can also load up more user-friendly tools such as [portainer](https://www.portainer.io/) to manage containers in a browser.

# My development tools are missing!

😱 No `vim`?
This is too minimal!
**What are we going to do?**

Luckily CoreOS comes with [toolbox](https://github.com/containers/toolbox). 🧰

Toolbox gives you the ability to run a utility container on the system with some handy benefits:

> Toolbox environments have seamless access to the user's home directory, the Wayland and X11 sockets, networking (including Avahi), removable devices (like USB sticks), systemd journal, SSH agent, D-Bus, ulimits, /dev and the udev database, etc..

This means that the toolbox feels like a second OS on the system and it has all of the elevated privileges that you need to do your work.
Simply run `toolbox enter`, follow the prompts, and you'll end up with a Fedora toolbox that matches your CoreOS version.
Need a different version, such as Fedora Rawhide?
Just specify the Fedora release you want on the prompt:

```console
$ toolbox enter --release 39     
No toolbox containers found. Create now? [y/N] y
Image required to create toolbox container.
Download registry.fedoraproject.org/fedora-toolbox:39 (500MB)? [y/N]: y

Welcome to the Toolbox; a container where you can install and run
all your tools.

 - Use DNF in the usual manner to install command line tools.
 - To create a new tools container, run 'toolbox create'.

For more information, see the documentation.

⬢[major@toolbox ~]$ 
```

Look at the `toolbox create --help` output to see how to create lots of different toolbox containers with different names and releases.
If you go overboard and need to delete some toolboxes, just list your toolboxes with `toolbox list` and follow it up with `toolbox rm`.

# My tool won't work in the toolbox.

Some applications have issues running inside a container, even one that has elevated privileges on the system.
CoreOS offers an option for layering packages on top of the underlying immutable OS.

Simply run `rpm-ostree install PACKAGE` to layer a package on top of the OS.
When `rpm-ostree` runs, it creates a new layer and sets that layer to be active on the next boot.
That means that you need to reboot before you can use the package.

Don't want to reboot?
There's another option, but I recommend against it if you can avoid it[^no_live].

You can apply a package layer _live_ on the system without a reboot with the `--apply-live` flag.
Installing a package like [mtr](https://github.com/traviscross/mtr) would look like this:

```
$ sudo rpm-ostree install --apply-live mtr
```

As soon as `rpm-ostree` finishes its work, `mtr` should be available on the system for you to use.

# How do updates work?

There are two main technologies at work here.

First, [zincati](https://github.com/coreos/zincati) checks for updates to your immutable OS tree.
It runs on a [configurable schedule](https://docs.fedoraproject.org/en-US/fedora-coreos/auto-updates/#_os_update_finalization) that you can adjust based on your preferences.

Second, `rpm-ostree` handles the OS layers and switches between them at boot time.
If you're running off layer A and an update comes down (layer B), that layer is written to the disk and activated on the next boot.
Should there be any issues booting up layer B later, `rpm-ostree` switches the system back to layer A.
In these situations, your downtime might be extended a bit due to two reboots.
Your system will come back up with the original OS layer activated.

You also get a choice of [update streams](https://docs.fedoraproject.org/en-US/fedora-coreos/update-streams/).
Want to live a bit more on the edge?
Go for _next_ or _testing_.
You're on the _stable_ stream by default.

Although I haven't landed in this situation, it's possible that the system boots into a new update where you notice a problem that doesn't affect the boot.
You can [manually roll back](https://docs.fedoraproject.org/en-US/fedora-coreos/auto-updates/#_manual_rollbacks) to fix it.

# I have more questions.

Your first stop should be the [Fedora CoreOS docs](https://docs.fedoraproject.org/en-US/fedora-coreos/).
There are also lots of ways to [contact the development team and talk with the community](https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started/#_getting_in_touch).

Love the idea of an immutable OS but you wish you had it for your desktop or laptop?
Go check out [Fedora Silverblue](https://fedoraproject.org/silverblue/). 💻

[^mostly_immutable]: Okay, so it's _mostly_ immutable.
  You can edit configuration in `/etc` and you can layer more packages on top of the base OS layer if you need them.
  However, CoreOS maintainers discourage adding layered packages if you can avoid it.

[^no_live]: When you apply some packages and make them available immediately, you may lose track of which ones were applied live and which ones are available on the next reboot.
  Things can get a bit confusing if you suddenly change your mind about applying a package live or not.

_Cover image: [Hans Isaacson](https://unsplash.com/photos/bQTVoJHrkO0) on Unsplash_