---
title: 'New icanhaz features: reverse DNS and traceroutes'
author: Major Hayden
date: 2013-03-17T03:13:53+00:00
url: /2013/03/16/new-icanhaz-features-reverse-dns-and-traceroutes/
dsq_thread_id:
  - 3663067936
tags:
  - command line
  - development
  - fun
  - network
  - networking
  - python
  - sysadmin

---
After [adding some upgrades][1] for [icanhazip.com][2], I wanted to go a bit further. Adding reverse DNS (PTR) lookups and traceroutes seemed like a decent idea!

Want to beta test some new features on [icanhazptr.com][3] and [icanhaztrace.com][4]? Give them a try!

Getting your reverse DNS entry is easy:

```
$ curl -4 icanhazptr.com
ord.icanhazip.com
$ curl -6 icanhazptr.com
ord.icanhazip.com
```


Traceroutes are straightforward as well:

```
$ curl -4 icanhaztrace.com
traceroute to 166.78.118.193 (166.78.118.193), 30 hops max, 60 byte packets
 1  212.111.33.229  20.031 ms
 2  212.111.33.233  1.011 ms
 3  149.11.30.61  107.976 ms
...
$ curl -6 icanhaztrace.com
traceroute to 2001:4801:7818:6:abc5:ba2c:ff10:275f (2001:4801:7818:6:abc5:ba2c:ff10:275f), 30 hops max, 80 byte packets
 1  2a01:7e00:ffff:0:8a43:e1ff:fea3:fa7f  2.183 ms
 2  2001:4d78:fe01:2:1:3:b90:1  1.330 ms
 3  2001:978:2:45::d:1  8.388 ms
...
```


While this sits in beta, here are some things to keep in mind:

  * If a PTR record doesn't exist for your IP address, your IP address will be returned
  * Failing traceroutes will cause your IP address to be returned
  * A PTR record will be chosen at random if multiple PTR records are returned
  * PTR lookups for traceroutes are currently disabled

Let me know if you find any bugs.

 [1]: /2013/02/23/more-upgrades-for-icanhazip-com/
 [2]: http://icanhazip.com
 [3]: http://icanhazptr.com
 [4]: http://icanhaztrace.com
