---
aliases:
- /2007/01/31/wave-the-plesk-magic-wand/
author: Major Hayden
date: 2007-01-31 16:01:22
dsq_thread_id:
- 3679073679
tags:
- plesk
title: Wave the Plesk magic wand
---

If Plesk ever appears to be out of sync with the configuration files, or if there's a Plesk issue that's occurring that makes no sense at all, just stand back and wave the Plesk magic wand:

`/usr/local/psa/admin/bin/websrvmng -av`

Then restart whatever service was acting up, and things should be sorted out.