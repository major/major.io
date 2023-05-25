---
title: Make Apache logs mimic IIS
author: Major Hayden
date: 2007-01-29T17:45:22+00:00
url: /2007/01/29/make-apache-logs-mimic-iis/
dsq_thread_id:
  - 3679076122
tags:
  - web

---
To make Apache write logs similar to IIS, toss this into your Apache configuration:

```
LogFormat "%{%Y-%m-%d %H:%M:%S}t %h %u %m %U %q %>s %b %T %H %{Host}i %{User-Agent}i %{Cookie}i %{Referer}i" iis
```
