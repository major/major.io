---
title: Cisco Logging to RHEL
author: Major Hayden
date: 2007-02-06T21:48:54+00:00
url: /2007/02/06/cisco-logging-to-rhel/
dsq_thread_id:
  - 3658783327
tags:
  - command line
  - security

---
If you have a Cisco device logging to RHEL, here's all that's necessary:

```
# vi /etc/sysconfig/syslog
SYSLOGD_OPTIONS="-m 0 -r"
```

Check the facility listed in the Cisco configuration, and convert it into the linux syslog facility levels found on [Cisco's syslog configuration documentation][1]:

For example, Cisco's facility 19 is the same as linux's facility 3.

```
# vi /etc/syslog.conf
*.info;mail.none;authpriv.none;cron.none;local3.none;   /var/log/messages
local3.*                                                /var/log/cisco.log
```

Add `local3.none;` to the `/var/log/messages` line and add the `local3.*` line at the bottom of the file.

Restart syslog with `/etc/init.d/syslog restart`. Verify that the syslog server is listening on port 514 and then tail your new `/var/log/cisco.log`:

```
# netstat -plan | grep 514
udp        0      0 0.0.0.0:514                 0.0.0.0:*          3770/syslogd
```

 [1]: http://www.cisco.com/en/US/products/hw/vpndevc/ps2030/products_tech_note09186a0080094030.shtml
