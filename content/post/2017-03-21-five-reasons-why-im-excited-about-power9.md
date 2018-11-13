---
title: Five reasons why I’m excited about POWER9
author: Major Hayden
type: post
date: 2017-03-21T18:38:22+00:00
url: /2017/03/21/five-reasons-why-im-excited-about-power9/
categories:
  - Blog Posts
tags:
  - linux
  - openpower
  - power
  - rackspace
  - zaius

---
There's plenty to like about the POWER8 architecture: high speed interconnections, large (and flexible) core counts, and support for lots of memory. POWER9 provides improvements in all of these areas and it has learned some entirely new tricks as well.

Here are my top five reasons for getting excited about POWER9:

## NVLink 2.0

In the simplext terms, NVLink provides a very high speed interface between CPUs and GPUs with very low latency. This is quite handy for software that needs to exchange large amounts of data with GPUs. Machine learning can get a significant performance boost with NVLink.

NVLink 2.0 connects CPUs and GPUS with a 25GB/sec link (per lane). That's not all - GPUs can communicate with each other over their own independent lanes. Drop in a few NVIDIA's Tesla P100 GPUs and you will have an extremely powerful accelerated system. NVIDIA's next generation GPUs, codenamed "Volta", will take this to the next level.

## CAPI 2.0

The Coherent Accelerator Processor Interface (CAPI) allows the CPU to quickly access accelerators (think ASICs and FPGAs) over a high bandwidth interface with very low latency. CAPI 2.0 gets a 4x performance bump in POWER9 since it uses PCI-Express Gen 4.

The OpenCAPI 3.0 interface is also available, but it doesn't use PCI-Express like CAPI does. It has an open interface with 25GB/sec of bandwidth and it uses direct memory access to perform operations very quickly.

## On-chip acceleration

POWER9 provides more acceleration for common tasks right on the chip itself. This includes the common functions, like cryptography, but it also accelerates compression. The chip will accelerate gzip compression, 842 compression and AES/SHA. It also has a true random number generator built in.

Another nice on-chip benefit is the virtualization acceleration. No hypervisor calls are needed (this depends on your hypervisor choice) and this allows for user mode invocation of virtualization actions.

## Multiple core options

POWER9 comes in two flavors: SMT8 and SMT4. SMT8 is geared towards the PowerVM platform and provides the strongest individual threads. This makes it great for larger PowerVM partitions that need lots of cores. SMT4 is designed more for Linux workloads.

The chip can handle 64 instructions per cycle on the SMT4 and 128 instructions on the SMT8. There are also some compiler benefits that can improve performance for modern codebases.

## OpenPOWER Zaius

I'd be remiss if I didn't mention Rackspace's contributions to the [Zaius P9 server][1]! Zaius is a spec for an Open Compute POWER9 server. Google, Rackspace, IBM and Ingrasys have been working together to build this server for the masses.

 [1]: https://cloudplatform.googleblog.com/2016/10/introducing-Zaius-Google-and-Rackspaces-open-server-running-IBM-POWER9.html
