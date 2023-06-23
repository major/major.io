---
aliases:
- /2022/04/20/basic-auth-with-traefik-on-kubernetes/
author: Major Hayden
date: '2022-04-20'
summary: Keep prying eyes away from your sites behind Traefik with basic authentication.
  🛃
tags:
- flux
- gitops
- kubernetes
- linux
- security
- traefik
title: Basic authentication with Traefik on kubernetes
---

[Basic access authentication] dates back to 1993 and it's still heavily used today. The
server provides a `WWW-Authenticate` header to the client and the client responds with
an `Authorization` header and a base64-encoded _(not encrypted)_ string to authenticate.
When done over a secure TLS connection, this method of authentication works well.

[Traefik] is an application proxy that takes requests from clients and routes them to
different backends. You can use it by itself, in conjunction with Docker, or in a
kubernetes deployment. I love it because it gets most of its information and
configuration details from the environment around it. I don't have to tell Traefik where
my services are. It knows where they are based on the resources I add in kubernetes.

In this post, I'll explain how to add kubernetes resources that allow Traefik to handle
basic authentication for backend applications. This particular example covers
authentication for Traefik's dashboard. The dashboard displays lots of helpful
diagnostic information about routing and services that helps you troubleshoot
configuration errors.

On the other hand, this information is also quite useful to attackers and it's a good
idea to keep it hidden away. 🕵🏻

[Basic access authentication]: https://en.wikipedia.org/wiki/Basic_access_authentication
[Traefik]: https://traefik.io/

## Important ingress

Kubernetes aficionados know the [ingress] resource type well. It's a resource that
signals to a load balancer how it should route traffic within the cluster. Here's an
example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
spec:
  rules:
  - host: "foo.bar.com"
    http:
      paths:
      - pathType: Prefix
        path: "/bar"
        backend:
          service:
            name: service1
            port:
              number: 80
```

This ingress takes traffic to `foo.bar.com` underneath the URI `/bar` and sends it to
the service `service1` on port 80. Most kubernetes load balancers can take this
information and begin routing requests.

Traefik takes this up a notch with the [IngressRoute] resource. This CRD is
Traefik-specific, but it makes configuration easier:

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: ingressroutetls
  namespace: default
spec:
  entryPoints:
    - websecure
  routes:
  - match: Host(`your.example.com`) && PathPrefix(`/tls`)
    kind: Rule
    services:
    - name: whoami
      port: 80
  tls:
    certResolver: myresolver
```

We now have access to specify which Traefik entry points to use (these are ports that
Traefik listens to) as well as a certificate resolver of some sort. We can match the
host header and URI prefix on the same line with complex rules and send the traffic to
the `whoami` service on port 80.

Our goal from here on out will be to:

* Add basic authentication to the traefik dashboard
* Enable the traefik dashboard so we can reach it from the outside

[ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[IngressRoute]: https://doc.traefik.io/traefik/providers/kubernetes-crd/

## Enable authentication for the dashboard

I'm using [flux] to manage my kubernetes cluster _(read more on that in [yesterday's
post])_ and I'm using its [HelmRelease] resource type to deploy Traefik. You can follow
along with the files in my [gitops-ng repository].

First, we need a namespace in `namespace.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: traefik
```

Let's deploy Traefik using a HelmRelease resource and store this in `release.yaml`:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: traefik
  namespace: traefik
spec:
  interval: 5m
  timeout: 20m
  install:
    crds: CreateReplace
  upgrade:
    crds: CreateReplace
  chart:
    spec:
      chart: traefik
      version: "10.19.4"
      sourceRef:
        kind: HelmRepository
        name: traefik
        namespace: flux-system
  # https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml
  values:
    ports:
      web:
        redirectTo: websecure
```

I'm specifying that I want to install Traefik's helm chart (version 10.19.4) into the
`traefik` namespace and I want to update the CRDs (which gives me the IngressRoute
resource type) on installation and during updates. At the end, I specify that all
non-secure HTTP requests on port 80 should be redirected to a TLS connection.

Now we need to set up the dashboard by creating a `dashboard.yaml` file:

```yaml
---
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: dashboard-ingress-auth
  namespace: traefik
spec:
  basicAuth:
    secret: dashboard-auth-secret
    removeHeader: true
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`traefik.example.com`)
      kind: Rule
      middlewares:
        - name: dashboard-ingress-auth
          namespace: traefik
      services:
        - name: api@internal
          kind: TraefikService
  tls:
    certResolver: letsencrypt
```

The `Middleware` resource specifies that I want basic authentication using the
`dashboard-auth-secret` secret _(which we will create momentarily)_. The IngressRoute
specifies that all traffic coming to the `websecure` TLS-secured frontend that is
destined for `traefik.example.com` should be redirected to the internal Traefik
dashboard `api@internal`. Before that happens, the `dashboard-ingress-auth` middleware
must be applied.

> 👀 In my case, I have a certificate resolver called `letsencrypt` already configured.
This is outside the scope of this post, but the [ACME docs] have good examples of HTTP
and DNS validation for certificates from LetsEncrypt.

Now we reach the tricky part. We need to create a username and password combination for
basic authentication and store it in a secret. The easiest method here us to use
`htpasswd`, create a secret from the file it creates, and then encrypt the file with
SOPS:

```console
$ htpasswd -nB secretuser | tee auth-string
New password:
Re-type new password:
secretuser:$2y$05$W4zCVrqGg8wKtIjOAU.gGu8MQC9k7sH4Wd1v238UfiVuGkf0xfDUu

$ kubectl create secret generic -n traefik dashboard-auth-secret \
    --from-file=users=auth-string -o yaml --dry-run=client | tee dashboard-auth-secret.yaml
apiVersion: v1
data:
  users: c2VjcmV0dXNlcjokMnkkMDUkVzR6Q1ZycUdnOHdLdElqT0FVLmdHdThNUUM5azdzSDRXZDF2MjM4VWZpVnVHa2YweGZEVXUKCg==
kind: Secret
metadata:
  creationTimestamp: null
  name: dashboard-auth-secret
  namespace: traefik

$ sops -e --in-place dashboard-auth-secret.yaml
```
Add all of the files we created into your flux repository or apply them with `kubectl
apply -f` _(and consider embracing gitops later)_.

Access your Traefik dashboard URL and you should see a basic authentication prompt.
Enter the credentials you set with `htpasswd` and you should see your Traefik dashboard!

{{< figure src="traefik_dashboard.png" alt="Traefik Dashboard" default=true >}}

[flux]: https://fluxcd.io/
[yesterday's post]: /2022/04/19/encrypted-gitops-secrets-with-flux-and-age/
[HelmRelease]: https://fluxcd.io/docs/components/helm/helmreleases/
[gitops-ng repository]: https://github.com/major/gitops-ng/tree/main/namespaces/traefik
[ACME docs]: https://doc.traefik.io/traefik/https/acme/