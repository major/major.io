---
aliases:
- /2007/01/29/make-apache-logs-mimic-iis/
author: Major Hayden
date: 2007-01-29 17:45:22
tags:
- web
title: Make Apache logs mimic IIS
---

To make Apache write logs similar to IIS, toss this into your Apache configuration:

```
LogFormat "%{%Y-%m-%d %H:%M:%S}t %h %u %m %U %q %>s %b %T %H %{Host}i %{User-Agent}i %{Cookie}i %{Referer}i" iis
```