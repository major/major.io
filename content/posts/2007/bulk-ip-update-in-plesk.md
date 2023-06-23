---
aliases:
- /2007/02/11/bulk-ip-update-in-plesk/
author: Major Hayden
date: 2007-02-12 01:41:49
dsq_thread_id:
- 3642765266
tags:
- plesk
title: Bulk IP update in Plesk
---

There's lots of situations where you'd want to use a bulk IP change in Plesk:

* Server is moving and needs to change IP's
* An IP is the destination for some type of DDOS attack
* An IP needs to be removed from the server

So how do you shift tons of domains from one IP to another without spending hours in Plesk clicking and clicking? Do the following instead:

Get into MySQL and find out which IP you're moving from and to:

```
mysql -u admin -p`cat /etc/psa/.psa.shadow`
mysql> select * from IP_Addresses;
```

You should see a printout of all of the available IP's on the server. Make a note of the "id" of the IP you're moving from and to. In this example, here's what we're doing:

* Moving FROM "192.168.1.192" (id = 2)
* Moving TO "192.168.1.209" (id =3)

Now we can start shifting the physically hosted domains over in the database:

```
mysql> update hosting set ip_address_id=3 where ip_address_id=2;
```

We also need to change the domains that are set up for standard or frame forwarding:

```
mysql> update forwarding set ip_address_id=3 where ip_address_id=2;
```

Now we're stuck with the arduous task of updating DNS records. Plesk is kind enough to store this data in four different ways:

```
mysql> update dns_recs set displayHost='192.168.1.209' where displayHost='192.168.1.192';
mysql> update dns_recs set host='192.168.1.209' where host='192.168.1.192';
mysql> update dns_recs set displayVal='192.168.1.209' where displayVal='192.168.1.192';
mysql> update dns_recs set val='192.168.1.209' where val='192.168.1.192';
```

Everything domain related is now moved, but the clients that the domains belong to might not have this new IP address in their IP pool. First, we need to find out our component ID's from the repository table (which generally should be the same as the IP_Addresses.id column, but not always)

```
mysql> SELECT clients.login, IP_Addresses.ip_address,Repository.* FROM clients LEFT JOIN Repository ON clients.pool_id = Repository.rep_id LEFT JOIN IP_Addresses ON Repository.component_id = IP_Addresses.id;
```

For this example, we'll pretend that the output consists of 2's for these clients. We can flip the IP's in the clients' IP pools by running the following:

```
mysql> update Repository set component_id=3 where component_id=2;
```

Now that everything is changed in Plesk's database, it's time to change up the Apache and BIND configuration files. Luckily, this can be done pretty easily with Plesk's command line tools:

```
# /usr/local/psa/admin/bin/websrvmng -av
# mysql -Ns -uadmin -p`cat /etc/psa/.psa.shadow` -D psa -e 'select name from domains' | awk '{print "/usr/local/psa/admin/sbin/dnsmng update " $1 }' | sh
```

All that is left is to force Apache and BIND to pick up the new configuration:

```
# /etc/init.d/httpd reload
# /etc/init.d/named reload
```

Just wait for the DNS records to propagate and you should be all set! The instructions are cumbersome, I know, but it's easier than clicking for-ev-er.