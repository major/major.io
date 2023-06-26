---
aliases:
- /2011/01/09/strategies-for-storing-backups/
author: Major Hayden
date: 2011-01-10 01:20:44
tags:
- emergency
- general advice
- sysadmin
title: Strategies for storing backups
---

Although it's not a glamorous subject for system administrators, backups are necessary for any production environment. Those who run their systems without backups generally learn from their errors in a very painful way. However, the way you store your backups may sometimes prove to be just as vital as the methods you use to backup your data.

For my environments, I follow a strategy like this: I have some backups immediately accessible, others that are accessible very quickly (but not instantly), and others that are offsite and may take a bit more time to access.

**Immediately accessible backups**

One of the easiest way to have an immediately accessible backup is to have multiple machines online running the same versions of code or databases in a high availability group. If you have a node which fails, the remaining nodes should be able to handle the requests immediately. You may not consider this to be a backup under the traditional definition of what a backup should be, but it's functionally similar.

**Backups that are accessible quickly**

This second level of backups should be stored very close to your environment or within the environment itself. If you have multiple database and web server nodes, you could consider storing your web backups on the database servers and vice versa. For those who run very sensitive applications, this may violate the provisions of different certifications and regulations. A server dedicated to holding backups may be a viable alternative for additional security.

**Offsite backup storage**

These are the backups that need to be geographically distant from your main environment. Also, you should always consider storing these backups on more than one medium with more than one company.

For example, if your hosting providers offers a storage service, it's fine to store one set of your backups there, but consider storing them with a competitor as well. If you store your backups with your hosting provider in multiple places, you could be caught be a provider issue and lose access to your backups entirely. Hosting with multiple providers will allow you to access at least one copy of your backups even if there are billing or technical issues with a particular provider.

Another thing to keep in mind with offsite backup storage is how long it will take to transfer the backups to your hosting environment in case of an emergency. If your hosting environment is in Texas, but your backups are stored in Australia, you're going to have a longer wait when you transfer your data back.

**A specific example**

My environments are all in Dallas, Texas and I have a highly available environment with multiple instances. My second layer of backups are stored within the environment as well as in Rackspace's Cloud Files in Dallas. My third layer of backups are stored with Amazon S3 via Jungle Disk and at my home on a RAID array.

While I hope you never need to access your backups under duress, these tips should help to reduce your stress if you need to restore data in a hurry.