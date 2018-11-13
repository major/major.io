---
title: Kerberos for haters
author: Major Hayden
type: post
date: 2012-02-03T04:29:32+00:00
url: /2012/02/02/kerberos-for-haters/
dsq_thread_id:
  - 3642806825
categories:
  - Blog Posts
tags:
  - command line
  - fedora
  - kerberos
  - linux
  - network
  - networking
  - red hat
  - rhca
  - security
  - ssh

---
I'll be the first one to admit that Kerberos drives me a little insane. It's a requirement for two of the exams in [Red Hat's RHCA certification track][1] and I've been forced to learn it. It provides some pretty nice security features for large server environments. You get central single sign ons, encrypted authentication, and bidirectional validation. However, getting it configured can be a real pain due to some rather archaic commands and shells.

Here's Kerberos in a nutshell within a two-server environment: One server is a Kerberos key distribution center (KDC) and the other is a Kerberos client. The KDC has the list of users and their passwords. Consider a situation where a user tries to ssh into the Kerberos client:

  * sshd calls to pam to authenticate the user
  * pam calls to the KDC for a ticket granting ticket (TGT) to see if the user can authenticate
  * the KDC replies to the client with a TGT encrypted with the user's password
  * pam (on the client) tries to decrypt the TGT with the password that the user provided via ssh
  * if pam can decrypt the TGT, it knows the user is providing the right password

Now that the client has a a TGT for that user, it can ask for tickets to access other network services. What if the user who just logged in wants to access another Kerberized service in the environment?

  * client calls the KDC and asks for a ticket to grant access to the other service
  * KDC replies with two copies of the ticket:
      * one copy is encrypted with the user's current TGT
      * a second copy is encrypted with the password of the network service the user wants to access
  * the client can decrypt the ticket which was encrypted with the current TGT since it has the TGT already
  * client makes an authenticator by taking the decrypted ticket and encrypting it with a timestamp
  * client passes the authenticator and the second copy of the ticket it received from the KDC
  * the other network service decrypts the second copy of the ticket and verifies the password
  * the other network service uses the decrypted ticket to decrypt the authenticator it received from the client
  * if the timestamp looks good, the other network service allows the user access

Okay, that's confusing. Let's take it one step further. Enabling pre-authentication requires that clients send a request containing a timestamp encrypted with the user's password prior to asking for a TGT. Without this requirement, an attacker can ask for a TGT one time and then brute force the TGT offline. Pre-authentication forces the client to send a timestamped request encrypted with the user's password back to the KDC before they can ask for a TGT. This means the attacker is forced to try different passwords when encrypting the timestamp in the hopes that they'll get a TGT to work with eventually. One would hope that you have something configured on the KDC to set off an alarm for multiple failed pre-authentication attempts.

Oh, but we can totally kick it up another notch. What if an attacker is able to give a bad password to a client but they're also able to impersonate the KDC? They could reply to the TGT request (as the KDC) with a TGT encrypted with whichever password they choose and get access to the client system. Enabling mutual authentication stops this attack since it forces the client to ask the KDC for the client's own host principal password (this password is set when the client is configured to talk to the KDC). The attacker shouldn't have any clue what that password is and the attack will be thwarted.

By this point, you're either saying "Oh man, I don't ever want to do this." or "How do I set up Kerberos?". Stay tuned if you're in the second group. I'll have a dead simple (or as close to dead simple as one can get with Kerberos) how-to on the blog shortly.

In the meantime, here are a few links for extra Kerberos bedtime reading:

  * [Kerberos on Wikipedia][2]
  * [MIT's "Why Kerberos"][3] [PDF]
  * [How Kerberos Authentication Works][4]

 [1]: http://www.redhat.com/training/certifications/rhca/
 [2]: http://en.wikipedia.org/wiki/Kerberos_(protocol)
 [3]: http://www.kerberos.org/software/whykerberos.pdf
 [4]: http://learn-networking.com/network-security/how-kerberos-authentication-works
