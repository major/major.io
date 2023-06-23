---
aliases:
- /2019/09/11/deploy-monit-in-openshift/
author: Major Hayden
date: '2019-09-11'
images:
- images/2019-09-11-cctv-cameras.jpg
summary: Monit is a tried-and-true monitoring daemon that is easy to deploy. Add it
  to OpenShift to make monitoring even easier.
tags:
- linux
- monit
- monitoring
- openshift
title: Deploy monit in OpenShift
---

![cctv cameras]

[Monit] is a tried-and-true method for monitoring all kinds of systems,
services, and network endpoints. Deploying monit is easy. There's only one
binary daemon to run and it reads monitoring configuration from files in a
directory you specify.

Most Linux distributions have a package for monit and the package usually
contains some basic configuration along with a systemd unit file to run the
daemon reliably.

However, this post is all about how to deploy it inside OpenShift. Deploying
monit inside OpenShift allows you to monitor services inside OpenShift that
might not have a route or a NodePort configured, but you can monitor systems
outside OpenShift, too.

## Monit in a container

Before we can put monit into a container, we need to think about what it
requires. At the most basic level, we will need:

* the monit daemon binary
* a very basic config, the `.monitrc`
* a directory to hold lots of additional monitoring configs
* any packages needed for running monitoring scripts

In my case, some of the scripts I want to run require `curl`, `httpie` (for
complex HTTP/JSON requests), and `jq` (for parsing json). I've added those,
along with some requirements for the monit binary, to my container build file:

```docker
FROM fedora:latest

# Upgrade packages and install monit.
RUN dnf -y upgrade
RUN dnf -y install coreutils httpie jq libnsl libxcrypt-compat
RUN dnf clean all

# Install monit.
RUN curl -Lso /tmp/monit.tgz https://bitbucket.org/tildeslash/monit/downloads/monit-5.26.0-linux-x64.tar.gz
RUN cd /tmp && tar xf monit.tgz
RUN mv /tmp/monit-*/bin/monit /usr/local/bin/monit
RUN rm -rf /tmp/monit*

# Remove monit user/group.
RUN sed -i '/^monit/d' /etc/passwd
RUN sed -i '/^monit/d' /etc/group

# Work around OpenShift's arbitrary UID/GIDs.
RUN chmod g=u /etc/passwd /etc/group

# The monit server listens on 2812.
EXPOSE 2812

# Set up a volume for /config.
VOLUME ["/config"]

# Start monit when the container starts.
ENV HOME=/tmp
COPY extras/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
CMD ["/opt/start.sh"]
```

Let's break down what's here in the container build file:

* Install some basic packages that we need in the container
* Download monit and install it to `/usr/local/bin/monit`
* Remove the `monit` user/group *(more on this later)*
* Make `/etc/passwd` and `/etc/group` writable by the root group *(more on this later)*
* Expose the default monit port
* Run our special startup script

The last three parts help us run with OpenShift's strict security requirements.

## Startup script

Monit has some strict security requirements for startup. It requires that the
monit daemon is started with the same user/group combination that owns the
initial configuration file (`.monitrc`). That's why we removed the `monit`
user/group *and* made `/etc/passwd` and `/etc/shadow` writable during the build
step. We need to add those back in once the container starts and we've received
our arbitrary UID from OpenShift.

_(For more on OpenShift's arbitrary UIDs, read my other post about [Running
Ansible in OpenShift with arbitrary UIDs].)_

Here's the startup script:

```bash
#!/bin/bash
set -euxo pipefail

echo "The home directory is: ${HOME}"

# Work around OpenShift's arbitrary UID/GIDs.
if [ -w '/etc/passwd' ]; then
    echo "monit:x:`id -u`:`id -g`:,,,:${HOME}:/bin/bash" >> /etc/passwd
fi
if [ -w '/etc/group' ]; then
    echo "monit:x:$(id -G | cut -d' ' -f 2)" >> /etc/group
fi

# Make a basic monitrc.
echo "set daemon 30" >> "${HOME}"/monitrc
echo "include /config/*" >> "${HOME}"/monitrc
chmod 0700 "${HOME}"/monitrc

# Ensure the UID/GID mapping works.
id

# Run monit.
/usr/local/bin/monit -v -I -c "${HOME}"/monitrc
```

Let's talk about what is happening in the script:

1. Add the `monit` user to `/etc/passwd` with the arbitrary UID
2. Do the same for the `monit` group in `/etc/group`
3. Create a very basic `.monitrc` that is owned by the `monit` user and group
4. Run `monit` in verbose mode in the foreground with our `.monitrc`

