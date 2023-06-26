---
aliases:
- /2021/12/18/kerberos-logins-brave-linux/
author: Major Hayden
date: '2021-12-18'
summary: Brave recently changed how their browser reads managed policy configuration,
  but luckily the fix is an easy one. 🔧
tags:
- brave
- kerberos
- linux
title: Kerberos logins with Brave on Linux
coverCaption: |
  _Photo credit: [Erik Škof](https://unsplash.com/photos/jcP3grvVcPk)_
---

My primary browser flips back and forth between [Brave] and [Firefox] depending
on my current tasks, but [kerberos] logins are integral to my workflow at work
and also as a [Fedora] contributor. Kerberos provides a single sign on (SSO)
capability so you can authenticate one time and then perform lots of actions
against various targets without authenticating again.

Kerberos is a protocol that runs something like this:

1. You authenticate to an authentication server with username/password/2FA
2. That server forwards the authentication result to a key server
3. That key server gives you a ticket

From then on, you present your ticket to complete the authentication steps.
There's no need to provide your username, password, or two-factor
authentication once you have your ticket (for most implementations). When your
ticket expires, you authenticate once more, get a new ticket, and go on about
your day.

The real time-saver here is that your browser can handle kerberos tickets when
you authenticate to various services in your browser. However, you must tell
your browser about the sites you trust before you start handing over your
ticket. That's where something went wrong with Brave for me last week.

## The problem

I went through my usual `kinit` steps to get my kerberos tickets when I started
work in the morning, but I was prompted to authenticate to various sites when I
accessed them in my browser. Normally there's a short delay with a couple of
redirects through an SSO portal, but I was stuck staring at login screens even
though I had valid tickets.

You can double check your ticket validity with `klist -A` and sure enough, my
tickets were valid for several hours more. Firefox didn't have the issue and I
sailed through SSO logins on my usual sites.

Generally, Brave looks for managed policies that describe kerberos
authentication delegations in the usual spot where Chomium stores them:
`/etc/chromium/policies/managed`. My policies were there. For example, here's
the one I use for Fedora:

```console
$ cat /etc/chromium/policies/managed/fedora_kerberos.json
{
	"AuthServerAllowlist": "*.fedoraproject.org",
}
```

This configuration tells the browser that it can use kerberos authentication
with any system that matches `*.fedoraproject.org`. My configuration hasn't
changed in ages.

_Could it be Brave's fault?_ 🤔

## Some digging

I also noticed that Brave didn't have it's usual warning about my organization
having managed policies on the system, so Brave wasn't reading the
configurations at all. The first thing I needed to do was to see what Brave was
looking for during startup.

After closing all of my Brave windows, I used `strace` to dump what was
happening during startup:

```console
$ strace -f -o brave-strace.txt brave-browser
```

As soon as Brave fully appeared on screen, I closed it and stopped `strace`
with CTRL-c. It was time to see where Brave was looking for the configuration:

```console
$ grep policies brave-strace.txt
9917  stat("/etc/brave/policies/managed", {st_mode=S_IFDIR|0755, st_size=144, ...}) = 0
9917  openat(AT_FDCWD, "/etc/brave/policies/managed", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 14
```

What is this `/etc/brave`? It always looked for configuration in
`/etc/chromium`! 🤦🏻‍♂️

## Fixing it

I brought over the config from `/etc/chromium` into `/etc/brave` to see if that
would help:

```console
$ mkdir -p /etc/brave/policies/managed
$ sudo cp /etc/chromium/policies/managed/* /etc/brave/policies/managed/
```

After starting Brave one more time, I noticed the `Managed by your
organization` warning in the options menu again. I was then able to wander
around to various sites at work and within Fedora's infrastructure and my
kerberos SSO worked once again! 🎉

[Brave]: https://brave.com/
[Firefox]: https://www.mozilla.org/en-US/firefox/new/
[Kerberos]: https://en.wikipedia.org/wiki/Kerberos_(protocol)
[Fedora]: https://getfedora.org/