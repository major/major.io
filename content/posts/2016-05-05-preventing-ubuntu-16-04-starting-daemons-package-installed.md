---
title: Preventing Ubuntu 16.04 from starting daemons when a package is installed
author: Major Hayden
type: post
date: 2016-05-05T15:54:27+00:00
url: /2016/05/05/preventing-ubuntu-16-04-starting-daemons-package-installed/
dsq_thread_id:
  - 4802584995
categories:
  - Blog Posts
tags:
  - security
  - systemd
  - ubuntu

---
I've gone on some mini-rants in [other][1] [posts][2] about starting daemons immediately after they're installed in Ubuntu and Debian. Things are a little different in Ubuntu 16.04 and I thought it might be helpful to share some tips for that release.

Before we do that, let's go over something. I still don't understand why this is a common practice within Ubuntu and Debian.

Take a look at the `postinst-systemd-start` script within the `init-systems-helpers` package ([source link][3]):

```shell
if [ -d /run/systemd/system ]; then
    systemctl --system daemon-reload >/dev/null || true
    deb-systemd-invoke start #UNITFILES# >/dev/null || true
fi
```

The `daemon-reload` is totally reasonable. We must tell systemd that we just deployed a new unit file or it won't know we did it. However, the next line makes no sense. Why would you immediately force the daemon to start (or restart)? The `deb-systemd-invoke` script does check to see if the unit is disabled before taking action on it, which is definitely a good thing. However, this automatic management of running daemons shouldn't be handled by a package manager.

If you don't want your package manager handling your daemons, you have a few options:

## The policy-rc.d method

This method involves creating a script called `/usr/sbin/policy-rc.d` with a special exit code:

```
# echo -e '#!/bin/bash\nexit 101' > /usr/sbin/policy-rc.d
# chmod +x /usr/sbin/policy-rc.d
# /usr/sbin/policy-rc.d
# echo $?
101
```

This script is checked by the `deb-systemd-invoke` script in the `init-systems-helpers package` ([source link][4]). As long as this script is in place, dpkg triggers won't cause daemons to start, stop, or restart.

You can start your daemon at any time with `systemctl start service_name` whenever you're ready.

## The systemd mask method

If you need to prevent a single package from starting after installation, you can use systemd's [mask feature][5] for that. When you run `systemctl mask nginx`, it will symlink `/etc/systemd/system/nginx.service` to `/dev/null`. When systemd sees that, it won't start the daemon.

However, since the package isn't installed yet, we can just mask it with a symlink:

```
# ln -s /dev/null /etc/systemd/system/nginx.service
```

You can install nginx now, configure it to meet your requirements, and start the service. Just run:

```
# systemctl enable nginx
# systemctl start nginx
```

 [1]: https://major.io/2015/10/14/what-i-learned-while-securing-ubuntu/
 [2]: https://major.io/2014/06/26/install-debian-packages-without-starting-daemons/
 [3]: https://github.com/Debian/debhelper/blob/master/autoscripts/postinst-systemd-start
 [4]: https://anonscm.debian.org/git/collab-maint/init-system-helpers.git/tree/script/deb-systemd-invoke#n70
 [5]: http://0pointer.de/blog/projects/three-levels-of-off
