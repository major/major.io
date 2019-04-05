---
title: Inspecting OpenShift cgroups from inside the pod
author: Major Hayden
type: post
date: "2019-04-05"
slug: inspecting-openshift-cgroups-from-inside-the-pod
twitter:
  card: "summary_large_image"
  site: "@majorhayden"
  title: Inspecting OpenShift cgroups from inside the pod
  image: images/2019-04-05-inspecting-cgroups.jpg
categories:
  - Blog Posts
tags:
  - openshift
  - ansible
  - security
  - linux
---

![walking_through_rock_valley]

My team at Red Hat builds a lot of kernels in OpenShift pods as part of our
work with the [Continuous Kernel Integration (CKI)] project. We have lots of
different pod sizes depending on the type of work we are doing and our GitLab
runners spawn these pods based on the tags in our GitLab CI pipeline.

## Compiling with `make`

When you compile a large software project, such as the Linux kernel, you can
use multiple CPU cores to speed up the build. GNU's `make` does this with the
`-j` argument. Running `make` with `-j10` means that you want to run 10 jobs
while compiling. This would keep 10 CPU cores busy.

Setting the number too high causes more contention from the CPU and can
reduce performance. Setting the number too low means that you are spending
more time compiling than you would if you used all of your CPU cores.

Every once in a while, we adjusted our runners to use a different amount of
CPUs or memory and then we had to adjust our pipeline to reflect the new CPU
count. This was time consuming and error prone.

Many people just use `nproc` to determine the CPU core count. It works well
with make:

```
make -j$(nproc)
```

## Problems with containers

The handy `nproc` doesn't work well for OpenShift. If you start a pod on
OpenShift and limit it to a single CPU core, `nproc` tells you something very
wrong:

```
$ nproc
32
```

We applied the single CPU limit with OpenShift, so what's the problem? The
issue is how `nproc` looks for CPUs. Here's a snippet of `strace` output:

```
sched_getaffinity(0, 128, [0, 1, 2, 3, 4, 5]) = 8
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x6), ...}) = 0
write(1, "6\n", 26
)                      = 2
```

The [sched_getaffinity] syscall looks to see which CPUs are allowed to run
the process and returns a count of those. OpenShift doesn't prevent us from
seeing the CPUs of the underlying system (the VM or bare metal host
underneath our containers), but it uses cgroups to limit how much CPU time we
can use.

## Reading cgroups

Getting cgroup data is easy! Just change into the `/sys/fs/cgroup/` directory
and look around:

```
$ cd /sys/fs/cgroup/
$ ls -al cpu/
ls: cannot open directory 'cpu/': Permission denied
```

**Ouch.** OpenShift makes this a little more challenging. We're not allowed to
wander around in the land of cgroups without a map to exactly what we want.

My Fedora workstation shows a bunch of CPU cgroup settings:

```
$ ls -al /sys/fs/cgroup/cpu/
total 0
dr-xr-xr-x.  2 root root   0 Apr  5 01:40 .
drwxr-xr-x. 14 root root 360 Apr  5 01:40 ..
-rw-r--r--.  1 root root   0 Apr  5 13:08 cgroup.clone_children
-rw-r--r--.  1 root root   0 Apr  5 01:40 cgroup.procs
-r--r--r--.  1 root root   0 Apr  5 13:08 cgroup.sane_behavior
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.stat
-rw-r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage_all
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage_percpu
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage_percpu_sys
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage_percpu_user
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage_sys
-r--r--r--.  1 root root   0 Apr  5 13:08 cpuacct.usage_user
-rw-r--r--.  1 root root   0 Apr  5 09:10 cpu.cfs_period_us
-rw-r--r--.  1 root root   0 Apr  5 13:08 cpu.cfs_quota_us
-rw-r--r--.  1 root root   0 Apr  5 09:10 cpu.shares
-r--r--r--.  1 root root   0 Apr  5 13:08 cpu.stat
-rw-r--r--.  1 root root   0 Apr  5 13:08 notify_on_release
-rw-r--r--.  1 root root   0 Apr  5 13:08 release_agent
-rw-r--r--.  1 root root   0 Apr  5 13:08 tasks
```

OpenShift uses the [Completely Fair Scheduler (CFS)] to limit CPU time. Here's a quick excerpt from the [kernel documentation]:

> Quota and period are managed within the cpu subsystem via cgroupfs.
>
> cpu.cfs_quota_us: the total available run-time within a period (in microseconds)
> cpu.cfs_period_us: the length of a period (in microseconds)
> cpu.stat: exports throttling statistics [explained further below]
>
> The default values are:
> 	cpu.cfs_period_us=100ms
> 	cpu.cfs_quota=-1
>
> A value of -1 for cpu.cfs_quota_us indicates that the group does not have any
> bandwidth restriction in place, such a group is described as an unconstrained
> bandwidth group.  This represents the traditional work-conserving behavior for
> CFS.
>
> Writing any (valid) positive value(s) will enact the specified bandwidth limit.
> The minimum quota allowed for the quota or period is 1ms.  There is also an
> upper bound on the period length of 1s.  Additional restrictions exist when
> bandwidth limits are used in a hierarchical fashion, these are explained in
> more detail below.
>
> Writing any negative value to cpu.cfs_quota_us will remove the bandwidth limit
> and return the group to an unconstrained state once more.
>
> Any updates to a group's bandwidth specification will result in it becoming
> unthrottled if it is in a constrained state.

Let's see if inspecting `cpu.cfs_quota_us` can help us:

```
$ cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us
10000
```

Now we're getting somewhere. But what does *10000* mean here? OpenShift
operates on the concept of *millicores* of CPU time, or 1/1000 of a CPU. 500
millicores is half a CPU and 1000 millicores is a whole CPU.

The pod in this example is assigned 100 millicores. Now we know that we can
take the output of `/sys/fs/cgroup/cpu/cpu.cfs_quota_us`, divide by 100, and
get our millicores.

We can make a script like this:

```bash
CFS_QUOTA=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
if [ $CFS_QUOTA -lt 100000 ]; then
  CPUS_AVAILABLE=1
else
  CPUS_AVAILABLE=$(expr ${CFS_QUOTA} / 100 / 1000)
fi
echo "Found ${CPUS_AVAILABLE} CPUS"
make -j${CPUS_AVAILABLE} ...
```

The script checks for the value of the quota and divides by 100,000 to get
the number of cores. If the share is set to something less than 100,000, then
a core count of 1 is assigned. *(Pro tip: `make` does not like being told to
compile with zero jobs.)*

## Reading memory limits

There are other limits you can read and inspect in a pod, including the
available RAM. As we found with `nproc`, `free` is not very helpful:

```bash
# An OpenShift pod with 200MB RAM
$ free -m
              total        used        free      shared  buff/cache   available
Mem:          32008       12322         880          31       18805       19246
Swap:             0           0           0
```

But the cgroups tell the truth:

```
$ cat /sys/fs/cgroup/memory/memory.limit_in_bytes
209715200
```

If you run Java applications in a container, like Jenkins (or Jenkins
slaves), be sure to use the `-XX:+UseCGroupMemoryLimitForHeap` option. That
will cause Java to look at the cgroups to determine its heap size.

[walking_through_rock_valley]: /images/2019-04-05-inspecting-cgroups.jpg
[Continuous Kernel Integration (CKI)]: https://cki-project.org/
[sched_getaffinity]: https://linux.die.net/man/2/sched_getaffinity
[Completely Fair Scheduler (CFS)]: https://en.wikipedia.org/wiki/Completely_Fair_Scheduler
[kernel documentation]: https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt
