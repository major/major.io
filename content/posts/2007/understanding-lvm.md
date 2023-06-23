---
aliases:
- /2007/02/13/understanding-lvm/
author: Major Hayden
date: 2007-02-14 03:34:06
dsq_thread_id:
- 3642765328
tags:
- command line
title: Understanding LVM
---

LVM is handy when you want additional flexibility to grow or shrink your storage space safely without impacting filesystems negatively. It's key to remember that LVM provides flexibility - not redundancy. The best way to understand LVM is to understand four terms: physical volumes, physical extents, volume groups and logical volumes.

**Physical volumes** are probably the easiest to understand for most users. The stuff you deal with all day, /dev/hda2, /dev/sd3 - these are physical volumes. They're real hard drive partitions which are finitely defined. LVM comes along and chops those physical volumes up into little pieces called **physical extents**. Extents are simply just pieces of a regular system partition, and the size of the extent is determined by the OS.

So what happens with these extents? You can pool a group of extents together to form a **volume group**. From there, you can carve out chunks of the extents from the volume group to make **logical volumes**.

Confused? You should be! Let's try an example:

You have two system partitions: /dev/sda2 and /dev/sda3. Let's say that /dev/sda2 has 1,000 extents and /dev/sda3 has 2,000 extents. The first thing you'll want to do is initialize the physical volumes, which basically tells LVM you want to chop them up into pieces so you can use them later:

```
# pvcreate /dev/sda2
# pvcreate /dev/sda3`
```

Graphically, here's what's happened so far:

```
+-----[ Physical Volume ]------+
| PE | PE | PE | PE | PE | PE  |
+------------------------------+
```

Now, LVM has split these physical volumes (partitions) into small pieces called extents. So, we should have 3,000 extents total once we create the physical volumes with LVM (1,000 for sda2 and 2,000 for sda3). Now, we need to take all of these extents and put them into a group, called the volume group:

```
vgcreate test /dev/sda2 /dev/sda3
```

Again, here's what we've done:

```
+------[ Volume Group ]-----------------+
|  +--[PV]--------+  +--[PV]---------+  |
|  | PE | PE | PE |  | PE | PE | PE  |  |
|  +--------------+  +---------------+  |
+---------------------------------------+
```

So what's happened so far? The physical volumes (partitions) are unchanged, but LVM has split them into extents, and we've now told LVM that we want to include the extents from both physical volumes in a volume group called test. The volume group test is basically a big bucket holding all of our extents from both physical volumes. To move on, you need to find out how many extents we have in our volume group now:

```
vgdisplay -v test
```

We should see that **Total PE** in the output shows 3,000, with a **Free PE** of 3,000 since we haven't done anything with our extents yet. Now we can take all these extents in the volume group and lump them together into a 1,500 extent partition:

```
lvcreate -l 1500 -n FIRST test
```

What did we just do? We made a real linux volume called /dev/test/FIRST that has 1,500 extents. Toss a filesystem onto that new volume and you're good to go:

```
mke2fs -j /dev/test/FIRST
```

So, this new logical volume contains 1,500 extents, which means we have 1,500 left over. Might as well make a second volume out of the remaining extents in our volume group:

```
lvcreate -l 1500 -n SECOND test
mke2fs -j /dev/test/SECOND
```

Now you have two equal sized logical volumes whereas you had one small one (sda2) and one large one (sda3) before. The two logical volumes use extents from both physical volumes that are both held within the same volume group. You end up with something like this:

```
+------[ Volume Group ]-----------------+
|  +--[PV]--------+  +--[PV]---------+  |
|  | PE | PE | PE |  | PE | PE | PE  |  |
|  +--+---+---+---+  +-+----+----+---+  |
|     |   |   | +-----/     |    |      |
|     |   |   | |           |    |      |
|   +-+---+---+-+      +----+----+--+   |
|   |  Logical  |      |  Logical   |   |
|   |  Volume   |      |   Volume   |   |
|   |           |      |            |   |
|   |  /FIRST   |      |   /SECOND  |   |
|   +-----------+      +------------+   |
+---------------------------------------+
```