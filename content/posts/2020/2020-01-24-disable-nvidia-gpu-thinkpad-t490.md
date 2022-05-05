---
author: Major Hayden
categories:
- Blog Posts
date: '2020-01-24'
summary: The Lenovo ThinkPad T490 is a great laptop, but it comes with some discrete
  GPU challenges.
images:
- images/20191212-t490.png
slug: disable-nvidia-gpu-thinkpad-t490
tags:
- fedora
- lenovo
- linux
- thinkpad
- nvidia
title: Disable Nvidia GPU on the Thinkpad T490
type: post
---

{{< figure src="/images/20191212-t490.png" alt="Lenovo ThinkPad T490" position="center" >}}

I wrote about [installing Linux on the Lenovo ThinkPad T490 last month] and
one of the biggest challenges was getting graphics working properly. The T490
comes with an option where you can get a discrete Nvidia MX250 GPU and it
packs plenty of power in a small footprint.

It also brings along a few issues.

[installing Linux on the Lenovo ThinkPad T490 last month]: /2019/12/12/thinkpad-t490-fedora-install-tips/

## Awful battery life

There are many times where it would be helpful to fully disable the Nvidia
card to extend battery life when graphics processing is not needed. The MX250
is a Pascal family GPU and those GPUs require signed drivers, so nouveau will
not work.

There is a handy kernel feature called [VGA Switcheroo] _(yes, that is the
name)_. It gives you a quick method for turning the GPU on and off.
Unfortunately, that does require the nouveau module to work with the card.

The Nvidia drivers attempt to take the card into a low power mode called P8,
but it's not low enough. Removing the `nvidia` module causes the card to run
with full power and that makes things even worse.

Darn. It's time to fix some other problems. 😟

[VGA Switcheroo]: https://01.org/linuxgraphics/gfx-docs/drm/gpu/vga-switcheroo.html

## Suspend and resume

There are issues with suspend and resume with the Nvidia drivers after Linux
4.8. If you close the lid on the laptop, the laptop suspends properly and you
can see the pulsating LED light on the lid.

Open the lid after a few seconds and you will see a black screen (possibly
with a kernel trace) that looks like this:

```text
[   51.435212] ACPI: Waking up from system sleep state S3
[   51.517986] ACPI: EC: interrupt unblocked
[   51.567244] nvidia 0000:2d:00.0: Refused to change power state, currently in D3
```

The laptop will lock up and the fans will spin up shortly after. The only
remedy is a hard power off.

This is related to a Nvidia driver bug that surfaced after Linux 4.8 added
[per-port PCIe power management]. That feature allows the kernels to handle
PCIe power management for each port individually. It helps certain PCIe devies
(or portions of those devices) to go into various power saving modes
independently.

You can work around this issue by adding `pcie_port_pm=off` to your kernel
command line. I added it and my suspend/resume worked well after a reboot.

This leads to another problem:

## Even worse battery life

Getting suspend and resume back was a nice improvement, but I noticed that my
battery life dropped significantly. I went from 6 hours (which was not great)
down to 3-4 hours. That's terrible.

I booted my laptop into i3wm and ran `powertop` in a terminal. The idle power
usage bounced between 10-12 watts with a single terminal open and i3status
updating my status line.

So I was left with a choice:

* Leave the Nvidia card enabled with `pcie_port_pm=off` set, enjoy my
  suspend/resume, and suffer through terrible battery life 😫

* Remove `pcie_port_pm=off`, save battery life, and deal with hard lockups if
  I attempt to suspend 😭

Both options were terrible.

I knew there was only one good choice: **find a way to disable the Nvidia card
by default and only enable it when I need it**.

[per-port PCIe power management]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.4_release_notes/chap-red_hat_enterprise_linux-7.4_release_notes-kernel_parameters_changes

## Digging deep

If you can't control your hardware well enough in the OS, and you can control
it in the BIOS, the only option remaining is to examine your ACPI tables. This
requires dumping the DSDT and SSDT tables from the laptop. These tables
provide a map of instructions for taking all kinds of actions with the
hardware on the laptop, including turning devices on and off.

