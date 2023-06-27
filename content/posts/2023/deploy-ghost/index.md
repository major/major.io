---
author: Major Hayden
date: '2023-06-27'
summary: |
  Ghost delivers a great self-hosted blogging platform that deploys well in containers.
  Let's deploy it on CoreOS along with Caddy. ️📝
tags:
  - caddy
  - containers
  - coreos
  - fedora
  - ghost
title: >
    Deploy a containerized Ghost blog 👻
coverAlt: >
    Lots of gold-colored beams in the ceiling of a building in Lisbon, Porgugal
    with a blue sky behind them
coverCaption: >
  Photo by <a href="https://unsplash.com/@rgaleriacom?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Ricardo Gomez Angel</a>
  on <a href="https://unsplash.com/photos/8RNmPVhbmEM?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
---

There's no shortage of options for starting a self-hosted blog.
Wordpress might be chosen most often, but I stumbled upon [Ghost](https://ghost.org/) recently and their [performance numbers](https://ghost.org/vs/wordpress/) really got my attention.

I prefer deploying most things in containers these days with [Fedora CoreOS](https://fedoraproject.org/coreos/).
Luckily, the Ghost stack doesn't demand a lot of infrastructure:

* Ghost itself
* MySQL 8+ _(I went with MariaDB 11.x)_
* A web server out front
* TLS certificate

{{< alert >}}
Although I chose MariaDB for the database here, **Ghost recommends MySQL** and will throw a warning in the admin panel if you're using something else.
I haven't had any issues so far, but **you've been warned**. 💣
{{< /alert >}}

I picked Caddy for the webserver since it's so small and the configuration is tremendously simple.

# Launch CoreOS

Fedora CoreOS offers lots of [cloud options](https://fedoraproject.org/coreos/download/?stream=stable) for launching it immediately.
Many public clouds already have CoreOS images available, but I love Hetzner's US locations and I already had a CoreOS image loaded up in my account.

🇩🇪 Want CoreOS at Hetzner?
There's a [blog post](/p/deploy-fedora-coreos-in-hetzner-cloud/) for that!

Once your CoreOS instance is running, connect to the instance over ssh and ensure the `docker.service` starts on each boot:

```shell
sudo systemctl enable --now docker.service
```

This ensures that containers come up on each reboot.
CoreOS has a podman socket that listens for docker-compatible connections, but that doesn't help with reboots.

Perhaps I'm old fashioned, but I still enjoy using [docker-compose](https://github.com/docker/compose) for container management.
I like how I can declare what I want and let `docker-compose` sort out the rest.

Let's install `docker-compose` on the CoreOS instance now:

```shell
# Check the latest version in the GitHub repo before starting!
# https://github.com/docker/compose
curl -LO https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-linux-x86_64

# Install docker-compose and make it executable.
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
sudo chown +x /usr/local/bin/docker-compose
```

Verify that `docker-compose` is ready to go:

```console
$ docker-compose --version
Docker Compose version v2.19.0
```

# Preparing Caddy

Caddy uses a configuration file called a _Caddyfile_ and we need that in place before we deploy the other containers.
Within my home directory, I created a directory called _caddy_:

```shell
mkdir caddy
```

Then I added the _Caddyfile_ inside the directory:

```caddy
{
    # Your email for LetsEncrypt warnings/notices.
    email youremail@domain.com 

    # Staging LetsEncrypt server to use while testing.
    # Uncomment this before going to production!
    acme_ca https://acme-staging-v02.api.letsencrypt.org/directory
}

# Basic virtual host definition to feed traffic into the
# Ghost container when it arrives.
example.com {
    reverse_proxy ghost:2368
}

# OPTIONAL: Redirect traffic to 'www' to the bare domain.
www.example.com {
    redir https://example.com{uri}
}
```

This configuration sets up LetsEncrypt certificates automatically from the staging server for now.
Once we know our configuration is working well, we can comment out the `acme_ca` line above and get production TLS certificates.

At this point, you need a DNS record pointed to your server so you can get a certificate.
You have some options:

* **If the site is entirely new,** just point the root domain name to your CoreOS instance.
  Use that domain in the configuration above and later in the deployment.

* **If you're migrating from an existing site,** choose a subdomain off your main domain to use.
  If your website is _example.com_, use something like _test.example.com_ or _new.example.com_ to get Ghost up and running.
  It's really easy to change this later.

Now we're ready for the rest of the deployment.

# Deploying containers

Here's the `docker-compose.yml` file I'm using:

```yaml
---
version: '3.8'
services:

  # OPTIONAL
  # Watchtower monitors all running containers and updates
  # them when the upstream container repo is updated.
  watchtower:
    image: docker.io/containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    hostname: coreos-ghost-deployment
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_POLL_INTERVAL=3600
    command:
      - --cleanup
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    privileged: true

  # Caddy acts as our external-facing webserver and handles
  # getting TLS certs from LetsEncrypt.
  caddy:
    image: caddy:latest
    container_name: caddy
    depends_on:
      - ghost
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile:Z
      - ghost:/var/www/html
      - caddy_data:/data
      - caddy_config:/config

  # The Ghost blog software itself
  ghost:
    image: docker.io/library/ghost:5
    container_name: ghost
    restart: always
    depends_on:
      - ghostdb
    environment:
      url: https://example.com
      database__client: mysql
      database__connection__host: ghostdb
      database__connection__user: ghost
      database__connection__password: GHOST_PASSWORD_FOR_MARIADB
      database__connection__database: ghostdb
    volumes:
      - ghost:/var/lib/ghost/content

  # Our MariaDB database
  ghostdb:
    image: docker.io/library/mariadb:11
    container_name: ghostdb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: A_SECURE_ROOT_PASSWORD
      MYSQL_USER: ghost
      MYSQL_PASSWORD: GHOST_PASSWORD_FOR_MARIADB
      MYSQL_DATABASE: ghostdb
    volumes:
      - ghostdb:/var/lib/mysql

volumes:
  caddy_config:
  caddy_data:
  ghost:
  ghostdb:
```

I love [watchtower](/p/watchtower/) but that step is completely optional.
It does require some elevated privileges to talk to the podman socket, so **keep that in mind if you choose to use it.**

Our `ghostdb` container starts first, followed by `ghost`, and then `caddy`.
That follows the `depends_on` configuration keys shown above.

There are two steps to take now:

* Replace `GHOST_PASSWORD_FOR_MARIADB` and `A_SECURE_ROOT_PASSWORD` above with better passwords. 😉
* Also, set the `url` parameter for the `ghost` container to your blog's domain name.

Once all of that is done, let's let `docker-compose` do the heavy lifting:

```console
sudo docker-compose up -d
```

Let's verify that our containers are running:

```console
$ sudo docker-compose ps
NAME                IMAGE                                    COMMAND                  SERVICE         
caddy               caddy:latest                             "caddy run --config …"   caddy           
ghost               docker.io/library/ghost:5                "docker-entrypoint.s…"   ghost           
ghostdb             docker.io/library/mariadb:11             "docker-entrypoint.s…"   ghostdb         
watchtower          docker.io/containrrr/watchtower:latest   "/watchtower --clean…"   watchtower      
```

Awesome! 👏

# Ghost initial setup

With all of your containers running, browse to `https://example.com/ghost/`
Just add `/ghost/` to the end of your domain name to reach the admin panel.
Create your admin account there with a good password.

If everything looks good, run back to your _Caddyfile_ and comment out the `acme_ca` line:

```caddy
{
    # Your email for LetsEncrypt warnings/notices.
    email youremail@domain.com 

    # Staging LetsEncrypt server to use while testing.
    # Uncomment this before going to production!
    # acme_ca https://acme-staging-v02.api.letsencrypt.org/directory
}
```

Restart the caddy container to get a production LetsEncrypt certificate on the site:

```console
sudo docker-compose restart caddy
```

# Customizing Ghost

Ghost [looks for lots of environment variables](https://ghost.org/docs/config/#custom-configuration-files) to determine its configuration and you can set these in your `docker-compose.yml` file.
Although some configuration items are easy, like `url`, some are nested and get more complicated.
For these, you can use double underscores `__` to handle the nesting.

As an example, we already used `database__connection__host` in the `docker-compose.yaml`, and that's the equivalent to this nested configuration:

```json
"database": {
    "connection": {
        "host": "..."
    }
}
```

If you're deploying in containers, it's a good idea to configure Ghost via environment variables.
This ensures that your `docker-compose.yml` is authoritative for the Ghost deployment.
You _can_ `exec` into the container, adjust the config file on disk, and restart Ghost, but then you have to remember where you configured each item. 🥵

# Switching to production domain

If you used a temporary domain to get everything configured and you're ready to use your production domain, follow these steps:

* Open your _Caddyfile_ and replace all instances of the testing domain with the production domain
* Restart caddy: `sudo docker-compose restart caddy`
* Edit the `docker-compose.yml` and change the `url` key in the `ghost` container to the production domain
* Apply the configuration with `sudo docker-compose up -d`

Enjoy your new automatically-updating Ghost blog deployment! 👻