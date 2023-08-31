---
author: Major Hayden
date: '2023-08-31'
summary: >
  I woke up one morning to find my Ghost blog unresponsive.
  It required an unexpected fix. 🔧
tags:
  - containers
  - ghost
  - mariadb
  - mysql
  - podman
title: Fixing a ghost database migration failure
coverAlt: Rocky cliff in front of a blue green ocean
coverCaption: |
  [Mary Ray](https://unsplash.com/photos/l6mLi-iKUW0)
---

I love learning about the _behind the scenes_ aspects of just about everything.
I do [ham radio](https://w5wut.com), I self-host lots of my personal infrastructure, and I've been learning more about the math behind the stock market for the last year or two.

That led me to start a blog on [Ghost](https://unsplash.com/photos/l6mLi-iKUW0) to share my findings with others.
I started [Theta Nerd](https://thetanerd.com)[^what_theta] earlier this summer.

My deployment looked great when I started!
Everything was automatically updated with [watchtower](/p/watchtower/) and running with [docker-compose on Fedora CoreOS](https://major.io/p/docker-compose-on-coreos/). _(Click these links to read the posts on both topics!)_

However, I woke up one morning to my monitoring going off and my site was down. 😱

# Why is the site down?

Anyone who has worked in IT knows this sinking feeling.
Something is down, you don't know why, and you suspect the worst possible scenarios.

The instance hosting the blog was online and responsive, so I started digging into the logs with `docker-compose logs`.
I suddenly found a wall of text in the logs for the Ghost container:

```text
[2023-08-03 11:10:16] INFO Adding members.email_disabled column
[2023-08-03 11:10:16] INFO Setting email_disabled to true for all members that have their email on the suppression list
[2023-08-03 11:10:16] INFO Setting nullable: stripe_products.product_id
[2023-08-03 11:10:16] INFO Adding table: donation_payment_events
[2023-08-03 11:10:16] INFO Rolling back: alter table `donation_payment_events` add constraint `donation_payment_events_member_id_foreign` foreign key (`member_id`) references `members` (`id`) on delete SET NULL - Referencing column 'member_id' and referenced column 'id' in foreign key constraint 'donation_payment_events_member_id_foreign' are incompatible..
[2023-08-03 11:10:16] INFO Dropping table: donation_payment_events
[2023-08-03 11:10:16] INFO Dropping nullable:  stripe_products.product_id with foreign keys disabled
[2023-08-03 11:10:16] INFO Setting email_disabled to false for all members
[2023-08-03 11:10:16] INFO Removing members.email_disabled column
[2023-08-03 11:10:16] INFO Rollback was successful.
[2023-08-03 11:10:16] ERROR alter table `donation_payment_events` add constraint `donation_payment_events_member_id_foreign` foreign key (`member_id`) references `members` (`id`) on delete SET NULL - Referencing column 'member_id' and referenced column 'id' in foreign key constraint 'donation_payment_events_member_id_foreign' are incompatible.

alter table `donation_payment_events` add constraint `donation_payment_events_member_id_foreign` foreign key (`member_id`) references `members` (`id`) on delete SET NULL - Referencing column 'member_id' and referenced column 'id' in foreign key constraint 'donation_payment_events_member_id_foreign' are incompatible.
{"config":{"transaction":false},"name":"2023-07-27-11-47-49-create-donation-events.js"}
"Error occurred while executing the following migration: 2023-07-27-11-47-49-create-donation-events.js"
Error ID:
    300
Error Code: 
    ER_FK_INCOMPATIBLE_COLUMNS
----------------------------------------
Error: alter table `donation_payment_events` add constraint `donation_payment_events_member_id_foreign` foreign key (`member_id`) references `members` (`id`) on delete SET NULL - Referencing column 'member_id' and referenced column 'id' in foreign key constraint 'donation_payment_events_member_id_foreign' are incompatible.
    at /var/lib/ghost/versions/5.57.2/node_modules/knex-migrator/lib/index.js:1032:19
    at Packet.asError (/var/lib/ghost/versions/5.57.2/node_modules/mysql2/lib/packets/packet.js:728:17)
    at Query.execute (/var/lib/ghost/versions/5.57.2/node_modules/mysql2/lib/commands/command.js:29:26)
    at Connection.handlePacket (/var/lib/ghost/versions/5.57.2/node_modules/mysql2/lib/connection.js:478:34)
    at PacketParser.onPacket (/var/lib/ghost/versions/5.57.2/node_modules/mysql2/lib/connection.js:97:12)
    at PacketParser.executeStart (/var/lib/ghost/versions/5.57.2/node_modules/mysql2/lib/packet_parser.js:75:16)
    at Socket.<anonymous> (/var/lib/ghost/versions/5.57.2/node_modules/mysql2/lib/connection.js:104:25)
    at Socket.emit (node:events:513:28)
    at addChunk (node:internal/streams/readable:315:12)
    at readableAddChunk (node:internal/streams/readable:289:9)
    at Socket.Readable.push (node:internal/streams/readable:228:10)
    at TCP.onStreamRead (node:internal/stream_base_commons:190:23)
```

Ah, so a failed database migration in the upgrade to 5.57.2 is the culprit! 👏

I brought the site back online quickly by changing the container version for Ghost back to the previous version (5.55.2).

# Why did the database migration fail?

The error message from above boils down to this:

```text
Error: alter table `donation_payment_events` add constraint 
`donation_payment_events_member_id_foreign` foreign key (`member_id`)
references `members` (`id`) on delete SET NULL - Referencing column
'member_id' and referenced column 'id' in foreign key constraint 
'donation_payment_events_member_id_foreign' are incompatible.
```

Adjusting the `donation_payment_events.member_id` column to be a foreign key of `members.id` is failing because they are incompatible types.
However, as I examined both tables, both were regular `varchar(24)` columns without anything special attached to them:

```text
mysql> describe members;
+------------------------------+---------------+------+-----+---------+-------+
| Field                        | Type          | Null | Key | Default | Extra |
+------------------------------+---------------+------+-----+---------+-------+
| id                           | varchar(24)   | NO   | PRI | NULL    |       |
| uuid                         | varchar(36)   | YES  | UNI | NULL    |       |
| email                        | varchar(191)  | NO   | UNI | NULL    |       |
| status                       | varchar(50)   | NO   |     | free    |       |
| name                         | varchar(191)  | YES  |     | NULL    |       |
| expertise                    | varchar(191)  | YES  |     | NULL    |       |
| note                         | varchar(2000) | YES  |     | NULL    |       |
| geolocation                  | varchar(2000) | YES  |     | NULL    |       |
| enable_comment_notifications | tinyint(1)    | NO   |     | 1       |       |
| email_count                  | int unsigned  | NO   |     | 0       |       |
| email_opened_count           | int unsigned  | NO   |     | 0       |       |
| email_open_rate              | int unsigned  | YES  | MUL | NULL    |       |
| last_seen_at                 | datetime      | YES  |     | NULL    |       |
| last_commented_at            | datetime      | YES  |     | NULL    |       |
| created_at                   | datetime      | NO   |     | NULL    |       |
| created_by                   | varchar(24)   | NO   |     | NULL    |       |
| updated_at                   | datetime      | YES  |     | NULL    |       |
| updated_by                   | varchar(24)   | YES  |     | NULL    |       |
+------------------------------+---------------+------+-----+---------+-------+
18 rows in set (0.00 sec)
```

# Going upstream

I went to Ghost's GitHub repository and [opened an issue](https://github.com/TryGhost/Ghost/issues/17584) with as much data as I can find.

One of the [first replies](https://github.com/TryGhost/Ghost/issues/17584#issuecomment-1671134556) mentioned something about database collations.
Long story short, collations describe how databases handle sorting and comparing data for different languages.
Comparing some languages to other languages can be particularly challenging and this can lead to problems.

I made a switch from MariaDB to MySQL recently for the blog.
Could that be related?

# More searching

I figured that I wasn't the first one to stumble into this problem, and sure enough -- I wasn't!
There's a [great blog post](https://dnsmichi.at/2022/06/01/ghost-v5-upgrade-with-mysql-8-collation-migration-in-docker-compose/) about a broken migration from MySQL 5 to 8 with Ghost.

In short, it required several steps to fix it:

1. Stop the Ghost container
1. Back up the database first (always a good idea)
1. Do a quick find/replace on the dumped database to change the collations
1. Drop the `ghost` database from the database 😱
1. Import the database back into MySQL
1. Start Ghost again

Dropping databases always makes me pause, but that's what backups are for! 😉

# How I fixed it

In my case, my MySQL container is called `ghostmysql` and my Ghost database is `ghostdb`.
Then I made a backup of the database using `mysqldump`:

```console
sudo docker-compose exec ghostmysql mysqldump \
    -u root -psuper-secret-password ghostdb > backup-ghost-db.sql
```

Next, I copied the SQL file to another directory _just in case_ I accidentally deleted this backup with an errant command.

```console
cp backup-ghost-db.sql ../
```

Then I made a copy of the SQL file in the current directory and ran the find and replace on that copy.
This changes the collations from the wrong one, `utf8mb4_general_ci`, to the right one, `utf8mb4_0900_ai_ci`[^default_collation]:

```console
cp backup-ghost-db.sql backup-ghost-db-new.sql
sed -i 's/utf8mb4_general_ci/utf8mb4_0900_ai_ci/g' \
    backup-ghost-db-new.sql
```

Now I have the collations right for importing the database back into MySQL.
But first, I have to drop the existing database.
**This is a good time to double check your backups!**

```console
sudo docker-compose exec ghostmysql mysql -u root \
    -psuper-secret-password
mysql> DROP DATABASE ghostdb;
```

Now we can import the modified backup:

```console
cat backup-ghost-db-new.sql | sudo docker-compose exec -T \
    ghostmysql mysql -u root -psuper-secret-password ghostdb
```

Start all the containers:

```console
sudo docker-compose up -d
```

Ghost was back online with the older version and everything looked good!
I updated my `docker-compose.yaml` back to use `latest` for the Ghost version and ran `sudo docker-compose up -d` once more.

Within seconds, the new container image was in place and the container was running!
Both migrations completed in seconds and the blog was back online with the newest version. 🎉

[^what_theta]:
    Theta is one of many [financial Greeks](https://en.wikipedia.org/wiki/Greeks_(finance)) that measure certain aspects of options contracts in the market.
    It's also a [letter in the Greek alphabet](https://en.wikipedia.org/wiki/Theta).

[^default_collation]:
    The default collation in MySQL 8 is `utf8mb4_0900_ai_ci`.