---
title: Add spam filtering for all users in Plesk
author: Major Hayden
type: post
date: 2007-07-30T02:46:10+00:00
url: /2007/07/29/add-spam-filtering-for-all-users-in-plesk/
dsq_thread_id:
  - 3642768725
tags:
  - plesk

---
These two commands will enable SpamAssassin for all users on a Plesk 8 server:

``# mysql -u admin -p`cat /etc/psa/.psa.shadow` psa<br />
mysql> update mail set spamfilter = 'true' where postbox = 'true';<br />
# /usr/local/psa/admin/bin/mchk --with-spam``

Thanks to Sean R. for this one!