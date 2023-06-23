---
aliases:
- /2012/05/11/lesser-known-but-extremely-handy-linux-tools/
author: Major Hayden
date: 2012-05-11 21:28:58
dsq_thread_id:
- 3642806960
tags:
- command line
- linux
- network
- performance
- security
- sysadmin
title: Lesser-known but extremely handy Linux tools
---

Kristóf Kovács [has a fantastic post][1] about some lesser-known Linux tools that can really come in handy in different situations.

If you haven't tried `dstat` (I hadn't until I saw Kristóf's post), this is a great one to try. You can keep a running tally on various server metrics including load average, network transfer, and disk operations.

Here is some sample output:

```
----total-cpu-usage---- ---paging-- ---load-avg--- ------memory-usage----- -net/total- ---procs--- --io/total- ---system-- ----tcp-sockets----
usr sys idl wai hiq siq|  in   out | 1m   5m  15m | used  buff  cach  free| recv  send|run blk new| read  writ| int   csw |lis act syn tim clo
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|1314B  180B|  0   0   0|   0     0 |  70    80 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|1779B 1004B|  0   0   0|   0     0 |  84    78 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M| 904B  362B|1.0   0 1.0|   0     0 |  75    86 | 13   9   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  386M|2203B 1559B|  0   0   0|   0     0 | 180   127 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  386M| 260B  130B|  0   0   0|   0     0 |  53    66 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|  52B  114B|  0   0   0|   0     0 |  54    77 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|2271B  872B|  0   0   0|   0     0 |  94    79 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|  52B  130B|  0   0   0|   0     0 |  54    74 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|1126B 1254B|  0   0   0|   0  24.0 |  80    87 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.07 0.25 0.25| 866M  249M  537M  387M|1030B  130B|  0   0   0|   0     0 |  88    82 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M| 578B  114B|  0   0   0|   0     0 |  53    64 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M|1597B  890B|  0   0   0|   0     0 |  85    79 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M| 552B  114B|  0   0   0|   0     0 |  63    77 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M|1624B 1254B|  0   0   0|   0     0 |  81    75 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M| 478B  114B|  0   0   0|   0     0 |  67    73 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M| 418B  114B|  0   0   0|   0     0 |  59    74 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M|1265B  874B|  0   0   0|   0     0 |  82    73 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M| 758B  114B|  0   0   0|   0     0 |  60    80 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M|1236B 1255B|  0   0   0|   0  4.00 |  93    79 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.06 0.24 0.25| 866M  249M  537M  387M|  52B  130B|  0   0   0|   0     0 |  71    70 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.05 0.23 0.25| 866M  249M  537M  387M| 214B  114B|  0   0   0|   0     0 |  55    73 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.05 0.23 0.25| 866M  249M  537M  387M|1201B  890B|  0   0   0|   0     0 |  80    80 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.05 0.23 0.25| 866M  249M  537M  387M| 108B  114B|  0   0   0|   0     0 |  53    66 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.05 0.23 0.25| 866M  249M  537M  387M|1344B 1254B|  0   0   0|   0  10.0 | 119    85 | 13   7   0   0   5
  0   0 100   0   0   0|   0     0 |0.05 0.23 0.25| 866M  249M  537M  387M| 172B  130B|  0   0   0|   0  8.00 |  80    82 | 13   7   0   0   5
```


Learn more about `dstat` on [Dag Wieërs' site][2].

 [1]: http://kkovacs.eu/cool-but-obscure-unix-tools
 [2]: http://dag.wieers.com/home-made/dstat/