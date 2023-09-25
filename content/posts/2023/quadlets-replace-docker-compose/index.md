---
author: Major Hayden
date: '2023-09-25'
summary: >
  Sure, docker-compose is great, but could we get similar functionality using just the
  tools that are built into CoreOS? Can we get automatic updates, too? Yes we can! 📦
tags:
  - containers
  - coreos
  - docker
  - fedora
  - linux
  - podman
  - wordpress
title: Quadlets might make me finally stop using docker-compose
coverAlt: Triangular road sign showing a turn to the right ahead
coverCaption: |
  Credit: [ide alien](https://unsplash.com/photos/daP2TOVFrJ8) via Unsplash
------

I've [written a lot about containers] on this blog.
Why do I love containers so much?

* They start quickly
* They make your workloads portable
* They disconnect your application stack from the OS that runs underneath
* You can send your application through CI as a single container image
* You can isolate workloads on the network and limit their resource usage much like a VM

However, I'm still addicted to [docker-compose].
Can podman's [quadlets] change that?

**Yes, I think they can.**

[written a lot about containers]: /tags/containers/
[docker-compose]: https://docs.docker.com/compose/
[quadlets]: https://www.redhat.com/sysadmin/quadlet-podman

# What's a quadlet?

Podman introduced support for quadlets in version 4.4 and it's a simpler way of letting systemd manage your containers.
There was an option in the past to have podman generate systemd unit files, but those were unwieldy and full of podman command line options inside a unit file.
These unit files weren't easy to edit or even parse with eyeballs.

Quadlets make this easier by giving you a simple ini-style file that you can easily read and edit.
This blog post will include some quadlets later, but here's an example one for Wordpress:

```ini
[Unit]
Description=Wordpress Quadlet

[Container]
Image=docker.io/library/wordpress:fpm
ContainerName=wordpress
AutoUpdate=registry
EnvironmentFile=/home/core/.config/containers/containers-environment
Volume=wordpress.volume:/var/www/html
Network=wordpress.network

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=caddy.service multi-user.target default.target
```

Lots of the lines under `[Container]` should look familiar to most readers who have worked with containers before.
However, there's something new here.

Check out the `AutoUpdate=registry` line.
This tells podman to keep your container updated on a regular basis with the upstream container registry.
I've used [watchtower] in the past for this, but it requires a privileged container and it's yet another external dependency.

Also, at the very end, you'll see a `WantedBy` line.
This is a great place to set up container dependencies.
In this example, the container that runs `caddy` (a web server) can't start until Wordpress is up and running.

[watchtower]: /p/podman-quadlet-watchtower/

# So why not stick with docker-compose?

There's no denying that docker-compose is an awesome tool.
You specify the desired outcome, tell it to bring up containers, and it gets containers into the state you specified.
It handles volumes, networks, and complicated configuration without a lot of legwork.
The YAML files are pretty easy to read, too.

However, as with watchtower, that's another external dependency.

My container deployments are often done at instance boot time and I don't make too many changes afterwards.
I found myself using docker-compose for the initial deployment and then I didn't really use it again.

Why not remove it entirely and use what's built into CoreOS already?

# Quaint quadlets quickly!

Before we start, we're going to need a few things:

* An easy to read [butane](https://coreos.github.io/butane/) configuration which gets transformed into a tiny [ignition](https://coreos.github.io/ignition/) configuration for CoreOS
* Some quadlets
* Extra system configuration
* A cloud provider with CoreOS images _(using [VULTR](https://www.vultr.com/?ref=9544589-8H) for this)_

I've packed all of these items into my [quadlets-wordpress](https://github.com/major/quadlets-wordpress) repository to make it easy.
Start by looking at the [config.butane](https://github.com/major/quadlets-wordpress/blob/main/config.butane) file.

Let's break it down here.
First up, we add an ssh key for the default `core` user.

```yaml
variant: fcos
version: 1.5.0
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyoH6gU4lgEiSiwihyD0Rxk/o5xYIfA3stVDgOGM9N0
```

Next up, we enable the `podman-auto-update.timer` so we get container updates automatically:

```yaml
storage:
  links:
    - path: /home/core/.config/systemd/user/timers.target.wants/podman-auto-update.timer
      target: /usr/lib/systemd/user/podman-auto-update.timer
      user:
        name: core
      group:
        name: core
```

Next is the long `files` section:

```yaml
  files:
    # Ensure the `core` user can keep processes running after they're logged out.
    - path: /var/lib/systemd/linger/core
      mode: 0644
    
    # Allow caddy to listen on 80 and 443.
    # Allow it to ask for bigger network buffers, too.
    - path: /etc/sysctl.d/90-caddy.conf
      contents:
        inline: |
          net.ipv4.ip_unprivileged_port_start = 80
          net.core.rmem_max=2500000
          net.core.wmem_max=2500000

    # Set up an an environment file that containers can read to configure themselves.
    - path: /home/core/.config/containers/containers-environment
      contents:
        inline: |
          MYSQL_DATABASE=wordpress
          MYSQL_USER=wordpress
          MYSQL_ROOT_PASSWORD=mariadb-needs-a-secure-password
          MYSQL_PASSWORD=wordpress-needs-a-secure-password
          WORDPRESS_DB_HOST=mariadb
          WORDPRESS_DB_USER=wordpress
          WORDPRESS_DB_PASSWORD=wordpress-needs-a-secure-password
          WORDPRESS_DB_NAME=wordpress
      mode: 0644

    # Deploy the caddy configuration file from the repository.
    - path: /home/core/.config/caddy/Caddyfile
      contents:
        local: caddy/Caddyfile
      mode: 0644
      user:
        name: core
      group:
        name: core

    # Add some named volumes for caddy and wordpress.
    - path: /home/core/.config/containers/systemd/caddy-config.volume
      contents:
        inline: |
          [Volume]
      user:
        name: core
      group:
        name: core
    - path: /home/core/.config/containers/systemd/caddy-data.volume
      contents:
        inline: |
          [Volume]
      user:
        name: core
      group:
        name: core
    - path: /home/core/.config/containers/systemd/wordpress.volume
      contents:
        inline: |
          [Volume]
      user:
        name: core
      group:
        name: core

    # Create a network for all the containers to use and enable the
    # DNS plugin. This allows containers to find each other using
    # the container names.
    - path: /home/core/.config/containers/systemd/wordpress.network
      contents:
        inline: |
          [Network]
          DisableDNS=false
          Internal=false
      user:
        name: core
      group:
        name: core

    # Add the wordpress container.
    - path: /home/core/.config/containers/systemd/wordpress.container
      contents:
        local: quadlets/wordpress.container
      mode: 0644
      user:
        name: core
      group:
        name: core

    # Add the MariaDB container.
    - path: /home/core/.config/containers/systemd/mariadb.container
      contents:
        local: quadlets/mariadb.container
      mode: 0644
      user:
        name: core
      group:
        name: core

    # Add the caddy container.
    - path: /home/core/.config/containers/systemd/caddy.container
      contents:
        local: quadlets/caddy.container
      mode: 0644
      user:
        name: core
      group:
        name: core
```

The [Caddyfile](https://github.com/major/quadlets-wordpress/blob/main/caddy/Caddyfile) is also in the repository and will be deployed by the butane configuration shown above.

We can go through each quadlet in detail.
First up is MariaDB.
We tell systemd that the wordpress container will want to have this one started first.

```ini
[Unit]
Description=MariaDB Quadlet

[Container]
Image=docker.io/library/mariadb:11
ContainerName=mariadb
AutoUpdate=registry
EnvironmentFile=/home/core/.config/containers/containers-environment
Volume=mariadb.volume:/var/lib/mysql
Network=wordpress.network

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=wordpress.service multi-user.target default.target
```

The wordpress quadlet is much the same as the MariaDB one, but we tell systemd that caddy will want wordpress started first.

```ini
[Unit]
Description=Wordpress Quadlet

[Container]
Image=docker.io/library/wordpress:fpm
ContainerName=wordpress
AutoUpdate=registry
EnvironmentFile=/home/core/.config/containers/containers-environment
Volume=wordpress.volume:/var/www/html
Network=wordpress.network

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=caddy.service multi-user.target default.target
```

Finally, the caddy quadlet contains four volumes and some published ports.
These ports will be published to the container host.
Also, you'll note that the wordpress volume is mounted here, too.
This is because caddy can serve static files _much faster_ than wordpress can.

```ini
[Unit]
Description=Caddy Quadlet

[Container]
Image=docker.io/library/caddy:latest
ContainerName=caddy
AutoUpdate=registry
EnvironmentFile=/home/core/.config/containers/containers-environment
Volume=caddy-data.volume:/data
Volume=caddy-config.volume:/config
Volume=/home/core/.config/caddy/Caddyfile:/etc/caddy/Caddyfile:Z
Volume=wordpress.volume:/var/www/html
PublishPort=80:80
PublishPort=443:443
Network=wordpress.network

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=multi-user.target default.target
```

# Launch the quadlets

There's a [launch script](https://github.com/major/quadlets-wordpress/blob/main/launch-instance) that ships this configuration to VULTR and launches a CoreOS instance:

```shell
#!/bin/bash
# This command starts up a CoreOS instance on Vultr using the vultr-cli
vultr-cli instance create \
    --os 391 \
    --plan vhp-1c-1gb-amd \
    --region dfw \
    --notify true \
    --ipv6 true \
    -u "$(butane --files-dir . config.butane)" \
    -l "coreos-$(date "+%s")"
```

To launch an instance, get your [VULTR API key](https://my.vultr.com/settings/#settingsapi) first.
Then install vultr-cli and butane:

```console
$ sudo dnf -y install butane vultr-cli
```

After launch, check to see what your containers are doing:

```console
[core@vultr ~]$ podman ps
CONTAINER ID  IMAGE                            COMMAND               CREATED         STATUS         PORTS                                     NAMES
afa2d6501593  docker.io/library/caddy:latest   caddy run --confi...  54 seconds ago  Up 53 seconds  0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp  caddy
460426f39e6c  docker.io/library/mariadb:11     mariadbd              35 seconds ago  Up 35 seconds                                            mariadb
92ece6538d5a  docker.io/library/wordpress:fpm  php-fpm               28 seconds ago  Up 29 seconds                                            wordpress
```

We should be able to talk to wordpress through caddy on port 80:

```console
[core@vultr ~]$ curl -si http://localhost/wp-admin/install.php | head -n 25
HTTP/1.1 200 OK
Cache-Control: no-cache, must-revalidate, max-age=0
Content-Type: text/html; charset=utf-8
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Server: Caddy
X-Powered-By: PHP/8.0.30
Date: Mon, 25 Sep 2023 21:43:40 GMT
Transfer-Encoding: chunked

<!DOCTYPE html>
<html lang="en-US" xml:lang="en-US">
<head>
	<meta name="viewport" content="width=device-width" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex,nofollow" />
	<title>WordPress &rsaquo; Installation</title>
	<link rel='stylesheet' id='dashicons-css' href='http://localhost/wp-includes/css/dashicons.min.css?ver=6.3.1' type='text/css' media='all' />
<link rel='stylesheet' id='buttons-css' href='http://localhost/wp-includes/css/buttons.min.css?ver=6.3.1' type='text/css' media='all' />
<link rel='stylesheet' id='forms-css' href='http://localhost/wp-admin/css/forms.min.css?ver=6.3.1' type='text/css' media='all' />
<link rel='stylesheet' id='l10n-css' href='http://localhost/wp-admin/css/l10n.min.css?ver=6.3.1' type='text/css' media='all' />
<link rel='stylesheet' id='install-css' href='http://localhost/wp-admin/css/install.min.css?ver=6.3.1' type='text/css' media='all' />
</head>
<body class="wp-core-ui language-chooser">
<p id="logo">WordPress</p>
```

Awesome! 🎉

# Managing containers

Containers will automatically update on a schedule and you can check the timer:

```console
[core@vultr ~]$ systemctl status --user podman-auto-update.timer
● podman-auto-update.timer - Podman auto-update timer
     Loaded: loaded (/usr/lib/systemd/user/podman-auto-update.timer; enabled; preset: disabled)
     Active: active (waiting) since Mon 2023-09-25 21:41:31 UTC; 3min 14s ago
    Trigger: Tue 2023-09-26 00:04:46 UTC; 2h 20min left
   Triggers: ● podman-auto-update.service

Sep 25 21:41:31 vultr.guest systemd[1786]: Started podman-auto-update.timer - Podman auto-update timer.
```

Quadlets are just regular systemd units:

```console
[core@vultr ~]$ systemctl list-units --user | grep -i Quadlet
  caddy.service                                                                       loaded active running Caddy Quadlet
  mariadb.service                                                                     loaded active running MariaDB Quadlet
  wordpress.service                                                                   loaded active running Wordpress Quadlet
```

As an example, you can make changes to caddy's config file and restart it easily:

```console
[core@vultr ~]$ systemctl restart --user caddy
[core@vultr ~]$ systemctl status --user caddy
● caddy.service - Caddy Quadlet
     Loaded: loaded (/var/home/core/.config/containers/systemd/caddy.container; generated)
    Drop-In: /usr/lib/systemd/user/service.d
             └─10-timeout-abort.conf
     Active: active (running) since Mon 2023-09-25 21:46:28 UTC; 5s ago
   Main PID: 2652 (conmon)
      Tasks: 18 (limit: 1023)
     Memory: 15.1M
        CPU: 207ms
```

If you need to change a quadlet's configuration, just open up the configuration file in your favorite editor under `~/.config/containers/systemd`, reload systemd, and restart the container:

```console
$ vi ~/.config/containers/systemd/caddy.container

--- make your edits and save the quadlet configuration ---

$ systemctl daemon-reload --user
$ systemctl restart --user caddy
```

Enjoy!