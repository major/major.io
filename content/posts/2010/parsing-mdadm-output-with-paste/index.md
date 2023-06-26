---
aktt_notify_twitter:
- false
aliases:
- /2010/06/14/parsing-mdadm-output-with-paste/
author: Major Hayden
date: 2010-06-14 14:05:57
tags:
- command line
- mdadm
- scripts
title: Parsing mdadm output with paste
---

My curiosity is always piqued when I find new ways to manipulate command line output in simple ways. While working on a solution to parse /proc/mdstat output, I stumbled upon the [paste][1] utility.

The [man page][2] offers a very simple description of its features:

> Write lines consisting of the sequentially corresponding lines from each FILE, separated by TABs, to standard output.

Here's an example of how it works. Let's say you want to parse some software raid output that looks like this:

<pre lang="html"># mdadm --brief --verbose --detail /dev/md0
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=00.90 UUID=7bea4601:d5a02f5c:2da69848:3184a367
   devices=/dev/sda1,/dev/sdb1</pre>

It would be handy if we had both on one line as that would make it easier to parse with a script. Of course, you can do this with utilities like awk and tr, but paste makes it so much easier:

<pre lang="html"># mdadm --brief --verbose --detail /dev/md0 | paste - -
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=00.90 UUID=7bea4601:d5a02f5c:2da69848:3184a367       devices=/dev/sda1,/dev/sdb1</pre>

By default, paste uses tabs to separate the lines, but you can use the `-d` argument to specify any delimiter you like:

<pre lang="html"># mdadm --brief --verbose --detail /dev/md0 | paste -d"*" - -
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=00.90 UUID=7bea4601:d5a02f5c:2da69848:3184a367*   devices=/dev/sda1,/dev/sdb1</pre>

 [1]: http://www.gnu.org/software/coreutils/manual/html_node/paste-invocation.html
 [2]: http://linux.die.net/man/1/paste