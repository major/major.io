---
title: Plesk SQL Statements
author: Major Hayden
date: 2007-04-27T15:52:17+00:00
url: /2007/04/27/plesk-sql-statements/
dsq_thread_id:
  - 3642766664
tags:
  - plesk

---
When you need to find information about anything in Plesk, here's some SQL statements that you can use:

Start out with:

```
# mysql -u admin -p`cat /etc/psa/.psa.shadow`
mysql> use psa;
```

Find all e-mail passwords:

```sql
select concat_ws('@',mail.mail_name,domains.name),accounts.password from domains,mail,accounts where domains.id=mail.dom_id and accounts.id=mail.account_id order by domains.name ASC,mail.mail_name ASC;
```

Find e-mail passwords made out of only letters:

```sql
select concat_ws('@',mail.mail_name,domains.name),accounts.password from domains,mail,accounts where domains.id=mail.dom_id and accounts.id=mail.account_id and accounts.password rlike binary '^[a-z]+$';
```

Find e-mail passwords made out of only numbers:

```sql
select concat_ws('@',mail.mail_name,domains.name),accounts.password from domains,mail,accounts where domains.id=mail.dom_id and accounts.id=mail.account_id and accounts.password rlike '^[0-9]+$';
```

Find which domains aren't bouncing/rejecting e-mails to unknown recipients:

```sql
select d.name as domain, p.value as catchall_address from Parameters p, DomainServices ds, domains d where d.id = ds.dom_id and ds.parameters_id = p.id and p.parameter = 'catch_addr' order by d.name
```
