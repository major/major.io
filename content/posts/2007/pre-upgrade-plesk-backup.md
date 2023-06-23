---
aliases:
- /2007/04/10/pre-upgrade-plesk-backup/
author: Major Hayden
date: 2007-04-10 18:55:06
dsq_thread_id:
- 3679056283
tags:
- command line
- plesk
title: Pre-upgrade Plesk Backup
---

Before you upgrade Plesk, it's always a good idea to make a backup and also make your ip and shell maps:

```
/usr/local/psa/bin/psadump -f /path/to/psa.dump --nostop --nostop-domain
/usr/local/psa/bin/psarestore -t -f /path/to/psa.dump -m ip_map -s shell_map
```

If you need to restore data, just drop the `-t` on the `psarestore` command.