---
title: 'Plesk authorization failed: HTTP request error [7]'
author: Major Hayden
type: post
date: 2007-11-14T18:05:24+00:00
url: /2007/11/14/plesk-authorization-failed-http-request-error-7/
dsq_thread_id:
  - 3642773696
tags:
  - emergency
  - plesk

---
I found myself wrestling with a server where the Plesk interface suddenly became unavailable without any user intervention. An attempt to start the service was less than fruitful:

```
[root@server ~]# service psa start
Key file: /opt/drweb/drweb32.key - Key file not found!
A path to a valid license key file does not specified.
Plesk authorization failed: HTTP request error [7]
Error: Plesk Software not running.
                                                           [FAILED]
```

_(Although I included the text from the drweb failure, I later found that it was not related to the issue. However, since it might appear in your logs prior to the HTTP request error, I included it anyways.)_

This was a perfectly working server that had no other issues besides this peculiar Plesk issue. Another technician had upgraded the license a few weeks prior, and it was verified at the the time to be working properly. After a bit of Google searching, I found that the solution was to completely stop Plesk and its related services and then start it all up again.

```
[root@server ~]# service psa stopall
/usr/local/psa/admin/bin/httpsdctl stop: httpd stopped
Stopping Plesk:                                            [  OK  ]
Stopping named:                                            [  OK  ]
service psa startStopping MySQL:                           [  OK  ]
Stopping : Stopping Courier-IMAP server:
   Stopping imap                                           [  OK  ]
   Stopping imap-ssl                                       [  OK  ]
   Stopping pop3                                           [  OK  ]
   Stopping pop3-ssl                                       [  OK  ]

Stopping postgresql service:                               [  OK  ]
Shutting down psa-spamassassin service:                    [  OK  ]
Stopping httpd:                                            [  OK  ]

[root@server ~]# service psa start
Starting named:                                            [  OK  ]
Starting MySQL:                                            [  OK  ]
Starting qmail:                                            [  OK  ]
Starting Courier-IMAP server:
   Starting imapd                                          [  OK  ]
   Starting imap-ssl                                       [  OK  ]
   Starting pop3                                           [  OK  ]
   Starting pop3-ssl                                       [  OK  ]

Starting postgresql service:                               [  OK  ]
Starting psa-spamassassin service:                         [  OK  ]
Processing config directory: /usr/local/psa/admin/conf/httpsd.*.include
/usr/local/psa/admin/bin/httpsdctl start: httpd started
Starting Plesk:                                            [  OK  ]
Starting up drwebd:                                        [  OK  ]
```

I couldn't nail down anything within the Plesk log files that would explain the cause of the problem, but this solution corrected the issue instantly.

_This issue occurred with Plesk 8.1.1 on Red Hat Enterprise Linux 4 Update 5_
