---
author: Major Hayden
date: '2021-10-17'
summary: >-
  Package up graphical applications in containers and run them with
  podman. 🚢
images:
- images/2021-10-17-green-field-sunrise.jpg
slug: run-xorg-applications-with-podman
tags:
- containers
- fedora
- linux
- podman
- xorg
title: Run Xorg applications with podman
---

{{< figure src="/images/2021-10-17-green-field-sunrise.jpg" alt="Sunrise over green hills with grass and trees" position="center" >}}

Containers are a great way to deliver and run all kinds of applications.
Although many people build containers for server applications, you can also use
them for client applications on your local workstation. This helps when you want
to test new applications without disrupting your existing system or when you use
an immutable system such as [Fedora Silverblue].

Podman takes this further by allowing you to run a client application without
root access or daemons. This post covers how to build a container with an Xorg
application and run it on a Fedora system.

[Fedora Silverblue]: https://silverblue.fedoraproject.org/

## Building the container

Let's start with a simple container that contains `xeyes`. This simple
application simply puts a pair of eyes on your screen that follow your mouse
movements around the desktop. It has very few dependencies and it's a great way
to test several capabilities on the desktop.

Here's a very simple container build file:

```dockerfile
# xeyes-container
FROM registry.fedoraproject.org/fedora:latest
RUN dnf -y install xeyes
CMD xeyes
```

Let's install podman and build the container:

```console
$ sudo dnf -y install podman
$ podman build -t xeyes -f xeyes-container .
```

## Run the container

Now that we have our `xeyes` container, let's run it.

```console
$ podman run --rm xeyes
Error: Can't open display:
```

We're missing the `DISPLAY` variable inside the container. Let's add it:

```console
$ echo $DISPLAY
:0
$ podman run --rm -e DISPLAY xeyes
Error: Can't open display: :0
```

Well, we have the display variable inside now, but there's another problem.
Inside the container, `xeyes` can't make a connection to our X daemon. This
socket normally appears in `/tmp/.X11-unix`, but the container doesn't have it.
Let's try adding this inside the container:

```console
$ podman run --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix xeyes
Error: Can't open display: :0
```

Darn! This should be working. Let's check the system journal:

```text
AVC avc:  denied  { write } for  pid=10817 comm="xeyes" name="X0" dev="tmpfs"
ino=42 scontext=system_u:system_r:container_t:s0:c143,c574
tcontext=system_u:object_r:user_tmp_t:s0 tclass=sock_file permissive=0
```

Uh oh. SELinux is upset that a container is trying to mess with the `X0` socket
for our Xorg server that sits in `/tmp/.X11-unix`. You may be tempted to run
`setenforce 0`, but wait. We can fix this with podman!

Podman allows you to set security options for a particular container with
`--security-opt`. We need to run this container with an SELinux context that
allows it to talk to something in `tmpfs`. Examining the [container-selinux
project] shows that `container_runtime_t` can work with `tmpfs`:

```text
type container_runtime_tmp_t alias docker_tmp_t;
files_tmp_file(container_runtime_tmp_t)
```

Let's try adding this to our podman command now:

```console
$ podman run --rm -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --security-opt label=type:container_runtime_t xeyes
```

I now have a set of eyeballs on my desktop! 👀

{{< figure src="/images/2021-10-17-xeyes.png" alt="xeyes running on my desktop" position="center" >}}

[container-selinux project]: https://github.com/containers/container-selinux/blob/main/container.te#L77

## Extra credit

The `xeyes` application is extremely simple, but you can run much more complex
applications using this same method. Keep in mind that certain applications
might require extra packages inside the container, such as fonts or GTK themes.
Jessie Frazelle has a [great repository] full of containers that she uses
regularly and this might give you inspiration to create some of your own! 🤓

[great repository]: https://github.com/jessfraz/dockerfiles

*Photo credit: [Jonny Gios on Unsplash](https://unsplash.com/photos/gBr5Hmx1STc)*
