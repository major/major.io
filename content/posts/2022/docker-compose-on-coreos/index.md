---
author: Major Hayden
date: '2022-12-17'
summary: >
  My go-to method for managing containers easily is still docker-compose. It
  works really well on Fedora CoreOS. 📦 
tags:
  - containers
  - coreos
  - docker
  - fedora
  - kubernetes
title: docker-compose on Fedora CoreOS 
---

Deploying applications in containers provides lots of flexibility and compatibility benefits.

Once you package your application and its dependencies in a container, that container runs almost anywhere without issues.
Very few of the old "it worked on my machine!" problems remain.
However, the challenge of running a container and linking it up with other helpful pieces of software still remains.

Web applications need something to serve HTTP requests and handle TLS.
They also need databases, and those databases must be online and available first.
All of these need reliable storage that is easily managed.

In my personal infrastructure, I keep coming back to [docker-compose](https://github.com/docker/compose).

🐇 **In a hurry?**
Skip to the last section of this post if you want to skip my reasons for using docker-compose and you just want to see the steps.

# Why docker-compose?

The tried-and-true docker-compose is one of the original "set your desired state" systems for managing containers.
You specify what your container deployment should look like and docker-compose finds a way to get your containers in order.
Sometimes that's a fresh start without any existing containers.
Sometimes it involves managing an existing fleet of containers and adjusting their configuration.

As an example, deploying your first container with docker-compose is easy.
Assemble a [basic YAML file](https://compose-spec.io/), point docker-compose at it, and your container is running!

Need to change the configuration?
Just make your changes in the YAML file, re-run docker-compose, and it knows enough to make the right changes.
If containers need to be restarted, it takes care of that.

## Why not kubernetes?

I've run my own kubernetes deployment and I've also been a consumer of large kubernetes and OpenShift deployments.
All of this experience taught me two things:

1. Kubernetes and OpenShift are great.
   Like really great.
   Once you learn them, they are incredibly powerful tools that make a developer's life much easier.
2. Running my own kubernetes or OpenShift deployment on my own time (and own dime) is not enjoyable.

Deploying, maintaining, and troubleshooting kubernetes infrastructure on your own is time consuming.
Shared storage and networking caused me the most headaches in the past.

## What about k3s?

I love [k3s](https://k3s.io/).
However, that still means I have to figure out networking for inter-container communication and load balancing.
Shared storage is also needed.

I could argue that running my own k3s deployment is easier than full kubernetes, but in the end, there's more extra stuff around it that I don't want to maintain.

## Why don't you use managed kubernetes?

Great question!
Several providers have some excellent kubernetes offerings out there.
Smaller providers, such as [Digital Ocean](https://www.digitalocean.com/products/kubernetes) and [VULTR](https://www.vultr.com/kubernetes/), have affordable offerings that are packed with features.

The challenge is that kubernetes deployments have overhead for the control plane, so you can't use all of the virtual machines that you rent.
For example, you may get three virtual machines in your cluster, each with 2GB RAM, but you can really only use about 1GB of RAM from each instance for your containers.

In addition, you will eventually need shared storage and some type of load balancer.
The costs add up quickly.

It's easy to start with a $50-$70 kubernetes offering and later find yourself cracking $100 per month after adding on storage and load balancers.

## What about podman?

[Podman](https://podman.io/) is a delight to use.
You can toss some kubernetes YAML at it for deployments or pods and it will start them up for you.
It also has a handy feature for exporting a container to a systemd unit file so you can manage it like any other systemd unit.

However, when I want to make quick adjustments to a container configuration, it can be frustrating to get that done.
I also like to make adjustments to all of my containers in one place since some applications depend on multiple containers running in tandem.

The [podman-compose](https://github.com/containers/podman-compose) project helps quite a bit, but it still lacks some of docker-compose's features.

I use podman *constantly* on my laptop and desktop for development, testing, and toolbox containers.

# What's the big deal about CoreOS?

[Fedora CoreOS](https://getfedora.org/en/coreos) provides the foundation for my container infrastructure.
I love Fedora already, but here's what makes CoreOS special to me:

* Automatic updates arrive via [ostree](https://ostreedev.github.io/ostree/) as a fully tested minimal unit
* My system reboots automatically to apply the updates and it reverts back to the previous working update if the update fails
* It comes with all of the container tools and configurations that I need
* Whenever I need development or troubleshooting tools, [toolbox containers](https://github.com/containers/toolbox) are one step away

It's a constantly-updated OS that is designed for containers.
What could be better than that?

# Adding docker-compose to CoreOS

Deploy CoreOS in your favorite cloud or on your favorite piece of hardware (I have [a post](/2021/08/20/deploy-fedora-coreos-in-hetzner-cloud/) about deploying it on [Hetzner Cloud](https://www.hetzner.com/cloud)).
Login as the `core` user via ssh.

Go to the [releases page](https://github.com/docker/compose/releases) for docker-compose and get the latest release for your architecture.
Move it into place once you download it:

```console
$ curl -sLO https://github.com/docker/compose/releases/download/v2.14.1/docker-compose-linux-x86_64
$ sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

Let's add a really basic deployment of traefik's [whoami](https://hub.docker.com/r/traefik/whoami) container.
Start a new file called `docker-compose.yaml`:

```yaml
services:
  whoami:
    container_name: whoami
    image: docker.io/traefik/whoami
    ports:
      - 8080:80
    restart: unless-stopped
```

If we try to bring up our containers now, we get an error:

```console
$ docker-compose up -d
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json?all=1&filters=%7B%22label%22%3A%7B%22com.docker.compose.project%3Dcore%22%3Atrue%7D%7D": dial unix /var/run/docker.sock: connect: permission denied
```

The `core` user is not in the `docker` group and does not have permissions to talk to the docker socket.

```console
$ id
uid=1000(core) gid=1000(core) groups=1000(core),4(adm),10(wheel),16(sudo),190(systemd-journal) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

Add the `docker` group to the `core` user as a supplementary group:

```console
$ sudo usermod -a -G docker core
```

Log out of your ssh session and log in again to pick up the new group.
Start the containers once more:

```console
$ id
uid=1000(core) gid=1000(core) groups=1000(core),4(adm),10(wheel),16(sudo),190(systemd-journal),982(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[core@static ~]$ docker-compose up -d
[+] Running 4/4
 ⠿ whoami Pulled
   ⠿ 029cd1bf7e7c Pull complete
   ⠿ e73b694ead4f Pull complete
   ⠿ 99df6e9e9886 Pull complete
[+] Running 2/2
 ⠿ Network core_default  Created
 ⠿ Container whoami      Started
```

Success!

🤔 **BUT WAIT!**
If we reboot our system, the containers won't start up at boot time!

On CoreOS, there's a `docker.socket` file that starts the actual docker service (which is actually [moby-engine](https://mobyproject.org/) on Fedora and not full-fledged docker).
As soon as something touches the socket, systemd starts the docker service.
That keeps it out of the way until something actually asks to use it.

```console
$ systemctl status docker.socket
● docker.socket - Docker Socket for the API
     Loaded: loaded (/usr/lib/systemd/system/docker.socket; enabled; preset: enabled)
     Active: active (running) since Sat 2022-12-17 22:48:42 UTC; 4min 47s ago
      Until: Sat 2022-12-17 22:48:42 UTC; 4min 47s ago
   Triggers: ● docker.service
     Listen: /run/docker.sock (Stream)
      Tasks: 0 (limit: 2207)
     Memory: 0B
        CPU: 596us
     CGroup: /system.slice/docker.socket
```

After a reboot, nothing pokes the socket and the associated service never starts.
You can try it yourself!
Reboot and the whoami container will be down.
Run `docker-compose ps` one time and suddenly your containers are running!

Let's fix this so containers come up on boot without any extra work (or socket poking):

```console
$ sudo systemctl enable --now docker.service
```

The socket will still be handled by systemd, but now the docker service itself will always start at boot whether someone touched it or not.

Enjoy your new lightweight container infrastructure. ✨
