---
author: Major Hayden
date: '2026-07-28'
summary: Mounting virtual media on an older Supermicro IPMI system isn't fun, but I found a new way to do it from the command line that requires a lot less wrestling with Java.
tags:
- fedora
- hardware
- ipmi
- linux
- supermicro
title: Mount virtual media on Supermicro IPMI with less java
---

It's been a while since I rented a dedicated server for my own personal infrastructure, but with the prices I've seen lately on cloud and virtual infrastructure, getting my own server seemed like a better detal.
I prefer to do my own custom installation of Fedora Linux on my servers and this meant another deep dive into the world of Supermicro's IPMI interface, horribly old versions of Java, and lots of frustration.

With some help from Claude, I found a better way to mount virtual media! ✨

# Old BMC without HTML5

It turns out I rented a machine with a fairly old ATEN-based BMC without any support for Redfish and that means no HTML5 console access.
The Java console was the only remaining option.

Next, I downloaded Supermicro's standalone `IPMIView` client.
It launched and connected without an issue.
Once I tried to mount an ISO, I ended up with a crash:

```
SIGSEGV (0xb), JRE 11.0.25 (bundled)
Problematic frame: V [libjvm.so] jni_CallObjectMethodV+0x83
C [libSharedLibrary64.so] AppendDataIntegrity(unsigned char*, int)+0xc6
C [libSharedLibrary64.so] MtMethod_Media+0x105
C [libSharedLibrary64.so] MtVM_Engine+0xba
C [libSharedLibrary64.so] Core_Mount_VM+0x45
C [libSharedLibrary64.so] UI_Mount_VM+0x227
C [libSharedLibrary64.so] Java_tw_com_aten_vstorage_VirtualStorage_VUSPlugIn+0x146
j  tw.com.aten.vstorage.VirtualStorage.VUSPlugIn(...)
```

I tried bumping the java heap size and it didn't help.
Downgrading IPMIView didn't help either.
I even loaded up a Windows virtual machine with IPMIView and it crashed there, too.

# What actually worked: SMCIPMITool

Supermicro ships another utility called `SMCIPMITool` that talks to the BMC in a different way than the GUI does.
I always prefer a command line tool over a Java GUI. 😉

1. **Download SMCIPMITool** from Supermicro: `https://www.supermicro.com/wdl/utility/SMCIPMItool/`

2. **Extract it:**

   ```bash
   $ tar xzf SMCIPMITool_<version>_bundleJRE_Linux_x64.tar.gz
   $ cd SMCIPMITool_<version>_bundleJRE_Linux_x64
   ```

3. **Confirm that the basic IPMI auth works** before touching virtual media. If your account isn't a full `ADMINISTRATOR`, specify the privilege level explicitly:

   ```bash
   $ ipmitool -I lanplus -L OPERATOR -H <bmc-ip> -U <user> -P '<password>' chassis status
   ```

   If this fails with a cipher suite error, try `-C 1`, `-C 2`, or `-C 3`.

4. **Launch SMCIPMITool in interactive shell mode.** This is required — the `vmwa` subcommands don't work as one-shot CLI arguments:

   ```bash
   $ ./SMCIPMITool <bmc-ip> <user> '<password>' shell
   ```

   Ignore any `Cannot login to <bmc-ip>` banner printed at startup. That's an unrelated SNMP trap-receiver warning, not an auth failure.

5. **List the `vmwa` subcommands** at the shell prompt to confirm the tool is talking to the BMC correctly:

   ```
   vmwa
   ```

6. **Mount the ISO** on virtual device 2 (device 2 is CD/DVD/ISO; device 1 is HDD/USB/floppy):

   ```
   vmwa dev2iso /full/path/to/your.iso
   ```

   You may see a `com.supermicro.ipmi.IPMIException` stack trace print first — that's a non-fatal internal retry. Look for the actual result right after it:

   ```
   Mounting ISO file: /full/path/to/your.iso
   Device 2 :VM Plug-In OK!!
   ```

7. **Verify the mount:**

   ```
   vmwa status
   ```

   You should see something like this:

   ```
   Device 2: ISO File [/full/path/to/your.iso]
   ```

8. **Keep the shell session open.**
   On this firmware, the mount is torn down the instant the shell exits — there's no detached or background mount mode.
   For an unattended mount-and-install, script it end-to-end instead of typing interactively:

   ```bash
   ( echo "vmwa dev2iso /full/path/to/your.iso"
     echo "vmwa status"
     sleep 3600          # keep mounted for up to an hour — adjust to your install time
     echo "vmwa dev2stop" ) | ./SMCIPMITool <bmc-ip> <user> '<password>' shell
   ```

9. **While that session is running**, set the next boot target to `USB CDROM` in the IPMIView tool.
   Then reboot the server.

10. The server should boot into the ISO that you mounted.
    The BMC network interface isn't very fast and you're also limited by your upload bandwidth, so be patient.

11. **When you're done**, either let the `sleep` in step 8 expire (it auto-unmounts via `vmwa dev2stop`), or run `vmwa dev2stop` manually in an active shell session to unmount immediately.

Here's the actual command I used, end to end:

```bash
$ D=~/Downloads/SMCIPMITool_2.27.2_build.230221_bundleJRE_Linux_x64
$ cd "$D"
$ ( echo "vmwa dev2iso /home/major/Downloads/Fedora-Server-netinst-x86_64-44-1.7.iso"
    echo "vmwa status"
    sleep 3600
    echo "vmwa dev2stop" ) | ./SMCIPMITool <bmc-ip> operator '<password>' shell
```


