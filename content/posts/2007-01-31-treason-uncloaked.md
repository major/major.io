---
title: Treason Uncloaked
author: Major Hayden
type: post
date: 2007-01-31T21:58:48+00:00
url: /2007/01/31/treason-uncloaked/
dsq_thread_id:
  - 3669475230
tags:
  - security

---
```
TCP: Treason uncloaked! Peer 203.12.220.221:59131/80 shrinks window
76154906:76154907. Repaired.
TCP: Treason uncloaked! Peer 203.12.220.227:39670/443 shrinks window
280180313:280180314. Repaired.
TCP: Treason uncloaked! Peer 203.12.220.227:39670/443 shrinks window
280180313:280180314. Repaired.
TCP: Treason uncloaked! Peer 203.12.220.227:39670/443 shrinks window
280180313:280180314. Repaired.
TCP: Treason uncloaked! Peer 203.12.220.237:53759/80 shrinks window
283676616:283676617. Repaired.
TCP: Treason uncloaked! Peer 203.12.220.237:36407/80 shrinks window
352393585:352393586. Repaired.
TCP: Treason uncloaked! Peer 203.12.220.237:38616/443 shrinks window
529411143:529411144. Repaired.
TCP: Treason uncloaked! Peer 58.139.248.9:7611/443 shrinks window
2279076446:2279076447. Repaired.
```

If this is caused by sending strange packets that consume kernel memory, perhaps adding some of these attacker IP addresses to an iptables rule to drop the packets would help. The attacker(s) will probably keep moving to another IP address, so you have get a script to read the logs ("grep Treason") and add new blocking rules to iptables (maybe your old system uses 'ipchains' instead).
