---
title: 'EXT3-fs error (device hda3) in start_transaction: Journal has aborted'
author: Major Hayden
type: post
date: 2007-11-20T18:23:40+00:00
url: /2007/11/20/ext3-fs-error-device-hda3-in-start_transaction-journal-has-aborted/
dsq_thread_id:
  - 3642773582
categories:
  - Blog Posts
tags:
  - command line
  - emergency
  - filesystem

---
If your system abruptly loses power, or if a RAID card is beginning to fail, you might see an ominous message like this within your logs:

```


Basically, the system is telling you that it's detected a filesystem/journal mismatch, and it can't utilize the journal any longer. When this situation pops up, the filesystem gets mounted read-only almost immediately. To fix the situation, you can remount the partition as ext2 (if it isn't your active root partition), or you can commence the repair operations.

If you're working with an active root partition, you will need to boot into some rescue media and perform these operations there. If this error occurs with an additional partition besides the root partition, simply unmount the broken filesystem and proceed with these operations.

Remove the journal from the filesystem (effectively turning it into ext2):

```


Now, you will need to fsck it to correct any possible problems (throw in a -y flag to say yes to all repairs, -C for a progress bar):

```


Once that's finished, make a new journal which effectively makes the partition an ext3 filesystem again:

```


You should be able to mount the partition as an ext3 partition at this time:

```


Be sure to check your dmesg output for any additional errors after you're finished!
