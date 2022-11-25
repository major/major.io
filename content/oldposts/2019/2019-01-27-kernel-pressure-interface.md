---
title: Using the pressure stall information interface in kernel 4.20
author: Major Hayden
date: "2019-01-27"
slug: using-the-pressure-stall-information-interface-in-kernel-4.20
tags:
  - performance
  - fedora
  - linux
---

![pressure_cooker]

Fedora 29 now has kernel 4.20 available and it has [lots of new features].
One of the more interesting and easy to use features is the [pressure stall
information] interface.

## Load average

We're all familiar with the [load average] measurement on Linux machines,
even if the numbers do seem a bit cryptic:

```text
$ w
 10:55:46 up 11 min,  1 user,  load average: 0.42, 0.39, 0.26
```

The numbers denote how many processes were active over the last one, five and
15 minutes. In my case, I have a system with four cores. My numbers above
show that less than one process was active in the last set of intervals. That
means that my system isn't doing very much and processes are not waiting in
the queue.

However, if I begin compiling a kernel with eight threads (double my core
count), the numbers change dramatically:

```text
$ w
 11:00:28 up 16 min,  1 user,  load average: 4.15, 1.89, 0.86
```

The one minute load average is now over four, which means some processes are
waiting to be served on the system. This makes sense because I am using eight
threads to compile a kernel on a system with four cores.

## More detail

We assume that the CPU is the limiting factor in the system since we know
that compiling a kernel takes lots of CPU time. We can verify (and quantify) that with the pressure stall information available in 4.20.

We start by taking a look in `/proc/pressure`:

```text
$ head /proc/pressure/*
==> /proc/pressure/cpu <==
some avg10=71.37 avg60=57.25 avg300=23.83 total=100354487

==> /proc/pressure/io <==
some avg10=0.17 avg60=0.13 avg300=0.24 total=8101378
full avg10=0.00 avg60=0.01 avg300=0.16 total=5866706

==> /proc/pressure/memory <==
some avg10=0.00 avg60=0.00 avg300=0.00 total=0
full avg10=0.00 avg60=0.00 avg300=0.00 total=0
```

But what do these numbers mean? The shortest explanation is in the patch
itself:

> PSI aggregates and reports the overall wallclock time in which the
> tasks in a system (or cgroup) wait for contended hardware resources.

The numbers here are percentages, not time itself:

> The averages give the percentage of walltime in which one or more
> tasks are delayed on the runqueue while another task has the
> CPU. They're recent averages over 10s, 1m, 5m windows, so you can tell
> short term trends from long term ones, similarly to the load average.

We can try to apply some I/O pressure by making a big tarball of a kernel
source tree:

```text
$ head /proc/pressure/*
==> /proc/pressure/cpu <==
some avg10=1.33 avg60=10.07 avg300=26.83 total=262389574

==> /proc/pressure/io <==
some avg10=40.53 avg60=13.27 avg300=3.46 total=20451978
full avg10=37.44 avg60=12.40 avg300=3.21 total=16659637

==> /proc/pressure/memory <==
some avg10=0.00 avg60=0.00 avg300=0.00 total=0
full avg10=0.00 avg60=0.00 avg300=0.00 total=0
```

The CPU is still under some stress here, but the I/O is now the limiting
factor.

The output also shows a `total=` number, and that is explained in the patch
as well:

> The total= value gives the absolute stall time in microseconds. This
> allows detecting latency spikes that might be too short to sway the
> running averages. It also allows custom time averaging in case the
> 10s/1m/5m windows aren't adequate for the usecase (or are too coarse
> with future hardware).

The total number can be helpful for machines that run for a long time,
especially when you graph them and you monitor them for trends.

[pressure_cooker]: /images/pressure_cooker.jpg
[lots of new features]: https://kernelnewbies.org/Linux_4.20
[pressure stall information]: https://lwn.net/Articles/759658/
[load average]: https://en.wikipedia.org/wiki/Load_(computing)
