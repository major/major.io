---
title: Automatic package updates in CentOS 6
author: Major Hayden
type: post
date: 2012-09-21T13:21:01+00:00
url: /2012/09/21/automatic-package-updates-in-centos-6/
dsq_thread_id:
  - 3642807073
categories:
  - Blog Posts
tags:
  - centos
  - security
  - sysadmin
  - yum

---
Automating package updates in CentOS 6 is a quick process and it ensures that your system receives the latest available security patches, bugfixes and enhancements. Although it's easy and available right from yum on a normal CentOS 6 system, I still find that many people aren't aware of it.

Before you enable automatic updates, you'll want to ensure that you're excluding certain packages which may be integral to your system. You can either make a list of those packages now or configure the automated updates so that you're emailed a report of what needs to be installed rather than having those packages installed automatically.

To get started, install yum-cron:

```
yum -y install yum-cron
```

By default, it's configured to download all of the available updates and apply them immediately after downloading. Reports will be emailed to the root user on the system. To change these settings, just open `/etc/sysconfig/yum-cron` in your favorite text editor and adjust these lines:

```ini
# Default - check for updates, download, and apply
CHECK_ONLY=no
DOWNLOAD_ONLY=no

# Download the updates and email a report
CHECK_ONLY=no
DOWNLOAD_ONLY=yes

# Don't download the updates, just email a report
CHECK_ONLY=yes
DOWNLOAD_ONLY=no
```

As mentioned earlier, if you want to exclude certain packages from these updates, just edit your `/etc/yum.conf` and add:

```ini
exclude=kernel* mysql*
```

The cron jobs from the `yum-cron` package are active immediately after installing the package and there's no extra configuration necessary. The job will be run when your normal daily cron jobs are set to run.
