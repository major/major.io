---
author: Major Hayden
categories:
  - Blog Posts
date: '2022-05-06'
summary: >-
  Learn how to customize a CentOS Stream 9 cloud image with the stuff you want and
  nothing that you don't. 📦
cover: cover.jpg
tags:
  - centos
  - cloud
  - epel
  - imagebuilder
  - linux
title: Build a custom CentOS Stream 9 cloud image
type: post
---

*Photo credit: [Alina Fedorchenko](https://unsplash.com/photos/RT9c80cycn8)*

This is my [third post] about [Image Builder], so I guess you could say that I enjoy
using it[^biased]. It's a great way to define a custom cloud image, build it, and
(optionally) ship it to a supported cloud provider.

This post covers how to build a customized CentOS Stream 9 image along with a custom
repository for additional packages. In this case, that's [Extra Packages for Enterprise
Linux (EPEL)].

[third post]: /tags/imagebuilder/
[Image Builder]: https://www.osbuild.org/documentation/
[Extra Packages for Enterprise Linux (EPEL)]: https://docs.fedoraproject.org/en-US/epel/

[^biased]: I once worked on the team that makes Image Builder happen, so I may be a
    little bit biased. Enjoy the post anyway. 😉

# Why do I need a custom image anyway?

Building your own image empowers you to choose which packages you want, which services
run at boot time, and where you deploy your image. Some cloud providers may not have an
image from the Linux distribution you enjoy most, or they might have an image with the
wrong package set.

Some cloud providers build images with too many packages or too few. Sometimes they add
configuration that doesn't exist in the OS itself. I've even found some that alter
cloud-init and force you to log in directly as the `root` user. 😱

I enjoy building my own images so I know exactly what it contains and I know that the
configuration came from the OS itself.

# First steps

This post uses CentOS Stream 9 as an example. You will need a physical host, virtual
machine, or cloud instance running CentOS Stream 9 first. We start by installing some
packages:

```console
$ sudo dnf install osbuild-composer weldr-client
```

What do these packages contain?

* *osbuild-composer* ensures you have *osbuild*, the low-level image build component,
  along with configuration and an osbuild-composer[^justcomposer] worker that builds the
  image.
* *weldr-client* contains the `composer-cli` command line tool that makes it easy to
  interact with *osbuild-composer*

One nice thing about this stack is that it starts via systemd's [socket activation] and
it only runs when you query it. Let's start the socket now and ensure it comes up on a
reboot:

```console
$ sudo systemctl enable --now osbuild-composer.socket
```

Verify that the API is responding:

```console
$ composer-cli status show
API server status:
    Database version:   0
    Database supported: true
    Schema version:     0
    API version:        1
    Backend:            osbuild-composer
    Build:              NEVRA:osbuild-composer-46-1.el9.x86_64
```

[socket activation]: https://0pointer.de/blog/projects/socket-activation.html

[^justcomposer]: Most people at Red Hat just call it *composer*, but I'll use the full
    name here to avoid confusion.

# Adding EPEL

CentOS Stream 9 has most of the packages I want, but I really love this program called
[`htop`] that displays resource usage and allows you to introspect certain processes or
namespaces easily. This package is only available in the EPEL repository, so we need to
add that one to our list of enabled repositories for image builds.

*osbuild-composer* comes with its own set of repositories in the package and does not
use the system's repositories. You can list all the enabled repositories that it
knows about:

```console
# composer-cli sources list
AppStream
BaseOS
RT
```

If we want to add EPEL, we can dump the configuration from one of these to a file and
edit it:

```console
# composer-cli sources info AppStream | tee epel.ini
check_gpg = true
check_ssl = true
id = "AppStream"
name = "AppStream"
rhsm = false
system = true
type = "yum-baseurl"
url = "https://composes.stream.centos.org/production/latest-CentOS-Stream/compose/AppStream/x86_64/os/"
```

After editing the EPEL repository file, it should look like this:

```ini
check_gpg = true
check_ssl = true
id = "EPEL9"
name = "EPEL9"
rhsm = false
system = false
type = "yum-baseurl"
url = "https://mirrors.kernel.org/fedora-epel/9/Everything/x86_64/"
```

You can use any mirror you prefer, but the kernel mirrors are very fast for me from most
locations. Now we need to add this repository:

```console
# composer-cli sources add epel.ini
# composer-cli sources list
AppStream
BaseOS
EPEL9
RT
```

We now have `EPEL9` in our list. 🎉

# Define our image

All image definitions, or blueprints, are in TOML format. Here's my simple one for this
post:

```toml
# Save this file as image.toml
name = "centos9"
description = "Major's awesome CentOS 9 image"
version = "0.0.1"

[[packages]]
name = "tmux"

[[packages]]
name = "vim"

# This is the one that comes from EPEL.
[[packages]]
name = "htop"
```

Now we push our blueprint and solve the dependencies to ensure we added our EPEL
repository properly:

```console
# composer-cli blueprints push image.toml
# composer-cli blueprints depsolve centos9
    -- SNIP --
    2:vim-filesystem-8.2.2637-16.el9.noarch
    which-2.21-27.el9.x86_64
    xz-5.2.5-7.el9.x86_64
    xz-libs-5.2.5-7.el9.x86_64
    zlib-1.2.11-33.el9.x86_64
    htop-3.1.2-3.el9.x86_64
```

And there's `htop` at the end of the list! 🎉

[`htop`]: https://htop.dev/

# Make the image

The fun part has arrived! Let's build an image:

```console
# composer-cli compose start centos9 ami --size=4096
Compose ca57fd64-11ea-41d4-b924-9b8f5bdcaf5e added to the queue
```

This command does a few things:

1. Starts an image build with our `centos9` blueprint (from the `name` section of my
   `image.toml` file)
2. Outputs an image type that works well on AWS (Amazon Machine Image, or AMI)
3. Limits the image size to 4GB (be sure this is not too large for your preferred
   instance size)

> 🤔 Note that you do not need to set the size explicitly here, but I do it as a good
> measure. When your instance boots, `cloud-init` runs `growpart` to expand the storage
> to fit the disk size in your cloud instance.
>
> 💣 **However**, `growpart` will not *shrink* the disk at boot time. If you choose a
> size that is larger than the disk space in your cloud instance, you will likely see an
> error at provisioning time.

Let's check the status after a few minutes:

```console
# composer-cli compose status
ca57fd64-11ea-41d4-b924-9b8f5bdcaf5e FINISHED Fri May 6 16:16:08 2022 centos9         0.0.1 ami              4096
```

If you want to get a copy of the image and import it yourself into your favorite cloud,
you can do that now:

```console
# composer-cli compose image ca57fd64-11ea-41d4-b924-9b8f5bdcaf5e
ca57fd64-11ea-41d4-b924-9b8f5bdcaf5e-image.raw
# ls -alh ca57fd64-11ea-41d4-b924-9b8f5bdcaf5e-image.raw
-rw-------. 1 root root 2.7G May  6 16:20 ca57fd64-11ea-41d4-b924-9b8f5bdcaf5e-image.raw
```

You can also let *osbuild-composer* do this for you! I have one post on this blog about
[automatically uploading to AWS] and another post on the Red Hat blog about [doing the
same with Azure].

[automatically uploading to AWS]: /2020/06/19/build-aws-images-with-imagebuilder/
[doing the same with Azure]: https://www.redhat.com/en/blog/build-rhel-images-azure-image-builder
