---
title: Custom keyboard shortcuts for Evolution in GNOME
author: Major Hayden
date: 2015-11-28T05:33:29+00:00
url: /2015/11/27/custom-keyboard-shortcuts-for-evolution-in-gnome/
dsq_thread_id:
  - 4357033486
tags:
  - email
  - evolution
  - fedora
  - gnome
  - keyboard
  - mail

---
I've been a big fan of Thunderbird for years, but it lacks features in some critical areas. For example, I need Microsoft Exchange and Google Apps connectivity for my mail and contacts, but Thunderbird needs some extensions to make that connectivity easier. There are some great extensions available, but they lack polish since they're not part of the core product.

My muscle memory for keyboard shortcuts in Thunderbird left me fumbling in Evolution. Some of the basics that I used regularly, such as writing a new email or collapsing/expanding threads, were wildly different. For example, there's no keyboard shortcut for expanding threads in Evolution by default.

## The search

In my quest to adjust some of the default keyboard shortcuts for Evolution, I found lots of documentation about previous versions of GNOME in documentation and countless forum posts. None of the old tricks, like editable menus and easily adjusted dconf settings, work any longer.

I stumbled onto an [email thread][1] from August 2015 on this very topic and I was eager to find out if GNOME 3.18's Evolution would look at the same `.config/evolution/accels` file as the one mentioned in the thread.

First, I started Evolution with strace so I could review the system calls made during its startup:

```
strace -q -o evolution-trace.out -s 1500 evolution
```


Sure enough, Evolution was looking for the accels file:

```
$ grep accels evolution-trace.out
open("/home/user/.config/evolution/accels", O_RDONLY) = 10
open("/home/user/.config/evolution/accels", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 34
```


## Adding custom keyboard shortcuts

Editing the accels file is easy for most changes, but **be sure Evolution is stopped prior to editing the file**. The file should look something like this:

```
; evolution GtkAccelMap rc-file         -*- scheme -*-
; this file is an automated accelerator map dump
;
; (gtk_accel_path "<Actions>/new-source/memo-list-new" "")
; (gtk_accel_path "<Actions>/switcher/switch-to-tasks" "<Primary>4")
; (gtk_accel_path "<Actions>/mailto/add-to-address-book" "")
; (gtk_accel_path "<Actions>/mail/mail-next-thread" "")
```


Editing an existing shortcut is easy. For example, the default shortcut for creating a new email is CTRL-SHIFT-M:

```
m")
```


I prefer Thunderbird's default of CTRL-N for new emails:

```
n")
```


Those edits are quite easy, but things get interesting with other characters. For example, Thunderbird uses the asterisk (`*`) for expanding threads and backslash (`\`) for collapsing them. Those characters are special in the context of the `accels` file and they can't be used. Here's an example of how to set keyboard shortcuts with those:

```
/mail/mail-threads-expand-all" "asterisk")
(gtk_accel_path "<Actions>/mail/mail-threads-collapse-all" "backslash")
```


To determine the names of those special characters, use `xmodmap`:

```
$ xmodmap -pk | grep backslash
     51     0x005c (backslash)  0x007c (bar)    0x005c (backslash)  0x007c (bar)
```


## Checking your work

Once you make your adjustments, Evolution should display those new keyboard shortcuts in its menus. For example, here's my new shortcut for writing new emails:

[<img src="/wp-content/uploads/2015/11/evolution_shortcut.png" alt="evolution keyboard shortcuts" width="660" height="101" class="aligncenter size-full wp-image-6009" srcset="/wp-content/uploads/2015/11/evolution_shortcut.png 660w, /wp-content/uploads/2015/11/evolution_shortcut-300x46.png 300w" sizes="(max-width: 660px) 100vw, 660px" />][2]

Go back and adjust as many of the shortcuts as necessary. However, **remember to quit Evolution before editing the file**.

 [1]: https://mail.gnome.org/archives/evolution-list/2015-August/msg00068.html
 [2]: /wp-content/uploads/2015/11/evolution_shortcut.png
