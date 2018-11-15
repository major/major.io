---
title: Basic SNMP Configuration
author: Major Hayden
type: post
date: 2007-06-27T23:06:21+00:00
url: /2007/06/27/basic-snmp-configuration/
dsq_thread_id:
  - 3679045558
tags:
  - command line

---
If you want to get a really basic, wide-open for localhost setup for SNMP, just toss the following into /etc/snmp/snmpd.conf:

<pre>com2sec local     127.0.0.1/32    public

group MyROGroup v1         local
group MyROGroup v2c        local
group MyROGroup usm        local

view all    included  .1                               80

access MyROGroup ""      any       noauth    exact  all    none   none

syslocation MyLocation
syscontact Me <me@somewhere.org&gt;</pre>
