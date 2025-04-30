---
author: Major Hayden
date: '2023-10-13'
summary: >
  Here's a blog post to answer the question: Why do you write so much about CoreOS? 📦
tags:
  - containers
  - coreos
  - docker
  - fedora
  - linux
  - podman
title: How I learned to stop worrying and love the CoreOS
coverAlt: Glass jars of herbs on a shelf with labels of their contents
coverCaption: |
  Credit: [Heather McKean](https://unsplash.com/photos/1I9bMlIAIBM) via Unsplash
------

It's quite clear that I've been on a [CoreOS](/tags/coreos/) blogging streak lately.
I keep getting asked by people inside and outside my company about what makes CoreOS special and why I've switched over so many workloads to it.

The answer is pretty basic.
**It makes my life easier.**

I'm a Dad.
I'm on the PTC (Parent Teacher Club) at one of my children's schools.
I volunteer as an IT person for a non-profit.
I write software.
I have other time consuming hobbies, such as ham radio, reading, and becoming a longer distance runner[^running].

My available time for my own IT projects is **extremely limited** and CoreOS plays a part in keeping that part of my life as efficient as possible.

That's what this blog post is about!

# Updates

First and foremost, I love how CoreOS does updates.
I encourage you to [read the docs](https://docs.fedoraproject.org/en-US/fedora-coreos/auto-updates/) on this topic, but here's a short explanation:

1. Updates are automatically retrieved and they're loaded into a slot.
1. Your system reboots into the new update but your original OS tree remains in place.
1. Did the update boot? Awesome. You're good to go.
1. Did something break? The system reverts back to the known good tree.

In this way, it's a lot like your smartphone.

You have full control over when a node looks for an update and how often it checks for them.
Check out the [Zincati docs](https://coreos.github.io/zincati/usage/updates-strategy/) for tons of controls over updates and reboots.

Some of mine are timed so well that I set maintenance windows with my monitoring provider when I know an update might take place.
The updates come through, monitoring shuts off, the node reboots, and monitoring comes back.
The nodes almost always come back before the monitoring even alerts me.

It also removes the reminders I would set for myself to update packages and run reboots.
I know that my CoreOS nodes will do this automatically, so I don't need to think about it.

Also, updates are rarely ever impactful to my workloads since all of them are running inside containers.
My containers come right back up as soon as the node finishes its reboot.

# Toolbox

To be fair, you can get toolbox running on lots of different Linux distributions outside of CoreOS, but that's the first place I ever used it.
Toolbox, also called [toolbx](https://containertoolbx.org/), gives you a utility container on your CoreOS node for all kinds of adminsitrative and diagnostic capabilities.

You might need a certain package for diagnosting a hardware issue or you might want to install some helpful utilities for the command line.
Do that in a toolbox container.
Just run `toolbox enter` and if you've never created a toolbox container before, you'll get a Fedora container that matches your CoreOS release.

But it gets better.

Toolbox automatically saves your container when you're done with it so all of your installed packages stay there for next time.
Also, these containers have seamless access to anything you have in your home directory, including sockets.
You're running inside a container, but it's almost like you're running on the host itself inside your home directory.
You get the best of both worlds.

Don't want Fedora?
You have lots of distribution options through toolbox.
Read the details on [custom images](https://containertoolbx.org/install/) to create your own!

# Layering

Okay, there are those situations where you really want a package on CoreOS and toolbox might not be sufficient.
My muscle memory for `vim` is so strong and CoreOS only comes with `vi`.

You have a couple of options here:

* Run `sudo rpm-ostree install vim`, reboot, and you have `vim`
* Run `sudo rpm-ostree install --apply-live vim` and you have `vim` right now!
  _(And it's there after a reboot as well.)_

When a new update comes down for the base OS from CoreOS, any packages you've added will be layered on the base image and available after a reboot.
Layering is generally chosen as a last resort option for adding packages to the system but you shouldn't run into issues if you're installing small utilities or command line tools.

# Declarative provisioning

If you've provisioned Linux distributions on cloud instances in the past, you've likely provided metadata that cloud-init uses to provision your system.
CoreOS has something that acts a lot earlier in the boot process and has more power to get things done: [ignition](https://coreos.github.io/ignition/).

There's a handy [butane](https://coreos.github.io/butane/) file forma that you use for writing your configuration.
You use the `butane` utility to get it into ignition format.
The ignition format is highly compressed to ensure you can fit your configuration into most cloud providers' metadata fields.

For a real example of what you can do with ignition, check out my [quadlets post](/p/quadlets-replace-docker-compose/) where I provisioned an entire Wordpress container stack using a single ignition file.

There's lots of documentation for [writing butane configuration](https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/) files for common situations.
It's easy to add files, configure Wireguard, set up users, and launch containers immediately on the first boot.

# Pets and cattle

CoreOS works well for systems that I only need online for a short time.
These might be situations where I need to test a few containers and throw it away.
There's no OS to mess with and no updates to worry about.

It also works well for systems that I keep online for a long time.
I have a few physical systems at home that run CoreOS and they've been extremely stable.
I also have cloud instances on Hetzner, VULTR, and Digital Ocean that have run CoreOS for months without issues.

# More questions?

Feel free to [send me an email](mailto:major+coreos@mhtx.net) or [drop me a toot on Mastodon](https://tootloop.com/@major).
I'll update this post if I get some good ones!

[^running]: Completing a half marathon without keeling over is the current goal! 👟
