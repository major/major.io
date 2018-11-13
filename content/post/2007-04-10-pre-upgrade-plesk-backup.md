---
title: Pre-upgrade Plesk Backup
author: Major Hayden
type: post
date: 2007-04-10T18:55:06+00:00
url: /2007/04/10/pre-upgrade-plesk-backup/
dsq_thread_id:
  - 3679056283
tags:
  - command line
  - plesk

---
Before you upgrade Plesk, it's always a good idea to make a backup and also make your ip and shell maps:

`/usr/local/psa/bin/psadump -f /path/to/psa.dump --nostop --nostop-domain<br />
/usr/local/psa/bin/psarestore -t -f /path/to/psa.dump -m ip_map -s shell_map`

If you need to restore data, just drop the `-t` on the `psarestore` command.