🔥 **DISCLAIMER: Tinkering with DSDT and SSDT files can damage your machine
if you are not familiar with the process. All changes in these files must be
made with extreme care and you should try the *smallest* possible change first
to reduce the risks.**

We need some tools to dump the ACPI tables and decompile them into a DSL that
we can read as humans:

```text
dnf install acpica-tools
```

Make a directory to hold the files and dump the ACPI tables:

```text
mkdir ~/dsdt
cd ~/dsdt
sudo acpidump -b
```

You should have plenty of files ending in `.dat` in the directory. These are
the compiled ACPI tables and they are difficult to read unless you love hex.
You can decompile them with `iasl` and move the compiled files out of the way:

```text
iasl -d *.dat
mkdir raw
mv *.dat raw/
```

You can find the decompiled files in my [T490 DSDT repository on GitLab].

We need to find some details on the discrete GPU. Running a `grep` on the
`.dsl` files in the directory shows some mentions in the `ssdt10.dsl`:

```text
  {
      Local0 [One] = 0x03
      TGPU = \_SB.PCI0.LPCB.EC.HKEY.GPTL /* External reference */
      Local0 [0x08] = TGPU /* \_SB_.PCI0.RP09.PEGP.TGPU */
      Return (Local0)
  }
```

So the GPU is represented in the ACPI tables as `SB_.PCI0.RP09.PEGP`. Let's
grep for that:

```text
$ grep -l SB_.PCI0.RP09.PEGP *.dsl
dsdt.dsl
ssdt10.dsl
ssdt11.dsl
ssdt14.dsl
```

So the card appears in `ssdt11.dsl`. Examine that file and you will
find:

```text
  Method (_ON, 0, Serialized)  // _ON_: Power On
  {
      D8XH (Zero, 0x11)
      If ((TDGC == One))
      {
          If ((DGCX == 0x03))
          {
              _STA = One
              \_SB.PCI0.RP09.PEGP.GC6O ()
          }
          ElseIf ((DGCX == 0x04))
          {
              _STA = One
              \_SB.PCI0.RP09.PEGP.GC6O ()
          }

          TDGC = Zero
          DGCX = Zero
      }
      ElseIf ((OSYS != 0x07D9))
      {
          PCMR = 0x07
          PWRS = Zero
          Sleep (0x10)
          \_SB.PCI0.HGON () // <---- This is where it turns on!
          _STA = One
      }

      D8XH (Zero, 0x12)
  }

```

When the `_ON` method is called, it calls `\_SB.PCI0.HGON ()` and that turns
on the card. There's another method called `\_SB.PCI0.HGOF ()` that turns off
the card.

Let's try changing any instances of `HGON` to `HGOF`. It's dirty, but it just
might work. There are two calls to `HGON` in `ssdt11.dsl` and I changed both
to `HSOF`. This should cause the card to be turned off when the system boots (and the `_INI` methods are called).

We need to make one more change so that the kernel will know our patched SSDT file is newer than the one in the BIOS. Look for this line at the top of `ssdt11.dsl`:

```text
DefinitionBlock ("", "SSDT", 2, "LENOVO", "SgRpSsdt", 0x00001000)
```

Change the number at the very end so that it is incremented by one:

```text
DefinitionBlock ("", "SSDT", 2, "LENOVO", "SgRpSsdt", 0x00001001)
```

Now we need to compile the SSDT

```text
iasl -tc ssdt11.dsl
```

The easiest method for loading the SSDT table is to patch it during the initrd
step. We need to pack the file into a cpio archive:

```text
mkdir -p /tmp/fix-nvidia/kernel/firmware/acpi
cd /tmp/fix-nvidia
cp ~/dsdt/ssdt11.aml kernel/firmware/acpi
find kernel | cpio -H newc --create > acpi_override
sudo cp acpi_override /boot/
```

