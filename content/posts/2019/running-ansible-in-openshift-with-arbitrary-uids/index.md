---
aliases:
- /2019/03/22/running-ansible-in-openshift-with-arbitrary-uids/
author: Major Hayden
date: '2019-03-22'
tags:
- openshift
- ansible
- security
- gitlab
title: Running Ansible in OpenShift with arbitrary UIDs
---

My work at Red Hat involves testing lots and lots of kernels from various
sources and we use [GitLab CE] to manage many of our repositories and run our
CI jobs. Those jobs run in *thousands* of [OpenShift] containers that we
spawn every day.

OpenShift has some handy security features that we like. First, each
container is mounted read-only with some writable temporary space (and any
volumes that you mount). Also, OpenShift uses [arbitrarily assigned user IDs]
\(UIDs\) for each container.

Constantly changing UIDs provide some good protection against container
engine vulnerabilities, but they can be a pain if you have a script or
application that depends on being able to resolve a UID or GID back to a real
user or group account.

## Ansible and UIDs

If you run an Ansible playbook within OpenShift, you will likely run into a
problem during the fact gathering process:

```
$ ansible-playbook -i hosts playbook.yml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
An exception occurred during task execution. To see the full traceback, use -vvv.
The error was: KeyError: 'getpwuid(): uid not found: 1000220000'
fatal: [localhost]: FAILED! => {"msg": "Unexpected failure during module execution.", "stdout": ""}
	to retry, use: --limit @/major-ansible-messaround/playbook.retry

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=1
```

This exception is telling us that [getpwuid()] was not able to find an entry
in `/etc/passwd` for our UID (`1000220000` in this container).

One option would be to adjust the playbook so that we skip the fact gathering
process:

```yaml
- hosts: all
  gather_facts: no
  tasks:

    - name: Run tests
      command: ./run_tests.sh
```

However, this might not be helpful if you need facts to be gathered for your
playbook to run. In that case, you need to make some adjustments to your
container image first.

## Updating the container

Nothing in the container image is writable within OpenShift, but we can change
certain files to be group writable for the root user since every OpenShift
user has an effective GID of `0`.

When you build your container, add a line to your Dockerfile to allow the
container user to have group write access to `/etc/passwd` and `/etc/group`:

```dockerfile
# Make Ansible happy with arbitrary UID/GID in OpenShift.
RUN chmod g=u /etc/passwd /etc/group
```

Once your container has finished building, the permissions on both files
should look like this:

```
$ ls -al /etc/passwd /etc/group
-rw-rw-r--. 1 root root 514 Mar 20 18:12 /etc/group
-rw-rw-r--. 1 root root 993 Mar 20 18:12 /etc/passwd
```

## Make a user account

Now that we've made these files writable for our user in OpenShift, it's time
to change how we run our GitLab CI job. My job YAML currently looks like this:

```yaml
ansible_test:
  image: docker.io/major/ansible:fedora29
  script:
    - ansible-playbook -i hosts playbook.yml
```

We can add two lines that allow us to make a temporary user and group account
for our OpenShift user:

```yaml
ansible_test:
  image: docker.io/major/ansible:fedora29
  script:
    - echo "tempuser:x:$(id -u):$(id -g):,,,:${HOME}:/bin/bash" >> /etc/passwd
    - echo "tempuser:x:$(id -G | cut -d' ' -f 2)" >> /etc/group
    - id
    - ansible-playbook -i hosts playbook.yml
```

Note that we want the second GID returned by `id` since the first one is `0`.
The `id` command helps us check our work when the container starts. When the
CI job starts, we should see some better output:

```
$ echo "tempuser:x:$(id -u):$(id -g):,,,:${HOME}:/bin/bash" >> /etc/passwd
$ echo "tempuser:x:$(id -G | cut -d' ' -f 2)" >> /etc/group
$ id
uid=1000220000(tempuser) gid=0(root) groups=0(root),1000220000(tempuser)
$ ansible-playbook -i hosts playbook.yml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Download kernel source] **************************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0
```

Success!

[GitLab CE]: https://gitlab.com/gitlab-org/gitlab-ce/
[OpenShift]: https://www.openshift.com/
[arbitrarily assigned user IDs]: https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
[getpwuid()]: https://linux.die.net/man/3/getpwuid