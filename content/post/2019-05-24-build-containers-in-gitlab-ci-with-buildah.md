---
title: Build containers in GitLab CI with buildah
author: Major Hayden
type: post
date: "2019-05-24"
slug: build-containers-in-gitlab-ci-with-buildah
twitter:
  card: "summary_large_image"
  site: "@majorhayden"
  title: Build containers in GitLab CI with buildah
  image: images/2019-05-24-cranes-skycrapers.jpg
categories:
  - Blog Posts
tags:
  - buildah
  - containers
  - docker
  - gitlab
  - linux
  - podman
---

![cranes and skyscrapers]

My team at Red Hat depends heavily on [GitLab CI] and we build containers
often to run all kinds of tests. Fortunately, GitLab offers up CI to build
containers and a [container registry] in every repository to hold the
containers we build.

This is really handy because it keeps everything together in one place: your
container build scripts, your container build infrastructure, and the
registry that holds your containers. Better yet, you can put multiple types
of containers underneath a single git repository if you need to build
containers based on different Linux distributions.

[cranes and skyscrapers]: /images/2019-05-24-cranes-skycrapers.jpg
[GitLab CI]: https://about.gitlab.com/product/continuous-integration/
[container registry]: https://about.gitlab.com/2016/05/23/gitlab-container-registry/

## Building with Docker in GitLab CI

By default, GitLab offers up a [Docker builder] that works just fine. The CI
system clones your repository, builds your containers and pushes them
wherever you want. There's even a [simple CI YAML file] that does everything
end-to-end for you.

However, I have two issues with the Docker builder:

* **Larger images:** The Docker image layering is handy, but the images end up
  being a bit larger, especially if you don't do a little cleanup in each
  stage.

* **Additional service:** It requires an additional service inside the CI
  runner for the `dind` ("Docker in Docker") builder. This has caused some CI
  delays for me several times.

[Docker builder]: https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
[simple CI YAML file]: https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#using-docker-caching

## Building with buildah in GitLab CI

On my local workstation, I use [podman] and [buildah] all the time to build,
run, and test containers. These tools are handy because I don't need to
remember to start the Docker daemon each time I want to mess with a
container. I also don't need sudo.

All of my containers are stored beneath my home directory. That's good for
keeping disk space in check, but it's especially helpful on shared servers
since each user has their own unique storage. My container pulls and builds
won't disrupt anyone else's work on the server and their work won't disrupt
mine.

Finally, buildah offers some nice options out of the box. First, when you
build a container with `buildah bud`, you end up with only three layers by
default:

1. Original OS layer (example: `fedora:30`)
2. Everything you added on top of the OS layer
3. Tiny bit of metadata

This is incredibly helpful if you use package managers like `dnf`, `apt`, and
`yum` that download a bunch of metadata before installing packages. You would
normally have to clear the metadata carefully for the package manager so that
your container wouldn't grow in size. Buildah takes care of that by squashing
all the stuff you add into one layer.

Of course, if you want to be more aggressive, buildah offers the `--squash`
option which squashes the whole image down into one layer. This can be
helpful if disk space is at a premium and you change the layers often.

[podman]: https://podman.io/
[buildah]: https://buildah.io/

## Getting started

I have a repository called [os-containers] in GitLab that maintains fully
updated containers for Fedora 29 and 30. The `.gitlab-ci.yml` file calls
`build.sh` for two containers: _fedora29_ and _fedora30_. Open the `build.sh`
file and follow along here:

```bash
# Use vfs with buildah. Docker offers overlayfs as a default, but buildah
# cannot stack overlayfs on top of another overlayfs filesystem.
export STORAGE_DRIVER=vfs
```

First off, we need to tell buildah to use the vfs storage driver. Docker uses
overlayfs by default and stacking overlay filesystems will definitely lead to
problems. Buildah won't let you try it.

```bash
# Write all image metadata in the docker format, not the standard OCI format.
# Newer versions of docker can handle the OCI format, but older versions, like
# the one shipped with Fedora 30, cannot handle the format.
export BUILDAH_FORMAT=docker
```

By default, buildah uses the [_oci_ container format]. This sometimes causes
issues with older versions of Docker that don't understand how to parse that
type of metadata. By setting the format to `docker`, we're using a format
that almost all container runtimes can understand.

```bash
# Log into GitLab's container repository.
export REGISTRY_AUTH_FILE=${HOME}/auth.json
echo "$CI_REGISTRY_PASSWORD" | buildah login -u "$CI_REGISTRY_USER" --password-stdin $CI_REGISTRY
```

Here we set a path for the `auth.json` that contains the credentials for
talking to the container repository. We also use buildah to authenticate to
GitLab's built-in container repository. GitLab automatically exports these
variables for us (and hides them in the job output), so we can use them here.

```bash
buildah bud -f builds/${IMAGE_NAME} -t ${IMAGE_NAME} .
```

We're now building the container and storing it temporarily as the bare image
name, such as _fedora30_. This is roughly equivalent to `docker build`.

```bash
CONTAINER_ID=$(buildah from ${IMAGE_NAME})
buildah commit --squash $CONTAINER_ID $FQ_IMAGE_NAME
```

Now we are making a reference to our container with `buildah from` and using
that reference to squash that container down into a single layer. This keeps
the container as small as possible.

The `commit` step also tags the resulting image using our fully qualified
image name (in this case, it's
`registry.gitlab.com/majorhayden/os-containers/fedora30:latest`)

```bash
buildah push ${FQ_IMAGE_NAME}
```

This is the same as `docker push`. There's not much special to see here.

[os-containers]: https://gitlab.com/majorhayden/os-containers
[_oci_ container format]: https://github.com/opencontainers/image-spec

## Maintaining containers

GitLab allows you to take things to the next level with CI schedules. In my
repository, there is a schedule to build my containers once a day to catch
the latest updates. I use these containers a lot and they need to be up to
date before I can run tests.

If the container build fails for some reason, GitLab will send me an email to
let me know.

[_Photo Source_](https://pxhere.com/en/photo/942096)
