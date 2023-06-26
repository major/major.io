---
aliases:
- /2007/03/18/awstats-icons-dont-appear-in-plesk-81/
author: Major Hayden
date: 2007-03-18 19:17:26
tags:
- plesk
- web
title: AWStats icons don’t appear in Plesk 8.1
---

The AWStats package in RHEL4/Centos4 and Plesk 8.1 uses an alias directory for the icons called /awstats-icon, but when the AWStats contents is generated, the icon directory is different (/icon). To fix this issue, change this file:

`/usr/share/awstats/awstats_buildstaticpages.pl`:

```perl
my $DirIcons='/awstats-icon';
```