---
author: Major Hayden
date: '2022-08-05'
summary: >-
  Add encrypted ssh keys to your workflow more efficiently with gnome-keyring
  in the sway window manager.
tags:
  - fedora
  - gnome
  - security
  - ssh
  - sway
title: Use GNOME Keyring with Sway
---

[SSH key authentication] makes it easier to secure SSH servers and it opens the door to automation with projects such as [Ansible].
However, working with encrypted SSH keys becomes tedious when you have several of them for different services.
This is where an SSH agent can help!

But before we talk about SSH agents:

{{< figure src="padme-encrypts-ssh-keys.jpg" alt="Padme meme where she asks Anakin about encrypting his ssh keys" default="true" class="text-center" >}}

_You do, don't you?_ 🤔

# Encrypting an existing ssh key

I won't tell anyone, but if you happen to have unencrypted SSH keys laying around (which I'm sure you don't), I'll give you a quick primer on encrypting them.
But you surely won't need these instructions.
I'll do it anyway.

Hop into your `~/.ssh` directory and encrypt the key with `ssh-keygen`:

```console
$ cd ~/.ssh
$ ssh-keygen -o -p -f my_private_key_filename
```

If the first response from `ssh-keygen` says `Enter new passphrase`, then you have an unencrypted key.
If it says `Enter old passphrase:` instead, your private key is already encrypted.
You can proceed through the prompts to set the password on the key.

# Agents can help

One thing you quickly notice when you have a fleet of encrypted SSH keys is that you are constantly entering passwords.
That's tedious.
Instead, an agent helps you enter a password for a key one time per session.
Every time to use the key after that first time, the agent steps in to help. 🕵🏻

It goes something like this:

1. You ssh to another server using `ssh alice@server`
2. Your ssh client hands over your public key to the remote server
3. The remote server says _"Okay, I've been told this key is from a user I can trust. How about you sign this with your private key so I know it's you?"_
4. Your ssh client takes the request from the remote server and hands it to the agent
5. The agent signs the message for the client
6. Your client sends the signed message back to the server
7. The server verifies the signature
8. The ssh connection is connected 🎊

There are some really important things to note here:

* The agent holds the key or certificate in an unencrypted state in memory
* The agent doesn't write anything to the disk
* Your password is not stored in memory once the initial decryption with `ssh-add` is done
* Communication happens over a Unix socket that is owned by only your user

This setup is far better than entering passwords over and over again, but if you forget to use `ssh-add` before connecting to another server, you can get stuck in a loop like I do:

* Open ssh connection to a server
* _"Darn, I have to put in my password. I should have used `ssh-add`"_ 🤦🏻‍♂️
* Time passes
* Open ssh connection to another server
* _"Oh my gosh, I forgot `ssh-add` again!"_ 😱

Luckily, there's a better way.

# Adding GNOME Keyring

[GNOME Keyring] has been around for many years and it provides tons of helpful features.
You can store secrets, certificates, and SSH keys in the keyring.
The keyring prompts you for a password when you log in to unlock the keyring and it locks again on reboot or shutdown.

It also provides ssh-agent functionality with a key difference: when it asks you for your SSH key password one time, it stores it for the next time.
That means no `ssh-add` doom loops like I talked about earlier.
You run `ssh` to connect to a server, get prompted for the key's password, and that's it.
That key won't need to be decrypted again as long as your session is active.

Let's look at the options for `gnome-keyring-daemon`:

```console
❯ gnome-keyring-daemon --help
Usage:
  gnome-keyring-daemon [OPTION…] - The Gnome Keyring Daemon

Help Options:
  -h, --help                              Show help options

Application Options:
  -s, --start                             Start a dameon or initialize an already running daemon.
  -r, --replace                           Replace the daemon for this desktop login environment.
  -f, --foreground                        Run in the foreground
  -d, --daemonize                         Run as a daemon
  -l, --login                             Run by PAM for a user login. Read login password from stdin
  --unlock                                Prompt for login keyring password, or read from stdin
  -c, --components=pkcs11,secrets,ssh     The optional components to run
  -C, --control-directory                 The directory for sockets and control data
  -V, --version                           Show the version number and exit.
```

You'll notice that the default set of components includes `ssh` for the ssh-agent functionality.
However, Fedora handles things a little differently by default:

