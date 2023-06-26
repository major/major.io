---
aliases:
- /2017/09/20/import-rpm-repository-keys-from-other-keyservers-temporarily/
author: Major Hayden
date: 2017-09-20 15:24:13
tags:
- ansible
- centos
- fedora
- openstack
- rpm
title: Import RPM repository GPG keys from other keyservers temporarily
---

I've been working through some patches to [OpenStack-Ansible][2] lately to optimize how we configure yum repositories in our deployments. During that work, I ran into some issues where pgp.mit.edu was returning 500 errors for some requests to retrieve GPG keys.

Ansible was returning this error:

```
curl: (22) The requested URL returned error: 502 Proxy Error
error: http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x61E8806C: import read failed(2)
```


How does the `rpm` command know which keyserver to use? Let's use the `--showrc` argument to show how it is configured:

```
$ rpm --showrc | grep hkp
-14: _hkp_keyserver http://pgp.mit.edu
-14: _hkp_keyserver_query   %{_hkp_keyserver}:11371/pks/lookup?op=get&search=0x
```


How do we change this value temporarily to test a GPG key retrieval from a different server? There's an argument for that as well: `--define`:

```
$ rpm --help | grep define
  -D, --define='MACRO EXPR'        define MACRO with value EXPR
```


We can assemble that on the command line to set a different keyserver temporarily:

```
# rpm -vv --define="%_hkp_keyserver http://pool.sks-keyservers.net" --import 0x61E8806C
-- SNIP --
D: adding "63deac79abe7ad80e147d671c2ac5bd1c8b3576e" to Sha1header index.
-- SNIP --
```


Let's verify that our new key is in place:

```
# rpm -qa | grep -i gpg-pubkey-61E8806C
gpg-pubkey-61e8806c-5581df56
# rpm -qi gpg-pubkey-61e8806c-5581df56
Name        : gpg-pubkey
Version     : 61e8806c
Release     : 5581df56
Architecture: (none)
Install Date: Wed 20 Sep 2017 10:17:11 AM CDT
Group       : Public Keys
Size        : 0
License     : pubkey
Signature   : (none)
Source RPM  : (none)
Build Date  : Wed 17 Jun 2015 03:57:58 PM CDT
Build Host  : localhost
Relocations : (not relocatable)
Packager    : CentOS Virtualization SIG (http://wiki.centos.org/SpecialInterestGroup/Virtualization) <security@centos.org>
Summary     : gpg(CentOS Virtualization SIG (http://wiki.centos.org/SpecialInterestGroup/Virtualization) <security@centos.org>)
Description :
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: rpm-4.11.3 (NSS-3)

mQENBFWB31YBCAC4dFmTzBDOcq4R1RbvQXLkyYfF+yXcsMA5kwZy7kjxnFqBoNPv
aAjFm3e5huTw2BMZW0viLGJrHZGnsXsE5iNmzom2UgCtrvcG2f65OFGlC1HZ3ajA
8ZIfdgNQkPpor61xqBCLzIsp55A7YuPNDvatk/+MqGdNv8Ug7iVmhQvI0p1bbaZR
0GuavmC5EZ/+mDlZ2kHIQOUoInHqLJaX7iw46iLRUnvJ1vATOzTnKidoFapjhzIt
i4ZSIRaalyJ4sT+oX4CoRzerNnUtIe2k9Hw6cEu4YKGCO7nnuXjMKz7Nz5GgP2Ou
zIA/fcOmQkSGcn7FoXybWJ8DqBExvkJuDljPABEBAAG0bENlbnRPUyBWaXJ0dWFs
aXphdGlvbiBTSUcgKGh0dHA6Ly93aWtpLmNlbnRvcy5vcmcvU3BlY2lhbEludGVy
ZXN0R3JvdXAvVmlydHVhbGl6YXRpb24pIDxzZWN1cml0eUBjZW50b3Mub3JnPokB
OQQTAQIAIwUCVYHfVgIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHrr
voJh6IBsRd0H/A62i5CqfftuySOCE95xMxZRw8+voWO84QS9zYvDEnzcEQpNnHyo
FNZTpKOghIDtETWxzpY2ThLixcZOTubT+6hUL1n+cuLDVMu4OVXBPoUkRy56defc
qkWR+UVwQitmlq1ngzwmqVZaB8Hf/mFZiB3B3Jr4dvVgWXRv58jcXFOPb8DdUoAc
S3u/FLvri92lCaXu08p8YSpFOfT5T55kFICeneqETNYS2E3iKLipHFOLh7EWGM5b
Wsr7o0r+KltI4Ehy/TjvNX16fa/t9p5pUs8rKyG8SZndxJCsk0MW55G9HFvQ0FmP
A6vX9WQmbP+ml7jsUxtEJ6MOGJ39jmaUvPc=
=ZzP+
-----END PGP PUBLIC KEY BLOCK-----

```


Success!

If you want to override the value permanently, create a `~/.rpmmacros` file and add the following line to it:

```
%_hkp_keyserver http://pool.sks-keyservers.net
```


_Photo credit: [Wikipedia][3]_

 [2]: https://github.com/openstack/openstack-ansible
 [3]: https://commons.wikimedia.org/wiki/File:Close-up_of_keys.jpg