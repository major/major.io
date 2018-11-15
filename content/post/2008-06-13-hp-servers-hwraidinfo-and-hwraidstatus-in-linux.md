---
title: 'HP Servers: hwraidinfo and hwraidstatus in Linux'
author: Major Hayden
type: post
date: 2008-06-13T17:09:31+00:00
url: /2008/06/13/hp-servers-hwraidinfo-and-hwraidstatus-in-linux/
dsq_thread_id:
  - 3670208892
categories:
  - Blog Posts
tags:
  - hp
  - raid

---
Working with the RAID configurations on Linux can be a little involved if all you have is hpacucli. Luckily, the folks using HP's OS distributions will get tools like hwraidinfo and hwraid status, but you can get these going in Linux as well.

Here's a bash script equivalent of hwraidinfo which will work in Linux:

```
#!/bin/sh
SLOTLIST=$(hpacucli ctrl all show | \
grep Slot | sed -e 's/^.*Slot //g' -e 's/ .*$//g')
for i in $SLOTLIST
do
echo
hpacucli ctrl slot=$i show | grep -v "^$"
echo
hpacucli ctrl slot=$i ld all show | grep -v "^$"
hpacucli ctrl slot=$i pd all show | grep -v "^$"
done
echo
```

And here is the script equivalent of hwraidstatus:

```
#!/bin/sh
SLOTLIST=$(hpacucli ctrl all show | \
grep Slot | sed -e 's/^.*Slot //g' -e 's/ .*$//g')
for i in $SLOTLIST
do
echo
hpacucli ctrl slot=$i show status | grep -v "^$"
echo
hpacucli ctrl slot=$i ld all show status | grep -v "^$"
hpacucli ctrl slot=$i pd all show status | grep -v "^$"
done
echo
```

Save these to the filesystem, run `chmod +x` and move them to /usr/sbin (or /usr/local/sbin) so that the root user can use them.
