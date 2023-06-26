---
aliases:
- /2007/02/01/get-plesk-e-mail-addresses-and-passwords/
author: Major Hayden
date: 2007-02-01 14:33:59
tags:
- plesk
title: Get Plesk e-mail addresses and passwords
---

Need a handy way to list all the email accounts and their passwords?

```sql
select CONCAT(mail_name,"@",name) as email_address,accounts.password from mail left join domains on domains.id=mail.dom_id left join accounts on accounts.id=mail.account_id;
```