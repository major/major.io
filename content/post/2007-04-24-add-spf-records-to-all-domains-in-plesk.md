---
title: Add SPF records to all domains in Plesk
author: Major Hayden
type: post
date: 2007-04-24T16:28:31+00:00
url: /2007/04/24/add-spf-records-to-all-domains-in-plesk/
dsq_thread_id:
  - 3642766618
tags:
  - mail
  - plesk

---
If you find yourself in the situation where you need to bulk add SPF records to every domain in Plesk, you can use this huge one-liner:

``mysql -u admin -p`cat /etc/psa/.psa.shadow` psa -e "select dns_zone_id,displayHost from dns_recs GROUP BY dns_zone_id ORDER BY dns_zone_id ASC;" | awk '{print "INSERT INTO dns_recs (type,host,val,time_stamp,dns_zone_id,displayHost,displayVal) VALUES ('\''TXT'\'','\''"$2"'\'','\''v=spf1 a mx ~all'\'',NOW(),"$1",'\''"$2"'\'','\''v=spf1 a mx ~all'\'');"}' | mysql -u admin -p`cat /etc/psa/.psa.shadow` psa``

Then you'll need to make Plesk write these changes to the zone files:

``# mysql -Ns -uadmin -p`cat /etc/psa/.psa.shadow` -D psa -e 'select name from domains' | awk '{print "/usr/local/psa/admin/sbin/dnsmng update " $1 }' | sh``

You can check your work by viewing the new entries you made:

``mysql -u admin -p`cat /etc/psa/.psa.shadow` psa -e "SELECT * FROM dns_recs WHERE type='TXT';"``
