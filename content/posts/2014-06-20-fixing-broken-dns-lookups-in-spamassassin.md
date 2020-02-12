---
title: Fixing broken DNS lookups in spamassassin
author: Major Hayden
type: post
date: 2014-06-20T13:20:56+00:00
url: /2014/06/20/fixing-broken-dns-lookups-in-spamassassin/
dsq_thread_id:
  - 3642807551
categories:
  - Blog Posts
tags:
  - dns
  - fedora
  - mail
  - perl
  - postfix
  - selinux
  - spamassassin

---
I talked about the [joys of running my own mail server][1] last week only to find that my mail server was broken yesterday. Spamassassin stopped doing DNS lookups for [RBL][2] and [SPF][3] checks.

I had one of these moments:

[<img src="/wp-content/uploads/2014/06/neil_patrick_harris_sigh.gif" alt="Neil Patrick Harris Sigh" width="500" height="233" class="aligncenter size-full wp-image-4968" />][4]

My logs looked like this:

```
plugin: eval failed: available_nameservers: No DNS servers available!
plugin: eval failed: available_nameservers: No DNS servers available!
rules: failed to run NO_DNS_FOR_FROM RBL test, skipping:
 (available_nameservers: [...] No DNS servers available!)
 (available_nameservers: [...] No DNS servers available!
```


My /etc/resolv.conf was correct and had two valid DNS servers listed. Also, the permissions set on /etc/resolv.conf were reasonable (0644) and the SELinux context applied to the file was appropriate (net\_conf\_t). Everything else on the system was able to resolve DNS records properly. Even an strace on the spamd process showed it reading /etc/resolv.conf successfully!

It was Google time. I put some snippets of my error output into the search bar and found a [spamassassin bug report][5]. Mark Martinec found the root cause of the bug:

> Net::DNS version 0.76 changed the field name holding a set of nameservers in a Net::DNS::Resolver object: it used to be 'nameservers', but is now split into two fields: 'nameserver4' and 'nameserver6'.
>
> Mail/SpamAssassin/DnsResolver.pm relied on the internal field name of a Net::DNS::Resolver object to obtain a default list of recursive name servers, so the change in Net::DNS broke that.

The [patch from the bug report][6] worked just fine on my Fedora 20 mail server. Be sure to restart spamd after making the change.

There's a [Fedora bug report][7] as well.

_If anyone is interested, I plan to write up my email configuration on Fedora soon for other folks to use. I might even make some ansible playbooks for it. ;)_

_Fedora update: Fedora's spamassassin package has been [updated to 3.4.0-7 and it fixes two bugs][8]. You'll find it in the stable repositories in a few days._

 [1]: https://twitter.com/majorhayden/status/479250665311457281
 [2]: https://en.wikipedia.org/wiki/DNSBL
 [3]: https://en.wikipedia.org/wiki/Sender_Policy_Framework
 [4]: /wp-content/uploads/2014/06/neil_patrick_harris_sigh.gif
 [5]: https://issues.apache.org/SpamAssassin/show_bug.cgi?id=7057
 [6]: https://svn.apache.org/viewvc/spamassassin/trunk/lib/Mail/SpamAssassin/DnsResolver.pm?r1=1603518&r2=1603517&pathrev=1603518
 [7]: https://bugzilla.redhat.com/show_bug.cgi?id=1111586
 [8]: https://admin.fedoraproject.org/updates/spamassassin-3.4.0-7.fc20
