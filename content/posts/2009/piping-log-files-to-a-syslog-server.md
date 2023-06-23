---
aliases:
- /2009/04/21/piping-log-files-to-a-syslog-server/
author: Major Hayden
date: 2009-04-21 22:59:21
dsq_thread_id:
- 3642717915
tags:
- logs
- syslog
title: Piping log files to a syslog server
---

If you have a centralized syslog server, or you use Splunk for log tracking, you may find the need to get older log files into a syslog port on that server.

**Edit:** Using logger (as suggested by David and Jerry below) will give you a more reliable way to send the data to a syslog server:

<pre lang="html">cat some.log | logger -t UsefulLabel -n yoursyslogserver.com -p 514</pre>

You'll also be able to set a label for the text before it's piped into the syslog server, which would be handy if you're sorting or parsing the data later on.

Also, you can send your data in the raw using netcat:

<pre lang="html">cat some.log | nc -w 1 -u yoursyslogserver.com 514</pre>