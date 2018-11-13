---
title: Encrypted filesystems and partitions on RHEL 5
author: Major Hayden
type: post
date: 2008-09-02T01:55:36+00:00
url: /2008/09/01/encrypted-filesystems-and-partitions-on-rhel-5/
dsq_thread_id:
  - 3642771829
categories:
  - Blog Posts
tags:
  - encryption
  - red hat
  - security

---
I spoke with a customer last week who was curious about enabling encrypted partitions on a DAS connected to their server.  I wasn't entirely sure if it was possible in RHEL 5 since I couldn't remember if it was available in Fedora 6.  According to [Red Hat's release notes][1], it is possible.  Here's an excerpt from their release notes: 

> Encrypted Swap Partitions and Non-root File Systems

> Red Hat Enterprise Linux 5 now provides basic support for encrypted swap partitions and non-root file systems. To use these features, add the appropriate entries to /etc/crypttab and reference the created devices in /etc/fstab.
>
> Below is a sample /etc/crypttab entry:
>
> my_swap /dev/hdb1 /dev/urandom swap,cipher=aes-cbc-essiv:sha256

> This creates the encrypted block device /dev/mapper/my_swap, which can be referenced in /etc/fstab.
>
> Below is a sample /etc/crypttab entry for a file system volume:
>
> my\_volume /dev/hda5 /etc/volume\_key cipher=aes-cbc-essiv:sha256

> The /etc/volume_key file contains a plaintext encryption key. You can also specify none as the key file name; this configures the system to ask for the encryption key during boot instead.
>
> It is recommended to use LUKS (Linux Unified Key Setup) for setting up file system volumes. To do this, follow these steps:
>
> Create the encrypted volume using cryptsetup luksFormat.
>
> Add the necessary entry to /etc/crypttab.
>
> Set up the volume manually using cryptsetup luksOpen (or reboot).
>
> Create a file system on the encrypted volume.
>
> Add the necessary entry to /etc/fstab.

After scouring the Red Hat Enterprise Linux manuals and knowledge base, I couldn't find specific instructions to set it up. However, there was an [article in the Red Hat Magazine][2] that may help.

 [1]: http://www.redhat.com/docs/manuals/enterprise/RHEL-5-manual/release-notes/RELEASE-NOTES-x86-en.html
 [2]: http://www.redhatmagazine.com/2007/01/18/disk-encryption-in-fedora-past-present-and-future/
