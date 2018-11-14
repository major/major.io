---
title: Display auditd messages with journalctl
author: Major Hayden
type: post
date: 2017-01-05T15:53:13+00:00
url: /2017/01/05/display-auditd-messages-with-journalctl/
dsq_thread_id:
  - 5438007712
categories:
  - Blog Posts
tags:
  - auditd
  - centos
  - fedora
  - security
  - systemd
  - ubuntu

---
All systems running `systemd` come with a powerful tool for reviewing the system journal: [`journalctl`][1]. It allows you to get a quick look at the system journal while also allowing you to heavily customize your view of the log.

I logged into a server recently that was having a problem and I found that the audit logs weren't going into syslog. That's no problem - they're in the system journal. The system journal was filled with tons of other messages, so I decided to limit the output only to messages from the `auditd` unit:

```
$ sudo journalctl -u auditd --boot
-- Logs begin at Thu 2015-11-05 09:20:01 CST, end at Thu 2017-01-05 09:38:49 CST. --
Jan 05 07:47:04 arsenic systemd[1]: Starting Security Auditing Service...
Jan 05 07:47:04 arsenic auditd[937]: Started dispatcher: /sbin/audispd pid: 949
Jan 05 07:47:04 arsenic audispd[949]: priority_boost_parser called with: 4
Jan 05 07:47:04 arsenic audispd[949]: max_restarts_parser called with: 10
Jan 05 07:47:04 arsenic audispd[949]: audispd initialized with q_depth=150 and 1 active plugins
Jan 05 07:47:04 arsenic augenrules[938]: /sbin/augenrules: No change
Jan 05 07:47:04 arsenic augenrules[938]: No rules
Jan 05 07:47:04 arsenic auditd[937]: Init complete, auditd 2.7 listening for events (startup state enable)
Jan 05 07:47:04 arsenic systemd[1]: Started Security Auditing Service.
```


This isn't helpful. I'm seeing messages about the `auditd` daemon itself. I want the actual output from the audit rules.

Then I remembered: the kernel is the one that sends messages about audit rules to the system journal. Let's just look at what's coming from the kernel instead:

```
$ sudo journalctl -k --boot
-- Logs begin at Thu 2015-11-05 09:20:01 CST, end at Thu 2017-01-05 09:40:44 CST. --
Jan 05 07:46:47 arsenic kernel: Linux version 4.8.15-300.fc25.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 6.2.1 20160916 (Red Hat 6.2.1-2
Jan 05 07:46:47 arsenic kernel: Command line: BOOT_IMAGE=/vmlinuz-4.8.15-300.fc25.x86_64 root=/dev/mapper/luks-e... ro rd.luks
Jan 05 07:46:47 arsenic kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
Jan 05 07:46:47 arsenic kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
Jan 05 07:46:47 arsenic kernel: x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
Jan 05 07:46:47 arsenic kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
```


**This is worse!** Luckily, the system journal keeps a lot more data about what it receives than just the text of the log line. We can dig into that extra data with the `verbose` option:

```
$ sudo journalctl --boot -o verbose
```


After running that command, search for one of the audit log lines in the output:

```
_UID=0
_BOOT_ID=...
_MACHINE_ID=...
_HOSTNAME=arsenic
_TRANSPORT=audit
SYSLOG_FACILITY=4
SYSLOG_IDENTIFIER=audit
AUDIT_FIELD_HOSTNAME=?
AUDIT_FIELD_ADDR=?
AUDIT_FIELD_RES=success
_AUDIT_TYPE=1105
AUDIT_FIELD_OP=PAM:session_open
_SELINUX_CONTEXT=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
_AUDIT_LOGINUID=1000
_AUDIT_SESSION=3
AUDIT_FIELD_ACCT=root
AUDIT_FIELD_EXE=/usr/bin/sudo
AUDIT_FIELD_GRANTORS=pam_keyinit,pam_limits,pam_keyinit,pam_limits,pam_systemd,pam_unix
AUDIT_FIELD_TERMINAL=/dev/pts/4
_PID=2666
_SOURCE_REALTIME_TIMESTAMP=1483631103122000
_AUDIT_ID=385
MESSAGE=USER_START pid=2666 uid=0 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_limits,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
```


One of the identifiers we can use is `_TRANSPORT=audit`. Let's pass that to `journalctl` and see what we get:

```
$ sudo journalctl --boot _TRANSPORT=audit
-- Logs begin at Thu 2015-11-05 09:20:01 CST. --
Jan 05 09:47:24 arsenic audit[3028]: USER_END pid=3028 uid=0 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_limits,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
... more log lines snipped ...
```


Success! You can get live output of the audit logs by tailing the output:

```
sudo journalctl -af _TRANSPORT=audit
```


For more details on `journalctl`, refer to the [online documentation][1].

 [1]: https://www.freedesktop.org/software/systemd/man/journalctl.html
