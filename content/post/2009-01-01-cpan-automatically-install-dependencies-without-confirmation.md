---
title: 'CPAN: Automatically install dependencies without confirmation'
author: Major Hayden
type: post
date: 2009-01-02T01:44:51+00:00
url: /2009/01/01/cpan-automatically-install-dependencies-without-confirmation/
aktt_notify_twitter:
  - no
dsq_thread_id:
  - 3642805471
categories:
  - Blog Posts
tags:
  - cpan
  - perl

---
I enjoy using [CPAN][1] because it installs Perl modules with a simple interface, fetches dependencies, and warns you when things are about to end badly. However, one of my biggest complaints is when it constantly confirms installing dependencies. While this is an annoyance if you have to install a module with many dependencies (or if you're working with CPAN on a new server), you can tell CPAN to automatically confirm the installation of dependencies.

To do this, simply bring up a CPAN shell:

```


Run these two commands in the CPAN shell:

```
o conf prerequisites_policy follow
o conf commit</pre>

Now, exit the CPAN shell, start the CPAN shell, and try to install a module that you need. All dependencies will be automatically confirmed, downloaded and installed.

The first line sets your dependency policy to _follow_ rather than _ask_ (the default). The second line tells CPAN to write the changes to your user's CPAN configuration file to make them permanent.

A big thanks goes out to [Lee Hambley][2] for the [fix][3].

**WARNING:** _There are some occasions where you would not want to install dependencies from CPAN. Examples of these situations are when your operating system's package manager (yum, up2date, apt-get, aptitude, etc) has installed Perl modules in an alternative location or when you have manually installed modules in a non-standard way. I'm a Red Hat guy, and these problems rarely arise on Red Hat/Fedora systems, but your mileage may vary._

 [1]: http://www.cpan.org/
 [2]: http://lee.hambley.name/about
 [3]: http://lee.hambley.name/2008/05/cpan-automatically-accept-dependencies
