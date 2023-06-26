---
aliases:
- /2021/08/16/wildcard-letsencrypt-certificates-traefik-cloudflare/
author: Major Hayden
date: '2021-08-16'
summary: Re-use the same wildcard TLS certificate for multiple containers running
  behind traefik. 🚦
tags:
- certificates
- containers
- docker
- letsencrypt
- traefik
- tls
title: Wildcard LetsEncrypt certificates with Traefik and Cloudflare
---

Wildcard certificates make it easy to secure lots of subdomains under a single
domain. For example, you can secure `web.example.com` and `mail.example.com`
with a single certificate for `*.example.com`. Fortunately, LetsEncrypt allows
you to get wildcard certificates via a [DNS ownership check] (often called a
_DNS-01 challenge_).

Fortunately, [Traefik] can request a certificate from
LetsEncrypt automatically and complete the challenge for you. It can publish DNS
records to multiple providers, but my favorite is Cloudflare. They will host
your DNS zones and records for free. They also have a robust API for managing
DNS records (also free).

In this post, we will cover the basics of getting TLS working with Traefik. We
can add a wildcard certificate on top and then re-use that same certificate for
other containers running behind Traefik.

[DNS ownership check]: https://letsencrypt.org/docs/challenge-types/
[Traefik]: https://traefik.io/

# Basic setup

First, we need a running instance of Traefik. The [Traefik documentation]
explains this entire process in detail and I highly recommend reading the basics
on configuration discovery, routers, and TLS settings.

We will use [docker-compose] to make this easier to manage. If you're on Fedora, install docker-compose:

```console
dnf install docker-compose
```

Now we need a `docker-compose.yml` file:

```yaml
---
version: "3"
services:
  traefik:
    image: traefik:latest
    container_name: traefik
    restart: unless-stopped
    command:
      # Tell Traefik to discover containers using the Docker API
      - --providers.docker=true
      # Enable the Trafik dashboard
      - --api.dashboard=true
      # Set up LetsEncrypt
      - --certificatesresolvers.letsencrypt.acme.dnschallenge=true
      - --certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare
      - --certificatesresolvers.letsencrypt.acme.email=EMAIL_ADDRESS
      - --certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json
      # Set up an insecure listener that redirects all traffic to TLS
      - --entrypoints.web.address=:80
      - --entrypoints.web.http.redirections.entrypoint.to=websecure
      - --entrypoints.web.http.redirections.entrypoint.scheme=https
      - --entrypoints.websecure.address=:443
      # Set up the TLS configuration for our websecure listener
      - --entrypoints.websecure.http.tls=true
      - --entrypoints.websecure.http.tls.certResolver=letsencrypt
      - --entrypoints.websecure.http.tls.domains[0].main=home.example.com
      - --entrypoints.websecure.http.tls.domains[0].sans=*.home.example.com
    environment:
      - CLOUDFLARE_EMAIL=CLOUDFLARE_ACCOUNT_EMAIL_ADDRESS
      - CLOUDFLARE_DNS_API_TOKEN=CLOUDFLARE_TOKEN_GOES_HERE
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - certs:/letsencrypt
    labels:
      - "traefik.enable=true"
      - 'traefik.http.routers.traefik.rule=Host(`home.example.com`)'
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
      - "traefik.http.routers.traefik.service=api@internal"
      - 'traefik.http.routers.traefik.middlewares=strip'
      - 'traefik.http.middlewares.strip.stripprefix.prefixes=/traefik'
```

In this example, we tell Traefik about our desired setup in the `command`
section, including our listeners. Our insecure listener on port 80 redirects to
secure connections on port 443 and we tell Traefik that we plan to use
LetsEncrypt to get the certificates.

We provide the username and Cloudflare API key in the `environment` section.
Follow Cloudflare's guides for [managing API tokens and keys] carefully to
generate a token.

The `labels` section sets up a rule where traffic destined for
`home.example.com` goes to the Traefik dashboard. this is helpful in case you
make mistakes or you can't figure out why something is working. You can go to
the dashboard to show all of the existing services, listeners, and other
configurations.

☝🏻 Before applying this docker-compose file, change a few things:

* Set your LetsEncrypt email address in the line with
  `--certificatesresolvers.letsencrypt.acme.email`
* Set your Cloudflare account email address for the `CLOUDFLARE_EMAIL`
  environment variable
* Set your Cloudflare DNS API token for the `CLOUDFLARE_DNS_API_TOKEN`
  environment variable
* Change the `Host()` rules from `example.com` to match your domain name

Run `docker-compose up -d` and then `docker-compose logs -f traefik` to see if
Traefik came up successfully with certificates. If you run into any problems,
double check that your Cloudflare email and token are accurate. Also verify that
your Cloudflare token has the correct permissions to adjust the dns zone.

[Traefik documentation]: https://doc.traefik.io/traefik/
[docker-compose]: https://docs.docker.com/compose/
[managing API tokens and keys]: https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys

# Adding a container

At this point, we can add another container and it can use the same TLS
certificate we requested from LetsEncrypt already!

The [librespeed] project provides a self-hosted network speed test that you can
run on any network. It also runs perfectly inside a container. The
[linuxserver.io librespeed container] is well maintained and easy to run.

Add this to your `docker-compose.yml` right under the Traefik configuration:

```yaml
  librespeed:
    image: ghcr.io/linuxserver/librespeed
    container_name: librespeed
    restart: unless-stopped
    ports:
      - 80
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.librespeed.rule=Host(`librespeed.home.example.com`)"
      - "traefik.http.routers.librespeed.entrypoints=websecure"
      - "traefik.http.routers.librespeed.tls.certresolver=letsencrypt"
```

Check the `labels` section. We first enable Traefik so it will route requests to
the container. Then we set a host rule so that traffic for
`librespeed.home.example.com` comes to this container. We only listen for TLS
traffic (remember our redirect for insecure traffic earlier).

Finally, we tell Traefik to use the same `certresolver` as before. Traefik is
smart enough to know that `*.home.example.com` covers the
`librespeed.home.example.com` subdomain just fine.

Run `docker-compose up -d` once more and now librespeed has a secure connection
using the original wildcard certificate.

[librespeed]: https://librespeed.org/
[linuxserver.io librespeed container]: https://docs.linuxserver.io/images/docker-librespeed

# Renewals

LetsEncrypt certificates are valid for only 90 days. That's why automation plays
such an important role in handling renewals. You certainly don't want to set
calendar reminders to log into your server and run a script every 90 days. 😱

Traefik [automatically knows] when the expiration date approaches. When the
certificate has less than 30 days left until the expiration date, Traefik
automatically renews the certificate.

💣 Be careful with your DNS zone and with your DNS API keys! If you accidentally
delete the API key or make big changes to your DNS zone, there's a chance that
Traefik may not be able to renew the certificate.

[automatically knows]: https://doc.traefik.io/traefik/https/acme/

*Photo credit: [Veron Wessels on Unsplash](https://unsplash.com/photos/GIcoFy0zrDo)*