---
title: Configure remote syslog for XenServer via the command line
author: Major Hayden
date: 2014-06-03T17:55:59+00:00
url: /2014/06/03/configure-remote-syslog-for-xenserver-via-the-command-line/
dsq_thread_id:
  - 3648141445
tags:
  - security
  - sysadmin
  - syslog
  - xen
  - xenserver

---
Citrix has some [helpful documentation][1] online about configuring remote syslog support for XenServer using the XenCenter GUI. However, if you need to do this via configuration management or scripts, using a GUI isn't an option.

Getting it done via the command line is relatively easy:

```
HOSTUUID=`xe host-list --minimal`
SYSLOGHOST=syslog.example.com
xe host-param-set uuid=${HOSTUUID} logging:syslog_destination=${SYSLOGHOST}
xe host-syslog-reconfigure host-uuid=${HOSTUUID}
```


Removing the configuration and going back to only local logging is easy as well:

```
HOSTUUID=`xe host-list --minimal`
xe host-param-clear uuid=${HOSTUUID} param-name=logging
xe host-syslog-reconfigure host-uuid=${HOSTUUID}
```


 [1]: https://support.citrix.com/article/CTX119496
