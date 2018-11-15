---
title: Installing the mysql gem in Fedora 11 64-bit
author: Major Hayden
type: post
date: 2009-08-07T18:57:22+00:00
url: /2009/08/07/installing-the-mysql-gem-in-fedora-11-64-bit/
dsq_thread_id:
  - 3678960123
categories:
  - Blog Posts

---
On some systems, getting the mysql gem to build can be a little tricky. Fedora 11 x86_64 will require a bit of extra finesse to get the gem installed. First off, ensure that you've installed the `mysql-devel` package:

<pre lang="html"># yum -y install mysql-devel</pre>

I'll assume that you already installed the `rubygems` package. You can install the mysql gem like this:

<pre lang="html"># gem install mysql -- --with-mysql-config=/usr/bin/mysql_config
Building native extensions.  This could take a while...
Successfully installed mysql-2.7
1 gem installed
Installing ri documentation for mysql-2.7...
Installing RDoc documentation for mysql-2.7...</pre>
