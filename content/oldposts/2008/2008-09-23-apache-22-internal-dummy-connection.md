---
title: 'Apache 2.2: internal dummy connection'
author: Major Hayden
date: 2008-09-24T01:42:21+00:00
url: /2008/09/23/apache-22-internal-dummy-connection/
dsq_thread_id:
  - 3642771707
tags:
  - apache
  - mod_rewrite
  - web

---
After working with some RHEL 5 servers fairly regularly, I noticed a reduction in Apache 2.2 performance when many connections were made to the server. There were messages like these streaming into the access_log as well:

`127.0.0.1 - - [21/Aug/2008:12:00:10 -0400] "GET / HTTP/1.0" 200 2269 "-" "Apache/2.2.3 (Red Hat) (internal dummy connection)"<br />
127.0.0.1 - - [21/Aug/2008:12:00:11 -0400] "GET / HTTP/1.0" 200 2269 "-" "Apache/2.2.3 (Red Hat) (internal dummy connection)"<br />
127.0.0.1 - - [21/Aug/2008:12:00:13 -0400] "GET / HTTP/1.0" 200 2269 "-" "Apache/2.2.3 (Red Hat) (internal dummy connection)"<br />
127.0.0.1 - - [21/Aug/2008:12:00:14 -0400] "GET / HTTP/1.0" 200 2269 "-" "Apache/2.2.3 (Red Hat) (internal dummy connection)"<br />
127.0.0.1 - - [21/Aug/2008:12:00:15 -0400] "GET / HTTP/1.0" 200 2269 "-" "Apache/2.2.3 (Red Hat) (internal dummy connection)"`

On servers with ipv6 enabled, you might see a line like this one:

`::1 - - [21/Aug/2008:12:00:15 -0400] "GET / HTTP/1.0" 200 2269 "-" "Apache/2.2.3 (Red Hat) (internal dummy connection)"`

I began to wonder why Apache was making these connections back onto itself and initiating a `GET /`. Apache's [documentation][1] had the following:

> When the Apache HTTP Server manages its child processes, it needs a way to wake up processes that are listening for new connections. To do this, it sends a simple HTTP request back to itself. This request will appear in the access_log file with the remote address set to the loop-back interface (typically 127.0.0.1 or ::1 if IPv6 is configured). If you log the User-Agent string (as in the combined log format), you will see the server signature followed by "(internal dummy connection)" on non-SSL servers. During certain periods you may see up to one such request for each httpd child process.
>
> These requests are perfectly normal and you do not, in general, need to worry about them. They can simply be ignored.

Sure, I could easily ignore the requests, but the requests were increasing the load on my server more than I liked. Apache's documentation suggested omitting the lines from the logs by adding the following to the Apache configuration:

`SetEnvIf Remote_Addr "127\.0\.0\.1" loopback`

And then adding `env=!loopback` to your `CustomLog` lines ensures that the data won't show up in your access logs. However, you'll still end up with `Directory index forbidden by Options directive: /var/www/html/` filling up your error_logs. A quick search revealed a [handy mod_rewrite][2] rule to get rid of these requests as quickly as possible with the lowest effort required from Apache:

`RewriteCond %{HTTP_USER_AGENT} ^.*internal\ dummy\ connection.*$ [NC]<br />
RewriteRule .* - [F,L]`

At this point, the requests to the localhost should receive a 403 immediately. Since you can't keep Apache from sending all of these requests to itself, the best you can do is respond to them in a manner that requires the lowest possible resources.

 [1]: http://wiki.apache.org/httpd/InternalDummyConnection
 [2]: http://www.inventivelabs.com.au/weblog/post/apache-s-internal-dummy-connection
