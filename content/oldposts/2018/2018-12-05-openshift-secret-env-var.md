---
title: Use a secret as an environment variable in OpenShift deployments
author: Major Hayden
date: "2018-12-06"
summary: >
    Environment variables are easy to add to OpenShift deployments, but
    a more secure way to add these variables is by referencing a secret.
slug: use-secret-as-environment-variable-in-openshift-deployments
tags:
  - openshift
  - containers
  - security
---

OpenShift [deployments] allow you to take a container image and run it within a
cluster. You can easily add extra items to the deployment, such as
environment variables or volumes.

The best practice for sensitive environment variables is to place them into a
[secret object] rather than directly in the deployment configuration itself.
Although this keeps the secret data out of the deployment, the environment
variable is still exposed to the running application inside the container.

## Creating a secret

Let's start with a snippet of a `deploymentConfig` that has a sensitive
environment variable in plain text:

```yml
spec:
    containers:
    - env:
        - name: MYAPP_SECRET_TOKEN
          value: vPWps5E7KO8KPlljaD3eXED3f6jmLsV5mQ
    image: "fedora:29"
    name: my_app
```

The first step is to create a secret object that contains our sensitive
environment variable:

```yml
apiVersion: v1
kind: Secret
metadata:
  name: secret-token-for-my-app
stringData:
  SECRET_TOKEN: vPWps5E7KO8KPlljaD3eXED3f6jmLsV5mQ
```

Save this file as `secret-token.yml` and deploy it to OpenShift:

```
oc apply -f secret-token.yml
```

Query OpenShift to ensure the secret is ready to use:

```
$ oc get secret/secret-token-for-my-app
NAME                            TYPE      DATA      AGE
secret-token-for-my-app         Opaque    1         1h
```

## Using the secret

We can adjust the deployment configuration to use this new secret:

```yml
spec:
    containers:
    - env:
      - name: MYAPP_SECRET_TOKEN
        valueFrom:
          secretKeyRef:
            key: SECRET_TOKEN
            name: secret-token-for-my-app
    image: "fedora:29"
    name: my_app
```

This configuration tells OpenShift to look inside the secret object called
`secret-token-for-my-app` for a key matching `SECRET_TOKEN`. The value will
be passed into the `MYAPP_SECRET_TOKEN` environment variable and it will be
available to the application running in the container.

**Security note:** If someone has access to change the deployment
configuration object, they could get access to the value of the secret
without having direct access to the secret object itself. It would be trivial
to change the startup command in the container to print all of the
environment variables in the container (using the `env` command) and view them
in the container logs.

[deployments]: https://docs.openshift.com/container-platform/3.9/dev_guide/deployments/how_deployments_work.html
[secret object]: https://docs.openshift.com/container-platform/3.9/dev_guide/secrets.html
