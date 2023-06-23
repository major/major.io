---
aliases:
- /2007/04/19/too-many-languages-cant-upgrade-plesk-license/
author: Major Hayden
date: 2007-04-19 13:40:12
dsq_thread_id:
- 3679054442
tags:
- plesk
title: Too many languages – can’t upgrade Plesk license
---

If Plesk throws an error that it can't upgrade your license key because of languages, you need to remove the extra locales:

```
# rpm -qa | grep psa-locale | grep -v base
psa-locale-el-GR-8.1-build81061127.19
psa-locale-fr-FR-8.1-build81061127.19
psa-locale-lt-LT-8.1-build81061127.19
psa-locale-pt-BR-8.1-build81061127.19
psa-locale-sv-SE-8.1-build81061127.19
psa-locale-ca-ES-8.1-build81061127.19
psa-locale-de-DE-8.1-build81061127.19
psa-locale-es-ES-8.1-build81061127.19
psa-locale-fi-FI-8.1-build81061127.19
psa-locale-hu-HU-8.1-build81061127.19
psa-locale-ja-JP-8.1-build81061127.19
psa-locale-nl-BE-8.1-build81061127.19
psa-locale-pl-PL-8.1-build81061127.19
psa-locale-pt-PT-8.1-build81061127.19
psa-locale-ru-RU-8.1-build81061127.19
psa-locale-tr-TR-8.1-build81061127.19
psa-locale-zh-TW-8.1-build81061127.19
psa-locale-cs-CZ-8.1-build81061127.19
psa-locale-es-MX-8.1-build81061127.19
psa-locale-it-IT-8.1-build81061127.19
psa-locale-nl-NL-8.1-build81061127.19
psa-locale-ro-RO-8.1-build81061127.19
psa-locale-zh-CN-8.1-build81061127.19
# rpm -ev `rpm -qa | grep psa-locale | grep -v base`
```