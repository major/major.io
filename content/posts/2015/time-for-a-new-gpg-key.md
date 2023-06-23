---
aliases:
- /2015/06/11/time-for-a-new-gpg-key/
author: Major Hayden
date: 2015-06-11 19:14:03
dsq_thread_id:
- 3840975357
tags:
- fedora
- security
- yubikey
title: Time for a new GPG key
---

![1]

After an unfortunate death of my [Yubikey NEO][2] and a huge mistake on backups, I've come to realize that it's time for a new GPG key. My new one is already up on [Keybase][3] and there's a [plain text copy on my resume site][4].

### Action required

If you're using a key for me with a fingerprint of `6DC99178`, that one is no longer valid. My new one is `C1011FB1`.

For the impatient, here's the easiest way to retrieve my new key:

```
gpg2 --keyserver pgp.mit.edu --recv-key C1011FB1
```


### Lessons learned

Always ensure that you have complete backups of **all of your keys**. I made a mistake and forgot to back up my original signing subkey before I moved that key to my Yubikey. When the NEO died, so did the last copy of the most important subkey. It goes without saying but I don't plan on making that mistake again.

Always make a full backup of all keys and make a revocation certificate that also gets backed up. There's a [good guide on this topic][5] if you're new to the process.

### Wait. A Yubikey stopped working?

This is the first Yubikey failure that I've ever experienced. I've had two regular Yubikeys that are still working but this is my first NEO.

I emailed Yubico support earlier today about the problem and received an email back within 10-15 minutes. They offered me a replacement NEO with free shipping. It's still a bummer about the failure but at least they worked quickly to get me a free replacement.

 [1]: /wp-content/uploads/2015/06/YubiKey-NEO-finger.jpg
 [2]: https://www.yubico.com/products/yubikey-hardware/yubikey-neo/
 [3]: https://keybase.io/mhayden
 [4]: http://majorhayden.com/pgp.txt
 [5]: https://alexcabal.com/creating-the-perfect-gpg-keypair/