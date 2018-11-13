---
title: Too many languages – can’t upgrade Plesk license
author: Major Hayden
type: post
date: 2007-04-19T13:40:12+00:00
url: /2007/04/19/too-many-languages-cant-upgrade-plesk-license/
dsq_thread_id:
  - 3679054442
tags:
  - plesk

---
If Plesk throws an error that it can't upgrade your license key because of languages, you need to remove the extra locales:

`` # rpm -qa | grep psa-locale | grep -v base<br />
psa-locale-el-GR-8.1-build81061127.19<br />
psa-locale-fr-FR-8.1-build81061127.19<br />
psa-locale-lt-LT-8.1-build81061127.19<br />
psa-locale-pt-BR-8.1-build81061127.19<br />
psa-locale-sv-SE-8.1-build81061127.19<br />
psa-locale-ca-ES-8.1-build81061127.19<br />
psa-locale-de-DE-8.1-build81061127.19<br />
psa-locale-es-ES-8.1-build81061127.19<br />
psa-locale-fi-FI-8.1-build81061127.19<br />
psa-locale-hu-HU-8.1-build81061127.19<br />
psa-locale-ja-JP-8.1-build81061127.19<br />
psa-locale-nl-BE-8.1-build81061127.19<br />
psa-locale-pl-PL-8.1-build81061127.19<br />
psa-locale-pt-PT-8.1-build81061127.19<br />
psa-locale-ru-RU-8.1-build81061127.19<br />
psa-locale-tr-TR-8.1-build81061127.19<br />
psa-locale-zh-TW-8.1-build81061127.19<br />
psa-locale-cs-CZ-8.1-build81061127.19<br />
psa-locale-es-MX-8.1-build81061127.19<br />
psa-locale-it-IT-8.1-build81061127.19<br />
psa-locale-nl-NL-8.1-build81061127.19<br />
psa-locale-ro-RO-8.1-build81061127.19<br />
psa-locale-zh-CN-8.1-build81061127.19<br />
# rpm -ev `rpm -qa | grep psa-locale | grep -v base` ``
