---
aliases:
- /2007/10/02/plesk-there-is-incorrect-combination-of-resource-records-in-the-zone/
author: Major Hayden
date: 2007-10-03 03:21:19
dsq_thread_id:
- 3642770256
tags:
- plesk
title: 'Plesk: There is incorrect combination of resource records in the zone'
---

Yet another weird Plesk error with terrible grammar popped up on a server that I worked with this week:

`Error: There is incorrect combination of resource records in the zone`

As you can see, this error is not terribly informative. Here's a little background on what I was doing before this alert appeared:

On Plesk 8.1.1, I needed to create an alias for a certain domain. Each time I'd try to create the alias, I'd receive the above error. I could even try junk domains like 'test.com' and it would still fail with the error. I went to a different domain on the server, tried to add an alias there, and it failed as well. So, I went back to analyze the error further.

The only thing that tipped me off was the **zone** word, and I immediately began thinking of DNS. I checked the DNS configuration for a few of the domains, and they appeared to be pretty standard. There weren't any wild DNS records, and there were no problems with the named configuration nor the zone files themselves. I crawled through the dns_recs table in the psa database, and everything appears to be normal.

I admitted defeat and escalated the issue to SWSoft to get their help. The answer came back, and I was dumbfounded.

Apparently this record was present in the DNS configuration for all of the sites on the server:

`mail.domain.com. CNAME domain.com.`

This DNS record prevented Plesk from making an alias. **Just** this DNS record. In short, Plesk was unable to make the alias because of this lonely CNAME. The SWSoft developers claimed that it is an 'old-style' notation and that it 'should not be used'. However, during upgrades from 7.x to 8.x, they never thought it'd be a good idea to check for this record and fix it accordingly.

Basically, the SWSoft developers recommended changing the DNS record manually for each domain to something like this:

`mail.domain.com. A 111.222.333.444`

I did that, and it worked flawlessly. Even though this fixes the issue, I still think that they should have considered this issue during the upgrade routines.