Now we can carefully edit the bootloader options by adding
`initrd /acpi_override` to our current kernel entry. These are found in
`/boot/loader/entries` and are named based on the kernel they load. In my
case, the bootloader config for 5.4.12 is in
`/boot/loader/entries/d95743f260b941dcb518e3fcd3a02fa9-5.4.12-200.fc31.x86_64.conf`.

The file should look like this afterwards:

```text
title Fedora (5.4.12-200.fc31.x86_64) 31 (Thirty One)
version 5.4.12-200.fc31.x86_64
linux /vmlinuz-5.4.12-200.fc31.x86_64
initrd /acpi_override
initrd /initramfs-5.4.12-200.fc31.x86_64.img
options $kernelopts
grub_users $grub_users
grub_arg --unrestricted
grub_class kernel
```

The `initrd /acpi_override` line is the one I added.

Reboot your laptop. After the boot, look for the SSDT lines in `dmesg`:

```text
$ dmesg | egrep -i "ssdt|dsdt"
[    0.018597] ACPI: SSDT ACPI table found in initrd [kernel/firmware/acpi/ssdt11.aml][0xe28]
[    0.018813] ACPI: Table Upgrade: override [SSDT-LENOVO-SgRpSsdt]
[    0.018816] ACPI: SSDT 0x000000008780E000 Physical table override, new table: 0x0000000086781000
```

Now look for Nvidia:

```text
$ nvidia-smi
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver.
Make sure that the latest NVIDIA driver is installed and running.
```

Success! My laptop is now hovering around 4.5-5.5 watts. That's half of what
it was before! 🎊 🎉 🥳

## But sometimes I want my dGPU

Okay, there *are* some times where the discrete GPU is nice. Let's edit the
SSDT table once more to add an option to enable it at boot time with a kernel
command line option.

Here are the changes needed for `ssdt11.dsl`:

```diff
diff --git a/ssdt11.dsl b/ssdt11.dsl
index fd9042f05376aa80e3b94c1d6313e69cbb495c34..f75b43f57655553c5ced7a2595ad2b48f26b2c10 100644
--- a/ssdt11.dsl
+++ b/ssdt11.dsl
@@ -337,7 +337,17 @@ DefinitionBlock ("", "SSDT", 2, "LENOVO", "SgRpSsdt", 0x00001000)
                             PCMR = 0x07
                             PWRS = Zero
                             Sleep (0x10)
-                            \_SB.PCI0.HGON ()
+
+                            // Set this ACPI OSI flag to enable the dGPU.
+                            If (\_OSI ("T490-Hybrid-Graphics"))
+                            {
+                                \_SB.PCI0.HGON ()
+                            }
+                            Else
+                            {
+                                \_SB.PCI0.HGOF ()
+                            }
+
                             _STA = One
                         }

@@ -449,7 +459,15 @@ DefinitionBlock ("", "SSDT", 2, "LENOVO", "SgRpSsdt", 0x00001000)

                     Method (_ON, 0, Serialized)  // _ON_: Power On
                     {
-                        \_SB.PCI0.HGON ()
+                        // Set this ACPI OSI flag to enable the dGPU.
+                        If (\_OSI ("T490-Hybrid-Graphics"))
+                        {
+                            \_SB.PCI0.HGON ()
+                        }
+                        Else
+                        {
+                            \_SB.PCI0.HGOF ()
+                        }
                         Return (Zero)
                     }
```

Follow the same steps as before to compile the SSDT, pack it into a cpio
archive, and copy it to `/boot/acpi_override`. Now you can add
`acpi_osi='T490-Hybrid-Graphics'` to your kernel command line whenever you
want to use your Nvidia card. You won't need to mess with SSDT tables again to
make it work.

I hope this guide was helpful! Keep in mind that future BIOS updates may
change your ACPI tables and this fix may stop working. You may need to look around for the changes and adjust your changes to match.

[T490 DSDT repository on GitLab]: https://gitlab.com/majorhayden/t490-dsdt
