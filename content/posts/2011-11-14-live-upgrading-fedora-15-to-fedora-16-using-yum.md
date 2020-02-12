---
title: Live upgrade Fedora 15 to Fedora 16 using yum
author: Major Hayden
type: post
date: 2011-11-15T04:37:39+00:00
url: /2011/11/14/live-upgrading-fedora-15-to-fedora-16-using-yum/
dsq_thread_id:
  - 3642806736
categories:
  - Blog Posts
tags:
  - centos
  - command line
  - fedora
  - linux
  - preupgrade
  - raid
  - red hat
  - scientific linux
  - sysadmin
  - yum

---
Before we get started, I really ought to drop this here:

<blockquote style="color: red; font-weight: bold;">
  <p>
    Upgrading Fedora via yum is <u>not</u> the recommended method. Your first choice for upgrading Fedora should be to use <code>preupgrade</code>. Seriously.
  </p>
</blockquote>

[<img src="/wp-content/uploads/2011/11/Logo_fedoralogo-300x91.png" alt="" title="Logo_fedoralogo" width="300" height="91" class="alignright size-medium wp-image-2662" srcset="/wp-content/uploads/2011/11/Logo_fedoralogo-300x91.png 300w, /wp-content/uploads/2011/11/Logo_fedoralogo.png 600w" sizes="(max-width: 300px) 100vw, 300px" />][1]This begs the question: _When should you use another method to upgrade Fedora? What other methods are there?_

You have a few other methods to get the upgrade done:

  * **Toss in a CD or DVD:** You can upgrade via the anaconda installer provided on the CD, DVD or netinstall media. My experiences with this method for Fedora (as well as CentOS, Scientific Linux, and Red Hat) haven't been too positive, but your results may vary.
  * **Download the newer release's fedora-release RPM, install it with `rpm`, and `yum upgrade`:** This is the really old way of doing things. Don't try this (read the next bullet).
  * **Use `yum`'s distro-sync functionality:** If you can't go the `preupgrade` route, I'd recommend giving this a try. However, leave plenty of time to fix small glitches after it's done (and after your first reboot).

**Personal anecdote time** _(Keep scrolling for the meat and potatoes)_

I have a dedicated server at [Joe's Datacenter][2] (love those folks) with IPMI and KVM-over-LAN access. The `preupgrade` method won't work for me because my `/boot` partition is on a software RAID volume. There's a [rat's nest of a Bugzilla ticket][3] over on Red Hat's site about this problem. I'm really only left with a live upgrade using `yum`.

**Live `yum` upgrade process**

Before even beginning the upgrade, I double-checked that I'd applied all of the available updates for my server. Once that was done, I realized I was one kernel revision behind and I rebooted to ensure I was in the latest Fedora 15 kernel.

A good practice here is to run `package-cleanup --orphans` (it's in the `yum-utils` package) to find any packages which don't exist on any Fedora mirrors. In my case, I had two old kernels and a JungleDisk package. I removed the two old kernels (probably wasn't necessary) and left JungleDisk alone (it worked fine after the upgrade). If you have any external repositories, such as Livna or RPMForge, you may want to disable those until the upgrade is done. Should the initial upgrade checks bomb out, try adding as few repositories back in as possible to see if it clears up the problem.

Once you make it this far, just follow the instructions available in Fedora's documentation: [Upgrading Fedora using yum][4]. I set SELinux to permissive mode during the upgrade just in case it caused problems.

I'd recommend skipping the `grub2-install` portion since your original grub installation will still be present after the upgrade. If your server has EFI (not BIOS), **don't use** `grub2` yet. Keep an eye on the previously mentioned documentation page to see if the problems get ironed out between `grub2` and EFI.

**Before you reboot,** be sure to get a list of your active processes and daemons. After your reboot, some old SysVinit scripts will be converted into Systemd service scripts. They might not start automatically and you might need to enable and/or start some services.

New to Systemd? This will be an extremely handy resource: [SysVinit to Systemd Cheatsheet][5].

I haven't seen too many issues after cleaning up some daemons that didn't start properly. There is a problem between `asterisk` and SELinux that I haven't nailed down yet but it's not a showstopper.

Good luck during your upgrades. Keep in mind that Fedora 15 could be EOL'd as early as May or June 20102 when Fedora 17 is released.

 [1]: /wp-content/uploads/2011/11/Logo_fedoralogo.png
 [2]: http://joesdatacenter.com/
 [3]: https://bugzilla.redhat.com/show_bug.cgi?id=504826
 [4]: http://fedoraproject.org/wiki/Upgrading_Fedora_using_yum#Fedora_15_-.3E_Fedora_16
 [5]: http://fedoraproject.org/wiki/SysVinit_to_Systemd_Cheatsheet
