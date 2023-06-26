---
aliases:
- /2007/02/23/hide-apache-version/
author: Major Hayden
date: 2007-02-23 21:07:48
tags:
- security
- web
title: Hide Apache Version
---

If you want to hide the current version of Apache and your OS, just replace

`ServerTokens OS`

with

`ServerTokens Prod`

and restart Apache.