```console
❯ rpm -ql gnome-keyring | grep user   
/usr/lib/systemd/user/gnome-keyring-daemon.service
/usr/lib/systemd/user/gnome-keyring-daemon.socket

❯ cat /usr/lib/systemd/user/gnome-keyring-daemon.service
[Unit]
Description=GNOME Keyring daemon

Requires=gnome-keyring-daemon.socket

[Service]
Type=simple
StandardError=journal
ExecStart=/usr/bin/gnome-keyring-daemon --foreground --components="pkcs11,secrets" --control-directory=%t/keyring
Restart=on-failure

[Install]
Also=gnome-keyring-daemon.socket
WantedBy=default.target
```

The `ssh` component is missing from the user systemd unit! 😱

Let's start by copying this unit to our systemd user unit directory so we can modify it:

```console
❯ mkdir -vp ~/.config/systemd/user/
❯ cp /usr/lib/systemd/user/gnome-keyring-daemon.service ~/.config/systemd/user/
```

Open `~/.config/systemd/user/gnome-keyring-daemon.service` in your favorite text editor and add `ssh` to the `--components` argument so it looks like this:

```console
❯ grep components ~/.config/systemd/user/gnome-keyring-daemon.service
ExecStart=/usr/bin/gnome-keyring-daemon --foreground --components="pkcs11,secrets,ssh" --control-directory=%t/keyring
```

Let's reload the systemd user units and start the service:

```console
❯ systemctl daemon-reload --user
❯ systemctl enable --now --user gnome-keyring-daemon 
❯ systemctl status --user gnome-keyring-daemon
● gnome-keyring-daemon.service - GNOME Keyring daemon
     Loaded: loaded (/home/major/.config/systemd/user/gnome-keyring-daemon.service; enabled; vendor preset: disabled)
     Active: active (running) since Fri 2022-08-05 10:34:55 CDT; 4h 2min ago
TriggeredBy: ● gnome-keyring-daemon.socket
   Main PID: 63261 (gnome-keyring-d)
      Tasks: 5 (limit: 38353)
     Memory: 2.9M
        CPU: 533ms
     CGroup: /user.slice/user-1000.slice/user@1000.service/app.slice/gnome-keyring-daemon.service
             ├─ 63261 /usr/bin/gnome-keyring-daemon --foreground --components=pkcs11,secrets,ssh --control-directory=/run/user/1000/keyring
             └─ 63789 /usr/bin/ssh-agent -D -a /run/user/1000/keyring/.ssh

Aug 05 10:34:55 amdbox systemd[4324]: Started gnome-keyring-daemon.service - GNOME Keyring daemon.
Aug 05 10:34:55 amdbox gnome-keyring-daemon[63261]: GNOME_KEYRING_CONTROL=/run/user/1000/keyring
Aug 05 10:34:55 amdbox gnome-keyring-daemon[63261]: SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
```

Awesome! There's only one last step.
The SSH client needs to know where to look for the agent socket.
The last line of the status output line shows the answer: `SSH_AUTH_SOCK=/run/user/1000/keyring/ssh`

Open your `~/.bashrc` or `~/.zshrc` (or whatever you use for your shell) and add this line:

```shell
export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
```

Open a new terminal or reload your shell with `source ~/.bashrc` or `source ~/.zshrc`.
Run `ssh` to connect to a server with an encrypted key and you should get a password prompt like this one:

{{< figure src="password-prompt.png" alt="Password prompt from GNOME Keyring" class="justify-center" default="true" >}}

# Extra credit

GNOME Keyring "just works" for 99% of my tasks, but sometimes I want to adjust a key or read a secret quickly.
For that, give [Seahorse] a try.
It's a graphical application that gives you access to everything GNOME Keyring stores and you can quickly lock your keyring at any time.
The [Arch documentation on GNOME Keyring] also has plenty of tips for more automation and how to handle corner cases.

[SSH key authentication]: https://en.wikipedia.org/wiki/Secure_Shell#Authentication:_OpenSSH_key_management
[Ansible]: https://www.ansible.com/
[GNOME Keyring]: https://wiki.gnome.org/Projects/GnomeKeyring
[Seahorse]: https://wiki.gnome.org/Apps/Seahorse
[Arch documentation on GNOME Keyring]: https://wiki.archlinux.org/title/GNOME/Keyring
