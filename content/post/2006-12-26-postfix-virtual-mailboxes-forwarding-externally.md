---
title: Postfix – Forwarding Virtual Mailboxes
author: Major Hayden
type: post
date: 2006-12-27T02:47:46+00:00
url: /2006/12/26/postfix-virtual-mailboxes-forwarding-externally/
dsq_thread_id:
  - 3642766117
categories:
  - Blog Posts
tags:
  - mail

---
Setting up Postfix to handle mail for a virtual domain and forward it to external mailboxes is pretty easy. Here's an example for a few domains:

**/etc/postfix/main.cf**

```
virtual_alias_domains = hash:/etc/postfix/mydomains
virtual_alias_maps = hash:/etc/postfix/virtual
```


**/etc/postfix/mydomains**

```
foo.com          OK
foo1.com         OK
foo2.com         OK
```


**/etc/postfix/virtual**

```
frank@foo.com           frank@gmail.com
jane@foo.com            jane@earthlink.net
jim@foo1.com            jimmy@yahoo.com
peter@foo2.com          pete@hotmail.com
```


Remember, each time you edit **/etc/postfix/virtual**, do the following:

```
postmap /etc/postfix/virtual /etc/postfix/mydomains
postfix reload
```

