---
title: Getting apache, PHP, and memcached working with SELinux
author: Major Hayden
type: post
date: 2011-09-08T03:55:00+00:00
url: /2011/09/07/getting-apache-php-and-memcached-working-with-selinux/
dsq_thread_id:
  - 3642806694
categories:
  - Blog Posts
tags:
  - apache
  - centos
  - command line
  - fedora
  - linux
  - memcached
  - php
  - red hat
  - ruby
  - security
  - selinux
  - sysadmin

---
[<img src="/wp-content/uploads/2011/09/selinux-penguin-125.png" alt="SELinux Penguin" title="SELinux Penguin" width="125" height="113" class="alignright size-full wp-image-2532" />][1]I'm using SELinux more often now on my Fedora 15 installations and I came up against a peculiar issue today on a new server. My PHP installation is configured to store its sessions in memcached and I brought over some working configurations from another server. However, each time I accessed a page which tried to initiate a session, the page load would hang for about a minute and I'd find this in my apache error logs:

```
[Thu Sep 08 03:23:40 2011] [error] [client 11.22.33.44] PHP Warning:
Unknown: Failed to write session data (memcached). Please verify that
the current setting of session.save_path is correct (127.0.0.1:11211)
in Unknown on line 0
```


I ran through my usual list of checks:

  * netstat showed memcached bound to the correct ports/interfaces
  * memcached was running and I could reach it via telnet
  * memcached-tool could connect and pull stats from memcached
  * double-checked my php.ini
  * tested memcached connectivity via a PHP and ruby script - they worked

Even after all that, I still couldn't figure out what was wrong. I ran strace on memcached while I ran a curl against the page which creates a session and I found something significant - memcached wasn't seeing any connections whatsoever at that time. A quick check of the lo interface with tcpdump showed the same result. Just before I threw a chair, I remembered one thing:

_SELinux._

A quick check for AVC denials showed the problem:

```
# aureport --avc | tail -n 1
4021. 09/08/2011 03:23:38 httpd system_u:system_r:httpd_t:s0 42 tcp_socket name_connect system_u:object_r:memcache_port_t:s0 denied 31536
```


I'm far from being a guru on SELinux, so I leaned on audit2allow for help:

```
# grep memcache /var/log/audit/audit.log | audit2allow

#============= httpd_t ==============
#!!!! This avc can be allowed using one of the these booleans:
#     httpd_can_network_relay, httpd_can_network_memcache, httpd_can_network_connect

allow httpd_t memcache_port_t:tcp_socket name_connect;
```


The boolean we're looking for is `httpd_can_network_memcache`. Flipping the boolean can be done in a snap:

```
# setsebool -P httpd_can_network_memcache 1
# getsebool httpd_can_network_memcache
httpd_can_network_memcache --> on
```


After adjusting the boolean, apache was able to make connections to memcached without a hitch. My page which created sessions loaded quickly and I could see data being stored in memcached. If you want to check the status of all of the apache-related SELinux booleans, just use getsebool:

```
# getsebool -a | grep httpd | grep off$
allow_httpd_anon_write --> off
allow_httpd_mod_auth_ntlm_winbind --> off
allow_httpd_mod_auth_pam --> off
allow_httpd_sys_script_anon_write --> off
httpd_can_check_spam --> off
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_relay --> off
httpd_can_sendmail --> off
httpd_dbus_avahi --> off
httpd_enable_ftp_server --> off
httpd_enable_homedirs --> off
httpd_execmem --> off
httpd_read_user_content --> off
httpd_setrlimit --> off
httpd_ssi_exec --> off
httpd_tmp_exec --> off
httpd_unified --> off
httpd_use_cifs --> off
httpd_use_gpg --> off
httpd_use_nfs --> off
```


If you're interested in SELinux, a good way to get your feet wet is to head over to the CentOS Wiki and review their [SELinux Howtos][2]

 [1]: /wp-content/uploads/2011/09/selinux-penguin-125.png
 [2]: http://wiki.centos.org/HowTos/SELinux
