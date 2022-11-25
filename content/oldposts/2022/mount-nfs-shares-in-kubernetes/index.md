---
author: Major Hayden
date: '2022-04-08'
summary: >-
  Access files over NFS within kubernetes pods with a quick volume mount. 🗄
tags:
  - containers
  - linux
  - nfs
  - kubernetes
title: Mount NFS shares in kubernetes
---

_Photo credit: [the blowup](https://unsplash.com/photos/hiK8FD142XU)_

Kubernetes offers a plethora of [storage options] for mounting volumes in pods, and NFS
is included. I have a Synology NAS at home and some of my pods in my home kubernetes
deployment need access to files via NFS.

Although the Kubernetes documentation has a [bunch of examples] about setting up NFS
mounts, I ended up being more confused than when I started. This post covers a simple
example that you can copy, adapt, and paste as needed.

[storage options]: https://kubernetes.io/docs/concepts/storage/volumes/
[bunch of examples]: https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs

# Verify that NFS is working

NFS can be tricky to get right and it's important to verify that it's working *outside
of kubernetes* before you try mounting it in a pod. Trust me -- NFS looks quite simple
at first glance but you can get confused quickly. Test out the easiest stuff first.

As an example: Synology made some recent changes to their NFS configuration where you
must specify shares with a netmask (`192.168.10.0/255.255.255.0`) or in CIDR notation
(`192.168.10.0/24`). That took me a while to figure out going back and forth from server
to client and back again.

If you're making your shares from a regular Linux server, refer to the [Arch Linux NFS
documentation]. It's one of the best write-ups on NFS around!

First, I verified that the mount is showing up via `showmount`:

```console
$ showmount -e 192.168.10.60
Export list for 192.168.10.60:
/volume1/media 192.168.10.50/32
```

My NFS server is on `192.168.10.60` and my NFS client (running kubernetes) is on
`192.168.10.50`.

🤔 Got an error or can't see any exports? Double check the IP addresses allowed to
access the share on the server side and verify your client machine's IP address.

> ☝🏻 Remember to re-export your shares on the server with `exportfs -arv` if you made
> changes! The NFS server won't pick them up automatically. Display your currently
> running exports with `exportfs -v`.

Let's try mounting the share next:

```
$ sudo mount -t nfs 192.168.10.60:/volume1/media /tmp/test
$ df -hT /tmp/test
Filesystem                   Type  Size  Used Avail Use% Mounted on
192.168.10.60:/volume1/media nfs4   16T  7.5T  8.3T  48% /tmp/test
```

Awesome! 🎉

Unmount the test:

```
$ sudo umount /tmp/test
```

[Arch Linux NFS documentation]: https://wiki.archlinux.org/title/NFS

# Mount NFS in a pod

First off, we need a deployment where we can mount up an NFS share. I decided to take a
Fedora 35 container and create a really basic deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: fedoratest
  name: fedoratest
  namespace: fedoratest
spec:
  template:
    spec:
      containers:
        - image: registry.fedoraproject.org/fedora:35
          name: fedora
          command: ["/bin/bash", "-c", "--"]
          args: ["while true; do sleep 30; done;"]
```

This is a really silly deployment that causes Fedora to sleep forever until someone
stops the pod. I mainly want something that I can shell into and ensure NFS is working.

Now we need to add two pieces to the deployment:

1. An NFS volume:

```yaml
volumes:
  - name: nfs-vol
    nfs:
      server: 192.168.10.60
      path: /volume1/media
```

2. A path to mount the volume

```yaml
volumeMounts:
  - name: nfs-vol
    mountPath: /opt/nfs
```

When we add in those NFS pieces, we get the following deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: fedoratest
  name: fedoratest
  namespace: fedoratest
spec:
  template:
    spec:
      containers:
        - image: registry.fedoraproject.org/fedora:35
          name: fedora
          command: ["/bin/bash", "-c", "--"]
          args: ["while true; do sleep 30; done;"]
          volumeMounts:
            - name: nfs-vol
              mountPath: /opt/nfs
      volumes:
        - name: nfs-vol
          nfs:
            server: 192.168.10.60
            path: /volume1/media
```

Save that as `fedoratest.yaml` and apply it:

```console
$ kubectl apply -f fedoratest.yaml
```

Let's see if the volume worked:

```console
$ kubectl describe -n fedoratest deployment/fedoratest
✂
  Volumes:
   nfs-vol:
    Type:      NFS (an NFS mount that lasts the lifetime of a pod)
    Server:    192.168.10.60
    Path:      /volume1/media
    ReadOnly:  false
✂
```

Now let's have a look at it inside the container itself:

```console
$ kubectl -n fedoratest exec -it deployment/fedoratest -- sh
sh-5.1$ cd /opt/nfs
sh-5.1$ ls
dir1  dir2  dir3
```

Let's ensure we can write files:

```console
sh-5.1$ touch doot
sh-5.1$ ls -al doot
-rwxrwxrwx. 1 root root 0 Apr  8 21:03 doot
sh-5.1$ rm doot
```

I can write files, but writing them as root causes problems for other applications. In
this case, my NFS server uses UID `1035` for my user and GID `100` for my group. Lucky
for us, we can set this up within our deployment configuration using `securityContext`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: fedoratest
  name: fedoratest
  namespace: fedoratest
spec:
  template:
    spec:
      securityContext:
        runAsUser: 1035  # Use my UID on the NFS server
        runAsGroup: 100  # Use my GID on the NFS server
      containers:
        - image: registry.fedoraproject.org/fedora:35
          name: fedora
          command: ["/bin/bash", "-c", "--"]
          args: ["while true; do sleep 30; done;"]
          volumeMounts:
            - name: nfs-vol
              mountPath: /opt/nfs
      volumes:
        - name: nfs-vol
          nfs:
            server: 192.168.10.60
            path: /volume1/media
```

Apply this change:

```console
$ kubectl apply -f fedoratest.yaml
```

Now try to write a file again:

```console
$ kubectl -n fedoratest exec -it deployment/fedoratest -- sh
sh-5.1$ touch doot
sh-5.1$ ls -al doot
-rwxrwxrwx. 1 1035 100 0 Apr  8 21:08 doot
sh-5.1$ rm doot
```

Perfect! Now files are owned by the correct UID and GID.

## Extra credit

If you plan to have plenty of pods mounting storage from the same NFS server, you might
want to consider building out a persistent volume first and then making claims from it.
The kubernetes examples repository has a good example of a [persistent NFS volume] and a
[persistent volume claim] made from that volume.

[persistent NFS volume]: https://github.com/kubernetes/examples/blob/master/staging/volumes/nfs/nfs-pv.yaml
[persistent volume claim]: https://github.com/kubernetes/examples/blob/master/staging/volumes/nfs/nfs-pvc.yaml
