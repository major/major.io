---
title: 'Urchin: Unable to open database for writing since it has been archived'
author: Major Hayden
type: post
date: 2007-08-10T01:43:55+00:00
url: /2007/08/09/urchin-unable-to-open-database-for-writing-since-it-has-been-archived/
dsq_thread_id:
  - 3642769239
categories:
  - Blog Posts
tags:
  - web

---
Urchin sometimes takes it upon itself to do some weird things, and this is one of those times. If Urchin has archived a month of data, and then you ask Urchin to parse a log that contains accesses from that archived month, you'll receive this ugly error:

`Unable to open database for writing since it has been archived`

To fix it, cd into /usr/local/urchin/data/reports/[profile name]/ and unzip the YYYYMM-archive.zip files, then move the zip files out of the way. Make sure that the unzipped files are owned by the Urchin user and group. You should then be able to re-run your stats without a problem.

> Credit for this fix goes to [Google][1]

 [1]: http://www.google.com/support/urchin45/bin/answer.py?answer=28527&topic=7393
