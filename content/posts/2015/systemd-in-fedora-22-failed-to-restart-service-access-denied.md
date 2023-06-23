---
aliases:
- /2015/09/18/systemd-in-fedora-22-failed-to-restart-service-access-denied/
author: Major Hayden
date: 2015-09-18 19:43:35
dsq_thread_id:
- 4142728954
tags:
- fedora
- selinux
- systemd
title: 'systemd in Fedora 22: Failed to restart service: Access Denied'
---

[<img src="/wp-content/uploads/2012/01/fedorainfinity.png" alt="Fedora Infinity Logo" width="105" height="102" class="alignright size-full wp-image-2712" />][1]If you're running Fedora 22 and you've recently updated to [systemd-219-24.fc22][2], you might see errors like these:

```
# systemctl restart postfix
Failed to restart postfix.service: Access denied
```


Your audit logs will have entries like these:

```
type=USER_AVC msg=audit(1442602150.292:763): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='avc:  denied  { start } for auid=n/a uid=0 gid=0 path="/run/systemd/system/session-4.scope" cmdline="/usr/lib/systemd/systemd-logind" scontext=system_u:system_r:systemd_logind_t:s0 tcontext=system_u:object_r:systemd_unit_file_t:s0 tclass=service  exe="/usr/lib/systemd/systemd" sauid=0 hostname=? addr=? terminal=?'
type=USER_AVC msg=audit(1442602150.437:768): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='avc:  denied  { start } for auid=n/a uid=0 gid=0 path="/usr/lib/systemd/system/user@.service" cmdline="/usr/lib/systemd/systemd-logind" scontext=system_u:system_r:systemd_logind_t:s0 tcontext=system_u:object_r:systemd_unit_file_t:s0 tclass=service  exe="/usr/lib/systemd/systemd" sauid=0 hostname=? addr=? terminal=?'
type=USER_AVC msg=audit(1442602150.440:769): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='avc:  denied  { start } for auid=n/a uid=0 gid=0 path="/run/systemd/system/session-4.scope" cmdline="/usr/lib/systemd/systemd-logind" scontext=system_u:system_r:systemd_logind_t:s0
```


There's a [very active bug][3] under review to get it fixed. As a workaround, you can re-execute systemd with the following command:

```
systemctl daemon-reexec
```


That should allow you to stop, start, and restart services properly again. Also, you'll be able to switch runlevels for reboots and shutdowns.

Keep an eye on the bug for more details as they develop. Kudos to [Kevin Fenzi][4] for the workaround!

 [1]: /wp-content/uploads/2012/01/fedorainfinity.png
 [2]: https://bodhi.fedoraproject.org/updates/FEDORA-2015-15821
 [3]: https://bugzilla.redhat.com/show_bug.cgi?id=1224211
 [4]: https://fedoraproject.org/wiki/User:Kevin