---
title: Install testing kernels in Fedora
author: Major Hayden
type: post
date: 2018-02-28T13:53:48+00:00
url: /2018/02/28/install-testing-kernels-in-fedora/
featured_image: /wp-content/uploads/2018/02/120928-F-YV474-917.jpg
categories:
  - Blog Posts
tags:
  - centos
  - dnf
  - fedora
  - kernel
  - linux
  - testing
  - yum

---
![1]

If you're on the latest Fedora release, you're already running lots of modern packages. However, there are those times when you may want to help with testing efforts or try out a new feature in a newer package.

Most of my systems have the `updates-testing` repository enabled in one way or another. This repository contains packages that package maintainers have submitted to become the next stable package in Fedora. For example, if there is a bug fix for nginx, the package maintainer submits the changes and publish a release. That release goes into the testing repositories and must sit for a waiting period or receive sufficient karma ("works for me" responses) to move into stable repositories.

## Getting started

One of the easiest ways to get started is to allow a small amount of packages to be installed from the testing repository on a regular basis. Fully enabling the testing repository for all packages can lead to trouble on occasion, especially if a package maintainer discovers a problem and submits a new testing package.

To get started, open `/etc/yum.repos.d/fedora-updates-testing.repo` in your favorite text editor (using `sudo`). This file tells yum and dnf where it should look for packages. The stock testing repository configuration looks like this:

```ini
[updates-testing]
name=Fedora $releasever - $basearch - Test Updates
failovermethod=priority
#baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/testing/$releasever/$basearch/
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-testing-f$releasever&arch=$basearch
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
```

By default, the repository is not enabled (`enabled=0`).

In this example, let's consider a situation where you want to test the latest kernel packages as soon as they reach the testing repository. We need to make two edits to the repository configuration:

  * `enabled=1` - Allow yum/dnf to use the repository
  * `includepkgs=kernel*` - Only allow packages matching `kernel*` to be installed from the testing repository

The repository configuration should now look like this:

```ini
[updates-testing]
name=Fedora $releasever - $basearch - Test Updates
failovermethod=priority
#baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/testing/$releasever/$basearch/
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-testing-f$releasever&arch=$basearch
enabled=1
repo_gpgcheck=0
type=rpm
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
includepkgs=kernel*
```

## Getting testing packages

Running `dnf upgrade kernel*` should now pull a kernel from the `updates-testing` repository. You can verify this by checking the `Repository` column in the dnf output.

If you feel more adventurous later, you can add additional packages (separated by spaces) to the `includepkgs` line. The truly adventurous users can leave the repo enabled but remove `includepkgs` altogether. This will pull all available packages from the testing repository as soon as they are available.

## Package maintainers need feedback!

One final note: **package maintainers need your feedback** on packages. Positive or negative feedback is very helpful. You can search for the package on [Bodhi][2] and submit feedback there, or use the `fedora-easy-karma` script via the `fedora-easy-karma` package. The script will look through your installed package list and query you for feedback on each one.

Submitting lots of feedback can earn you some [awesome Fedora Badges][3]!

_Photo credit: [US Air Force][4]_

 [1]: /wp-content/uploads/2018/02/120928-F-YV474-917.jpg
 [2]: https://bodhi.fedoraproject.org/
 [3]: https://badges.fedoraproject.org/badge/in-search-of-the-bull-tester-i
 [4]: http://www.arpc.afrc.af.mil/News/Article-Display/Article/365815/a-wish-come-true-colorado-native-becomes-cadet-for-a-day/
