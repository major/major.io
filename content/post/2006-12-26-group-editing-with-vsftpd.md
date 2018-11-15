---
title: Group Editing With FTP
author: Major Hayden
type: post
date: 2006-12-27T03:44:55+00:00
url: /2006/12/26/group-editing-with-vsftpd/
dsq_thread_id:
  - 3679083237
tags:
  - ftp

---
So you have multiple users that need to read and write to certain files on the filesystem? This can be done with vsftpd or proftpd quite easily. Let's say you have users called ann, bill and carl and they need to manage files in **/var/www/html**. Here's the steps:

**For vsftpd,** change the umask for files created by FTP users. Open the vsftpd.conf file and edit the following:

<pre>local_umask = 077     <-- old
     local_umask = 022     <-- new</pre>

**For proftpd,** change the umask for files created by FTP users. Open the proftpd.conf file and edit the following:

<pre>Umask 022</pre>

This makes sure that new files are chmodded as 775 (full read/write for users/group, but only read for everyone else).

Next, create a new group. We will call ours "sharedweb":

<pre>groupadd sharedweb</pre>

Now, put the users into that group by adding them in /etc/group:

<pre>sharedweb:*:##:ann,bill,carl</pre>

Modify the users so that their primary group is sharedweb. If you forget this step, when they make new FTP files, they will be owned by each user's primary group (sometimes named the same as the user on some systems) and the permissions will be completeld hosed.

<pre>usermod -g ann sharedweb
     usermod -g bill sharedweb
     usermod -g carl sharedweb</pre>

Restart vsftpd to pick up the new configuration and your users should be able upload, delete, and edit each other's files.
