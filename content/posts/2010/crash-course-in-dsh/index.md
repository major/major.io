---
aliases:
- /2010/01/20/crash-course-in-dsh/
author: Major Hayden
date: 2010-01-20 14:47:56
tags:
- command line
- dsh
- puppet
- ssh
- sysadmin
title: Crash course in dsh
---

Thanks to a recommendation from [Michael][1] and [Florian][2], I've been using [dsh][3] with a lot of success for quite some time. In short, dsh is a small application which will allow you to run commands across many servers via ssh very quickly.

You may be wondering: "Why not just use ssh in a for loop?" Sure, you could do something like this in bash:

```


But dsh allows you to do this:

```


In addition, dsh allows you to run the commands concurrently (-c) or one after the other (-w). You can tell it to prepend each line with the machine's name (-M) or it can omit the machine name from the output (-H). If you need to pass extra options, such as which ssh key to use, or an alternative port, you can do that as well (-o). All of these command line options can be tossed into a configuration file if you have a default set of options you prefer.

Another thing that makes dsh more powerful is the groups feature. Let's say you have three groups of servers - some are in California, others in Texas, and still others in New York. You could make three files for the groups:

  * ~/.dsh/group/california
  * ~/.dsh/group/texas
  * ~/.dsh/group/newyork

Inside each file, you just need to list the hosts one after the other. Here's the `~/.dsh/group/texas` group file:

```
db1.tx.mydomain.com
db2.tx.mydomain.com
web1.tx.mydomain.com
web2.tx.mydomain.com
#web3.tx.mydomain.com
```


As you can see, dsh handles comments in the hosts file. In the above example, the web3 server will be skipped since it's prepended with a comment. Let's say you want to check the uptime on all of the Texas servers as fast as possible:

```


That will run the `uptime` command on all of the servers in the Texas group concurrently. If you need to run it on two groups at once, just pass another group (eg. `-g texas -g california`) as an argument. You can also run the commands against all of your groups (-a).

The dsh command can really help you if you need to gather information or run simple commands on many remote servers. If you find yourself using it often for systems management, you may want to consider something like [puppet][4].

 [1]: http://twitter.com/mshuler
 [2]: http://twitter.com/pandemicsyn
 [3]: http://www.netfort.gr.jp/~dancer/software/dsh.html.en
 [4]: http://reductivelabs.com/products/puppet/