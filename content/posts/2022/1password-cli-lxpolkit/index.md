---
author: Major Hayden
date: '2022-12-30'
summary: 1Password's CLI tool connects via PolicyKit to the 1Password application for authentication, but this isn't the easiest in i3. 🔑 
tags:
  - 1password
  - i3
  - policykit
  - security
title: Connect 1Password's CLI and app in i3 with lxpolkit 
---

[Bitwarden](https://bitwarden.com/) became my go-to password manager a few years ago after I finally abandoned LastPass.
Once I read the recent news about [stolen password vaults](https://www.theverge.com/2022/12/28/23529547/lastpass-vault-breach-disclosure-encryption-cybersecurity-rebuttal), I was even happier that I made the switch.

My original password manager from way back in my Apple days was [1Password](https://1password.com/).
It had a great user interface on the Mac and on iPhones, but I found it frustrating to use when I switched to Linux laptops and Android phones.

Lots of people in my Mastodon timeline were singing the praises of 1Password's security and user interface after the recent LastPass news, so I decided to give it another look.
It has a great CLI now and the GUI application runs well in Linux.
The CLI also connects to the application via [PolicyKit](https://policykit.org/) and it has some helpful plugins for various other CLI tools, like the AWS cli.

I decided to give 1Password another try, but then I ran into a problem with the CLI. 🤔

🏃 In a hurry? [Go straight to the fix.](#the-fix)

# Authentication problems

The 1Password application was up and running and I followed the [documented steps](https://support.1password.com/system-authentication-linux/) for enabling Linux authentication for the CLI.
However, I still couldn't authenticate:

```console
$ op item list --vault Private
[ERROR] 2022/12/31 11:26:54 authorization prompt dismissed, please try again
```

The 1Password documentation says that the application will automatically write a polkit action file at `/usr/share/polkit-1/actions/com.1password.1Password.policy` to handle the authentication and that file was present:

```console
$ ls -al /usr/share/polkit-1/actions/com.1password.1Password.policy
-rw-r--r--. 1 root root 1508 Dec 29 09:48 /usr/share/polkit-1/actions/com.1password.1Password.policy
```

In addition, the PolicyKit daemon is running:

```console
$ ps aufx | grep polkit
polkitd     1293  0.0  0.0 2692700 26736 ?       Ssl  10:47   0:00 /usr/lib/polkit-1/polkitd --no-debug
$ rpm -qf /usr/lib/polkit-1/polkitd
polkit-121-4.fc37.x86_64
```

# Putting it together

Then I stopped to think about what the system was telling me:

* 1Password's CLI says that the authentication prompt is being dismissed
* I never saw an authentication prompt
* The PolicyKit daemon is running properly without errors
* Running `strace` on `polkitd` and `op` showed everything looking good

But wait, the policykit daemon is only half of what I needed.
There needs to be some type of window manager integration to pop up an authentication prompt and I wasn't seeing that prompt.

On i3, I use `lxpolkit` for policykit integration and it should have popped up some kind of prompt for me.
`lxpolkit` is installed:

```console
$ rpm -q lxpolkit
lxpolkit-0.5.5-8.D20210419git82580e45.fc37.x86_64
```

Then I noticed something strange.
The actual `lxpolkit` daemon that handles the authentication prompts was not running even though it was configured to automatically start as soon as I logged in:

```console
$ rpm -ql lxpolkit | grep autostart
/etc/xdg/autostart/lxpolkit.desktop
$ pgrep lxpolkit
# Nothing here
```

My default i3 configuration starts all of these automatically with `dex-autostart`:

```console
$ grep dex ~/.config/i3/config
exec --no-startup-id dex-autostart --autostart --environment i3
```

Then I saw the issue at the very end of the `lxpolkit` desktop file:

```console
$ tail /etc/xdg/autostart/lxpolkit.desktop
Comment[tr]=Policykit Kimlik Doğrulama Aracı
Comment[uk]=Агент авторизації Policykit
Comment[zh_CN]=Policykit 认证代理
Comment[zh_TW]=Policykit 身分核對代理程式
Exec=lxpolkit
TryExec=lxpolkit
Icon=gtk-dialog-authentication
Hidden=true
X-Desktop-File-Install-Version=0.26
OnlyShowIn=LXDE;
```

The `OnlyShowIn=LXDE` means that `dex-autostart` will skip it when the environment is set to `i3`!🤦‍♂️

# The fix

I copied the desktop file into my local autostart directory and removed the last line:

```console
$ cp /etc/xdg/autostart/lxpolkit.desktop ~/.config/autostart/
$ tail -n 5 ~/.config/autostart/lxpolkit.desktop
Exec=lxpolkit
TryExec=lxpolkit
Icon=gtk-dialog-authentication
Hidden=true
X-Desktop-File-Install-Version=0.26
```

Then I ran `dex-autostart` manually to ensure it worked:

```console
# dex-autostart --autostart --environment i3 --verbose
Autostart file: /home/major/.config/autostart/lxpolkit.desktop
Executing command: lxpolkit
```

Success!

```console
$ ps aufx |grep lxpolkit
major      20432  0.0  0.0 393124 12304 pts/3    Sl   11:54   0:00 lxpolkit
```

I tried the 1Password command line application one more time...

{{< figure src="auth-prompt.png" alt="1Password auth prompt via policykit" default=true >}}

It worked!
As long as the 1Password application is running and unlocked, I can use the `op` CLI tool with my normal Linux system authentication.
