---
title: Ugly upgrade path from WordPress 2.7.1 to 2.8
author: Major Hayden
type: post
date: 2009-06-13T17:48:15+00:00
url: /2009/06/13/ugly-upgrade-path-from-wordpress-2-7-1-to-2-8/
dsq_thread_id:
  - 3642805636
categories:
  - Blog Posts
tags:
  - database
  - php
  - upgrade
  - wordpress

---
When I tried to do an automatic upgrade from WordPress 2.7.1 to 2.8 yesterday, it failed miserably. The files were all put in place, but when I tried to load `/wp-admin/upgrade.php`, this error popped up:

```
Fatal error: Call to undefined method wpdb::has_cap() in
/path/to/wordpress/wp-admin/includes/schema.php on line 22</pre>

I was perplexed at the error, so I restored from a backup and began [upgrading manually][1]. The manual upgrades have always worked well for me in the past, so I figured this would probably fix the problem. After the upgrade, I went to `/wp-admin/upgrade.php` and saw:

```
Fatal error: Call to undefined method wpdb::has_cap() in
/path/to/wordpress/wp-admin/includes/schema.php on line 22</pre>

**What the heck is going on?** I restored from a backup, tried the manual upgrade again, and it still failed. I took a look at the lines causing the problem in `schema.php`:

```
has_cap( 'collation' ) ) {
	if ( ! empty($wpdb->charset) )
		$charset_collate = "DEFAULT CHARACTER SET $wpdb->charset";
	if ( ! empty($wpdb->collate) )
		$charset_collate .= " COLLATE $wpdb->collate";
}</pre>

I figured I could comment out the if statement and probably still be safe:

```
has_cap( 'collation' ) ) {
	if ( ! empty($wpdb->charset) )
		$charset_collate = "DEFAULT CHARACTER SET $wpdb->charset";
	if ( ! empty($wpdb->collate) )
		$charset_collate .= " COLLATE $wpdb->collate";
// }</pre>

**Success?** I could make it through the `upgrade.php` part fine at this point, but whenever I tried to add a tag to a post, it wasn't saving to the database. I caught this error in my apache logs:

``[Fri Jun 12 23:45:03 2009] [error] [client 72.183.200.144] WordPress database error Duplicate entry 'debian' for key 'slug' for query INSERT INTO wp_terms (`name`,`slug`,`term_group`) VALUES ('debian','debian','0') made by wp_insert_term, referer: http://rackerhacker.com/wp-admin/post.php?action=edit&post=877``

**Frustration quickly ensued.** I moved my `/wp-content/` folder out of the way and replaced it with the standard WordPress stuff, but that didn't help. I moved plugins out of the way, one by one, but that didn't fix it either. Then I spotted a strange file sitting in `/wp-content/` called `db.php`. When I opened it, I found a [lot of database setup classes for mysqli][2].

I renamed it to `db.pleasedonteverrunthisphp` and I was able to save tags properly. So far, I haven't found any issues after I made chat change.

Does anyone know where that file might have come from? I don't remember adding it myself, so I'm wondering if it was ever packaged with a WordPress plugin or a WordPress installation. I hope this helps someone else!

 [1]: http://codex.wordpress.org/Upgrading_WordPress
 [2]: http://pastie.org/private/rmbmk3ohgmdbujotnrg
