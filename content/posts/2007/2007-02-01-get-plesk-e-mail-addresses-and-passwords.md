---
title: Get Plesk e-mail addresses and passwords
author: Major Hayden
date: 2007-02-01T14:33:59+00:00
url: /2007/02/01/get-plesk-e-mail-addresses-and-passwords/
dsq_thread_id:
  - 3642765027
tags:
  - plesk

---
Need a handy way to list all the email accounts and their passwords?

```sql
select CONCAT(mail_name,"@",name) as email_address,accounts.password from mail left join domains on domains.id=mail.dom_id left join accounts on accounts.id=mail.account_id;
```
