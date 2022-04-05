---
title: PHPMyAdmin 3.x hides the table indexes
author: Major Hayden
type: post
date: 2009-04-04T00:51:48+00:00
url: /2009/04/03/phpmyadmin-3x-hides-the-table-indexes/
dsq_thread_id:
  - 3642805605
categories:
  - Blog Posts
tags:
  - database
  - mysql
  - phpmyadmin

---
Users of PHPMyAdmin 3.x may find that the table indexes are automatically hidden at the bottom of the page. I find this to be a huge annoyance since table indexes are tremendously important to the structure of the table.

If you don't want to downgrade to PHPMyAdmin 2.x, just add the following line to the top of your config.inc.php file:

<pre lang="php">$cfg['InitialSlidersState'] = 'open';</pre>

This will cause the indexes to be displayed when you click **Structure** for a certain table. By default, they are hidden.

_**Sidenote:** Some of you might be thinking: &#8220;Hey, you're a DBA, you should know MySQL queries without needing PHPMyAdmin.&#8221; You're right. I do know how to get the job done without PHPMyAdmin, but I enjoy the way PHPMyAdmin allows me to visualize my table structures. Also, it's a handy way to present data to others very quickly._
