---
title: 'Plesk 7.5.4: Error: HTTPD_INCLUDE_D not defined'
author: Major Hayden
type: post
date: 2007-10-02T02:56:20+00:00
url: /2007/10/01/plesk-754-error-httpd_include_d-not-defined/
dsq_thread_id:
  - 3679020570
tags:
  - plesk

---
Normally, this error will pop up when you attempt to restart a Plesk-related service, like httpsd, psa-spamassassin or qmail:

```
Error: HTTPD_INCLUDE_D not defined
```

This basically means that Plesk is unable to get some required configuration directives from the /etc/psa/psa.conf file. If you can't find the directive in the file that Plesk is complaining about, check your Plesk RPM's with `rpm`:

```
# rpm -q psa
```

Most likely, you will find that there is a psa-7.5.4 RPM and a psa-8.1.0 or psa-8.1.1 RPM installed simultaneously. This generally appears because of a botched upgrade that was started within Plesk by the admin user.

To fix the issue, get the psa-7.5.4 RPM from [autoinstall.plesk.com][1]. Remove the psa-8.1.1 RPM and install the psa-7.5.4 RPM again rather forcefully:

```
# rpm -ev psa-8.1.1...
# rpm -Uvh --force --nodeps psa-7.5.4...
# /etc/init.d/psa restart
```

At this point, you can download the command line autoinstaller and try the Plesk upgrade again.

Further reading: <http://forum.swsoft.com/showthread.php?threadid=32299>

 [1]: http://autoinstall.plesk.com/
