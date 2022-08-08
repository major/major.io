---
title: Why you should use caching for WordPress blogs
author: Major Hayden
date: 2007-12-06T18:09:42+00:00
url: /2007/12/06/why-you-should-use-caching-for-wordpress-blogs/
dsq_thread_id:
  - 3642770772
tags:
  - database
  - web
  - wordpress

---
I had some time to do some testing of my blog's performance today, and I discovered how much of a difference the [WP-Cache][1] plugin makes.

This blog runs on a server with dual Xeon Woodcrest CPU's, 64-bit CentOS 4.5 and a 100mbit network connection. Here's the first test with WP-Cache turned off:

```
$ http_load -parallel 10 -seconds 30 urltocheck.txt
<strong>346</strong> fetches, 10 max parallel, 1.78616e+07 bytes, in 30 seconds
51623.2 mean bytes/connection
11.5333 fetches/sec, 595387 bytes/sec
msecs/connect: 15.1661 mean, 16.97 max, 14.922 min
msecs/first-response: 445.984 mean, 2328.82 max, 189.62 min
HTTP response codes:
  code 200 -- 346
```

346 fetches in 30 seconds is not a very exciting performance number for me. That's just over 10 fetches per second, and on a busy day, I sometimes reach that number. Also, while this test ran, the server's CPU usage was extremely high and over 80% of all four cores were in use. The iowait was about 20% across the board.

I decided to turn on WP-Cache and give it another go with the same test:

```
$ http_load -parallel 10 -seconds 30 urltocheck.txt
<strong>3482</strong> fetches, 10 max parallel, 1.79671e+08 bytes, in 30 seconds
51600 mean bytes/connection
116.067 fetches/sec, 5.98904e+06 bytes/sec
msecs/connect: 15.2259 mean, 18.257 max, 14.891 min
msecs/first-response: 20.7297 mean, 69.39 max, 18.861 min
HTTP response codes:
  code 200 -- 3482
```

Wow, that's a 10-fold improvement, and I can handle over 100 requests per second with 10 parallel requests. Also, the iowait dropped to 5%, and overall CPU usage remained under 8%.

I kicked it up to 20 parallel connections and tried again:

```
$ http_load -parallel 20 -seconds 30 urltocheck.txt
<strong>5817</strong> fetches, 20 max parallel, 3.02176e+08 bytes, in 30 seconds
51947 mean bytes/connection
193.9 fetches/sec, 1.00725e+07 bytes/sec
msecs/connect: 17.9175 mean, 30.831 max, 14.911 min
msecs/first-response: 24.5352 mean, 97.475 max, 18.978 min
HTTP response codes:
  code 200 -- 5817
```

Almost 194 connections served per second! Also, the CPU usage was only at about 14% during the duration of the test.

I decided to tempt fate and see if I could blow the roof off the test with 50 parallel connections:

```
$ http_load -parallel 50 -seconds 30 urltocheck.txt
<strong>5794</strong> fetches, 50 max parallel, 2.99718e+08 bytes, in 30 seconds
51729 mean bytes/connection
193.133 fetches/sec, 9.99059e+06 bytes/sec
msecs/connect: 43.286 mean, 63.878 max, 14.942 min
msecs/first-response: 68.967 mean, 202.854 max, 20.014 min
HTTP response codes:
  code 200 -- 5794
```

The performance suffered a bit, but the server was still pumping out almost 200 connections per second, and I'm okay with that. Well, unless anyone has a spare Cisco 11501 laying around that I could have. :-) And, of course, one additional server.

Just as a sidenote, I installed [Zend Optimizer v3.3][2] on the server and performance actually dropped by 1%-3% for each test. I found that a bit surprising.

_I used [http_load][3] to perform the benchmarks after I found it on [Caleb's blog][4]._

 [1]: http://mnm.uib.es/gallir/wp-cache-2/
 [2]: http://www.zend.com/en/products/guard/optimizer/
 [3]: http://www.acme.com/software/http_load/
 [4]: http://calebgroom.com/archives/185
