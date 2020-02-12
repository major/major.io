---
title: Keeping bwm-ng 0.6 functional on Fedora 19
author: Major Hayden
type: post
date: 2013-09-20T02:51:31+00:00
url: /2013/09/19/keeping-bwm-ng-0-6-functional-on-fedora-19/
dsq_thread_id:
  - 3670162883
categories:
  - Blog Posts
tags:
  - fedora
  - networking
  - rpm
  - sysadmin
  - yum

---
If you run [bwm-ng][1] and you've run a `yum upgrade` lately on Fedora 19, you have probably seen this:

```
---> Package libstatgrab.x86_64 0:0.17-4.fc19 will be updated
--> Processing Dependency: libstatgrab.so.6()(64bit) for package: bwm-ng-0.6-10.fc19.x86_64
--> Finished Dependency Resolution
Error: Package: bwm-ng-0.6-10.fc19.x86_64 (@fedora)
           Requires: libstatgrab.so.6()(64bit)
           Removing: libstatgrab-0.17-4.fc19.x86_64 (@fedora)
               libstatgrab.so.6()(64bit)
           Updated By: libstatgrab-0.90-1.fc19.x86_64 (updates)
              ~libstatgrab.so.9()(64bit)
 You could try using --skip-broken to work around the problem
 You could try running: rpm -Va --nofiles --nodigest
```

The error message mentions that libstatgrab needs to be updated to version 0.90 (released in August) but bwm-ng requires version 0.17 of libstatgrab. I've emailed the author of bwm-ng to ask if he plans to update it to use the newer libstatgrab version but I haven't heard back yet. Two Fedora bugs are open for the package in Red Hat's Bugzilla.

There are two available workarounds:

**Skip the libstatgrab update just this one time**

You can skip the libstatgrab update for one run of yum by doing the following:

```
yum upgrade --skip-broken
```

However, this error will pop up again the next time you run an upgrade with yum. It will also derail your automatic updates with yum-updatesd (if you use it).

**Exclude the libstatgrab package from updates**

In your `/etc/yum.conf`, add this line:

```
exclude=libstatgrab
```

That will prevent libstatgrab from receiving any updates until you remove it from the exclude line. Of course, when Fedora 20 rolls around, this line could cause problems.

 [1]: http://www.gropp.org/?id=projects&sub=bwm-ng