OpenShift will make an emptyDir volume in `/config` that we can modify since we
specified a volume in the container build file.

## Deploying monit

Now that we have a container and a startup script, it's time to deploy monit in
OpenShift.

```yaml
apiVersion: apps.openshift.io/v1
kind: DeploymentConfig
metadata:
  generation: 1
  labels:
    app: monit
  name: monit
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    app: monit
    deploymentconfig: monit
  strategy:
    activeDeadlineSeconds: 21600
    resources: {}
    rollingParams:
      intervalSeconds: 1
      maxSurge: 25%
      maxUnavailable: 25%
      timeoutSeconds: 600
      updatePeriodSeconds: 1
    type: Rolling
  template:
    metadata:
      labels:
        app: monit
        deploymentconfig: monit
    spec:
      containers:
      - image: registry.gitlab.com/majorhayden/container-monit/monit:latest
        imagePullPolicy: Always
        name: monit
        resources:
          limits:
            cpu: 100m
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 512Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /config
          name: monit-config
        - mountPath: /scripts
          name: monit-scripts
      dnsPolicy: ClusterFirst
      hostname: monit-in-openshift
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
      volumes:
      - configMap:
          defaultMode: 0420
          name: monit-config
        name: monit-config
      - configMap:
          defaultMode: 0755
          name: monit-scripts
        name: monit-scripts
  test: false
  triggers:
  - type: ConfigChange
```

There is a lot of text here, but there are two important parts:

* The container `image` is pre-built from my [monit GitLab repository]
  \(feel free to use it!\)
* The `volumes` refer to the OpenShift configmaps that hold the monit
  configurations as well as the scripts that are called for monitoring

Next comes the service (which allows the monit web port to be exposed inside
the OpenShift cluster):

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: monit
  name: monit
spec:
  ports:
  - port: 2812
    protocol: TCP
    targetPort: 2812
  selector:
    app: monit
    deploymentconfig: monit
  sessionAffinity: None
  type: ClusterIP
```

And finally, the route (which exposes the monit web port service *outside* the
OpenShift cluster):

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  labels:
    app: monit
  name: monit
spec:
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: edge
  host: monit.openshift.example.com
  to:
    kind: Service
    name: monit
    weight: 100
  wildcardPolicy: None
```

## Monitoring configuration and scripts

The deploymentConfig for monit refers to a configMap called `monit-config`.
This config map contains all of the additional monitoring configuration for
monit outside of the `.monitrc`. Here is a basic configMap for checking that
`icanhazheaders.com` is accessible:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: monit-config
data:
  config: |
    set daemon 30
    set httpd port 2812
      allow 0.0.0.0/0
    set alert me@example.com
    set mailserver smtp.example.com

    check host "icanhazheaders responding" with address icanhazheaders.com
      if failed
        port 80
        for 2 cycles
      then alert

    check program "icanhazheaders header check"
      with path "/scripts/header-check.sh ACCEPT-ENCODING 'gzip'"
      if status gt 0
        then exec "/scripts/irc-notification.sh"
        else if succeeded then exec "/scripts/irc-notification.sh"

```

This configuration will check `icanhazheaders.com` and only alert if the check
fails for two check periods. Each check period is 30 seconds, so the site would
need to be inaccessible for 60 seconds before an alert would be sent.

Also, there is a second check that runs a script. Let's deploy the script to
OpenShift as well:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: monit-scripts
data:
  header-check.sh: |
    #!/bin/bash
    set -euo pipefail

    URL="http://icanhazheaders.com"
    HEADER=$1
    EXPECTED_VALUE=$2

    HEADER_VALUE=$(curl -s ${URL} | jq -r ${HEADER})

    if [[ $HEADER_VALUE == $EXPECTED_VALUE ]]; then
      exit 0
    else
      exit 1
    fi
```

Use `oc apply` to deploy all of these YAML files to your OpenShift cluster and
monit should be up and running within seconds!

[cctv cameras]: /images/2019-09-11-cctv-cameras.jpg
[Monit]: https://mmonit.com/monit/
[Running Ansible in OpenShift with arbitrary UIDs]: /2019/03/22/running-ansible-in-openshift-with-arbitrary-uids/
[monit GitLab repository]: https://gitlab.com/majorhayden/container-monit

[_Photo credit_](https://commons.wikimedia.org/wiki/File:CCTV_cameras_in_Mumbai.jpg)