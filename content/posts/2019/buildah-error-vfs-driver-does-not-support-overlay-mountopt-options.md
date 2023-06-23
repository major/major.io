---
aliases:
- /2019/08/13/buildah-error-vfs-driver-does-not-support-overlay-mountopt-options/
author: Major Hayden
date: '2019-08-13'
images:
- images/2019-08-13-storage-bins.jpg
summary: Buildah and podman work well with the vfs storage driver, but the default
  mount options can cause problems.
tags:
- buildah
- containers
- fedora
- gitlab
- linux
- podman
title: 'buildah error: vfs driver does not support overlay.mountopt options'
---

![Storage bins]

Buildah and podman make a great pair for building, managing and running
containers on a Linux system. You can even [use them with GitLab CI] with a
few small adjustments, namely the switch from the overlayfs to vfs storage
driver.

I have some regularly scheduled GitLab CI jobs that attempt to build fresh
containers each morning and I use these to get the latest packages and find
out early when something is broken in the build process. A failed build
appeared in my inbox earlier this week with the following error:

```text
+ buildah bud -f builds/builder-fedora30 -t builder-fedora30 .
vfs driver does not support overlay.mountopt options
```

My container build script[^1] is fairly basic, but it does include a change to
use the vfs storage driver:

```bash
# Use vfs with buildah. Docker offers overlayfs as a default, but buildah
# cannot stack overlayfs on top of another overlayfs filesystem.
export STORAGE_DRIVER=vfs
```

The script doesn't change any mount options during the build process. A quick
glance at the `/etc/containers/storage.conf` revealed a possible problem:

```ini
[storage.options]
# Storage options to be passed to underlying storage drivers

# mountopt specifies comma separated list of extra mount options
mountopt = "nodev,metacopy=on"
```

These mount options make sense when used with an overlayfs filesystem, but
they are not used with vfs. I commented out the `mountopt` option, saved the
file, and ran a test build locally. **Success!**

Fixing the build script involved a small change to the `storage.conf` just
before building the container:

```bash
# Use vfs with buildah. Docker offers overlayfs as a default, but buildah
# cannot stack overlayfs on top of another overlayfs filesystem.
export STORAGE_DRIVER=vfs

# Newer versions of podman/buildah try to set overlayfs mount options when
# using the vfs driver, and this causes errors.
sed -i '/^mountopt =.*/d' /etc/containers/storage.conf
```

My containers are happily building again in GitLab.

[Storage bins]: /images/2019-08-13-storage-bins.jpg
[use them with GitLab CI]: /2019/05/24/build-containers-in-gitlab-ci-with-buildah/

[^1]: The original build script is no longer available, but the [remainder of
the repository](https://gitlab.com/cki-project/containers/) still exists.