---
aliases:
- /2013/04/14/remove-sensitive-information-from-email-headers-with-postfix/
author: Major Hayden
date: 2013-04-15 02:59:34
dsq_thread_id:
- 3642807167
tags:
- centos
- command lines
- fedora
- mail
- postfix
- redhat
- security
- sysadmin
title: Remove sensitive information from email headers with postfix
---

I'm in the process of moving back to a postfix/dovecot setup for hosting my own mail and I wanted a way to remove the more sensitive email headers that are normally generated when I send mail. My goal is to hide the originating IP address of my mail as well as my mail client type and version.

To get started, make a small file with regular expressions in `/etc/postfix/header_checks`:

```
/^Received:.*with ESMTPSA/              IGNORE
/^X-Originating-IP:/    IGNORE
/^X-Mailer:/            IGNORE
/^Mime-Version:/        IGNORE
```


The "ESMTPSA" match works for me because I only send email via port 465. I don't allow SASL authentication via port 25. You may need to adjust the regular expression if you accept SASL authentication via smtp.

Now, add the following two lines to your `/etc/postfix/main.cf`:

```
mime_header_checks = regexp:/etc/postfix/header_checks
header_checks = regexp:/etc/postfix/header_checks
```


Rebuild the hash table and reload the postfix configuration:

```
postmap /etc/postfix/header_checks
postfix reload
```


Now, send a test email. View the headers and you should see the original received header (with your client IP address) removed, along with details about your mail client.