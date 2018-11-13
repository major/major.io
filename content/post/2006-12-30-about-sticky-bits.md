---
title: About Sticky Bits
author: Major Hayden
type: post
date: 2006-12-31T03:35:26+00:00
url: /2006/12/30/about-sticky-bits/
dsq_thread_id:
  - 3676680184
tags:
  - security

---
Sticky bits help you take file permissions to the next level. Here's an example of a situation where sticky bits help:

Let's say you have a directory on a server called "share". For this directory, you have 3 users: adam, bill, and carl. You are the administrator, so you want to create a directory where all three users can manage files in the share directory. That's easily done: put all three users in the same group, set the permissions as 664, set the owner of the directory as the group that all three users are in, and you're done.

Hold on - adam is going to be upset if bill or carl changes or removes adam's files. How can you let all three users manage files in the same directory but not let them alter each other's files? Sticky bits!

After a `chmod 664`, and a `chown user:group` to fix the group, the directory looks like this:

<pre>-rw-rw-r--   1 admin sharegroup    18367 Dec 30 22:05 shared</pre>

Now, run a `chmod 1664` on the directory:

<pre>-rw-rw-r-t   1 admin sharegroup    18367 Dec 30 22:05 shared</pre>

What's the `t` all about? That's your sticky bit! Whenever adam creates a file, bill and carl can't delete it, modify it, or rename it. They can read it all they want, but adam is the only one who can make the modifications because write priviliges are "stuck" to his user (even though the folder is writable to the group).

Okay, so why do you need sticky bits? This all sounds like fun and games for shared folders, but how can you use this in the real world? Well, think about your `/tmp` directory. Users write to the directory all the time whether they know it or not, but what if one user trashed another users temporary files? Or what if a user hosed out the whole directory? That's where sticky bits can save the day. Always `chmod 1777` your `/tmp` directory for good security on a shared temporary directory.
