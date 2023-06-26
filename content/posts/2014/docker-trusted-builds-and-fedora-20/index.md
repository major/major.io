---
aliases:
- /2014/03/26/docker-trusted-builds-and-fedora-20/
author: Major Hayden
date: 2014-03-26 05:17:58
tags:
- containers
- docker
- fedora
- icanhazip
- linux
- lxc
- virtualization
- web
title: Docker, trusted builds, and Fedora 20
---

Docker is a hot topic in the Linux world at the moment and I decided to try out the new [trusted build process][3]. Long story short, you put your Dockerfile along with any additional content into your GitHub repository, link your GitHub account with Docker, and then fire off a build. The Docker index labels it as "trusted" since it was build from source files in your repository.

I set off to build a Dockerfile to provision a container that would run all of the [icanhazip][4] services. Getting httpd running was a little tricky, but I soon had a [working Dockerfile][5] that built and ran successfully on Fedora 20.

The trusted build process kicked off without much fuss and I found myself waiting for a couple of hours for my job to start. I was sad to see an error after waiting so long:

```
Installing : httpd-2.4.7-3.fc20.x86_64
error: unpacking of archive failed on file /usr/sbin/suexec: cpio: cap_set_file
```


Well, that's weird. It turns out that `cap_set_file` is part of libcap that sets filesystem capabilities based on the POSIX.1e standards. You can read up on capabilities in the [Linux kernel capabilities FAQ][6]. _(Special thanks to Andrew Clayton getting me pointed in the right direction there.)_

[Marek Goldmann][7] ran into this problem back in September 2013 and opened a [bug report][8]. Marek [proposed a change][9] to the Docker codebase that would remove setfcap from the list of banned capabilities in the LXC template used by docker. Another workaround would be to use the `-privileged` option to perform a build in privileged mode (available in docker 0.6+).

Both of those workarounds are unavailable when doing trusted builds with docker's index. Sigh.

I fired off an email to Docker's support staff and received a quick reply:

> Major,
>
> We are aware of this issue, and we are currently working on a fix, and we hope to have something we can start testing this week. I'm not sure when we will be able to roll out the fix, but we are hoping soon. Until then, there isn't anything you can do to work around it. Sorry for the inconvenience.
>
> If anything changes, we will be sure to let you know.
>
> Ken

It wasn't the answer I wanted but it's good to know that the issue is being worked. In the meantime, I'll push an untrusted build of the icanhazip Docker container up to the index for everyone to enjoy.

Stay tuned for updates.

_**UPDATED 2014-08-08:** Per Thomas' comment below, this has been [fixed upstream][10]._

 [1]: /wp-content/uploads/2014/03/docker-whale.png
 [2]: /wp-content/uploads/2012/01/fedorainfinity.png
 [3]: http://blog.docker.io/2013/11/introducing-trusted-builds/
 [4]: /icanhazip-com-faq/
 [5]: https://github.com/major/icanhaz/blob/master/docker/Dockerfile
 [6]: https://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.2/capfaq-0.2.txt
 [7]: http://fedoraproject.org/wiki/User:Goldmann
 [8]: https://bugzilla.redhat.com/show_bug.cgi?id=1012952
 [9]: https://bugzilla.redhat.com/attachment.cgi?id=804061&action=diff
 [10]: https://github.com/docker/docker/pull/5930