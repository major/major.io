---
aliases:
- /2007/06/27/basic-snmp-configuration/
author: Major Hayden
date: 2007-06-27 23:06:21
tags:
- command line
title: Basic SNMP Configuration
---

If you want to get a really basic, wide-open for localhost setup for SNMP, just toss the following into /etc/snmp/snmpd.conf:

```
com2sec local     127.0.0.1/32    public

group MyROGroup v1         local
group MyROGroup v2c        local
group MyROGroup usm        local

view all    included  .1                               80

access MyROGroup ""      any       noauth    exact  all    none   none

syslocation MyLocation
syscontact Me <me@somewhere.org>
```