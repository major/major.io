---
title: Aruba access points, EAP, and wpa_supplicant 2.4 bugs
author: Major Hayden
date: 2015-07-17T12:29:29+00:00
url: /2015/07/17/aruba-access-points-eap-and-wpa_supplicant-2-4-bugs/
dsq_thread_id:
  - 3943180683
tags:
  - fedora
  - networking

---
I stumbled upon a strange bug at work one day and found I couldn't connect to our wireless access points any longer. After some investigation in the systemd journal, I found that my card associated with the access point but never went any further past that. It looked as if the authentication wasn't ever taking place.

A quick dig through my recent dnf update history didn't reveal much but then I found a tip from a coworker on an internal wiki that wpa_supplicant 2.4 has problems with certain Aruba wireless access points.

There's an [open ticket on the Red Hat Bugzilla][1] about the issues in wpa_supplicant 2.4. The [changelog][2] for 2.4 is lengthy and it has plenty of mentions of [EAP][3]; Aruba's preferred protocol on certain networks. One of those changes could be related. A formal support case[^4] is open with Aruba as well.

If this bug affects you, you can return to wpa\_supplicant-2.3-3.fc22.x86\_64 easily by running:

```text
dnf downgrade wpa_supplicant
```

This isn't a good long-term solution, but it fixes the bug and gets you back online.

 [1]: https://bugzilla.redhat.com/show_bug.cgi?id=1241930
 [2]: http://w1.fi/cgit/hostap/plain/wpa_supplicant/ChangeLog
 [3]: https://en.wikipedia.org/wiki/Extensible_Authentication_Protocol

[^4]: The support case is no longer accessible as of May 2021.