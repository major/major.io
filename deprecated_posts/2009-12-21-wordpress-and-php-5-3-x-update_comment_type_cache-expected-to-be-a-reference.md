---
title: 'WordPress and PHP 5.3.x: update_comment_type_cache() expected to be a reference'
author: Major Hayden
date: 2009-12-21T14:02:02+00:00
url: /2009/12/21/wordpress-and-php-5-3-x-update_comment_type_cache-expected-to-be-a-reference/
dsq_thread_id:
  - 3642805880
tags:
  - php
  - wordpress

---
I upgraded a Fedora 11 instance to Fedora 12 and found the following error at the top of one of my WordPress blogs:

```
Parameter 1 to update_comment_type_cache() expected to be a reference,
value given in wp-includes/plugin.php on line 166
```

The problem wasn't in a plugin, actually. It was within my theme's ([R755-light][1]) functions.php:

```php
function update_comment_type_cache(&$queried_posts) {
```

The temporary fix is to remove the `&` from that line so it looks like this:

```php
function update_comment_type_cache($queried_posts) {
```

After clearing out the WP Super Cache, the page was loading properly again. It turns out that the function actually calculates how many comments are available for a given post, so that functionality is working properly right now. A few theme authors are already releasing new versions to fix this bug, but my theme's author has not.

> The credit for the fix goes to someone in the [WordPress forums][2].

 [1]: http://wordpress.org/extend/themes/r755-light
 [2]: http://wordpress.org/support/topic/297878?replies=8
