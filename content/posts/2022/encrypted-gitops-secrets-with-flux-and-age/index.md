---
aliases:
- /2022/04/19/encrypted-gitops-secrets-with-flux-and-age/
author: Major Hayden
date: '2022-04-19'
summary: Store encrypted kubernetes secrets safely in your gitops repository with
  easy-to-use age encryption. 🔐
tags:
- flux
- gitops
- kubernetes
- linux
- security
title: Encrypted gitops secrets with flux and age
---

Kubernetes has always felt like an enigma to me. On one hand, I love containers and I
use them daily for personal and work projects. On the other hand, kubernetes feels like
a heavy, burdensome set of tools that can be difficult to maintain over time. Keeping
things organized in kubernetes deployments always felt challenging and unwieldy.

## What about this gitops thing?

A friend suggested looking into the gitops realm as a way to tame container deployments.
Quick Google searches revealed that gitops is a **mindset shift** _(like DevOps)_ and
not a product that a vendor can sell you.

At its core, gitops involves tracking the state of a deployment through version control.
Nothing updates the deployment unless it comes through version control first, and the
deployment should deploy itself based on the state specified in version control.

I found a few things intriguing:

1. The gitops mindset forces you to get organized **before you deploy**, not after.
2. Gitops favors smaller change sets with better notes on each change.
3. CI can tell you how a change will work (or not work).
4. You can look at other people's gitops repositories for how they accomplished certain
   automation tasks. _(Sometimes these include best practices and sometimes they most
   definitely do not.)_ 🤭

This sounds great! My kubernetes manifests and configuration lives in one place in an
organized way. But wait -- how do I handle secrets? 😱

## About secrets

Kubernetes offers a resource type called [secrets]. Although secrets and [ConfigMaps]
both do similar jobs of providing configuration data for various kubernetes resources,
secrets exist to hold sensitive information such as passwords, API keys, or TLS
certificate data. Bear in mind that neither are encrypted within the cluster itself.

In the past, I loaded kubernetes secrets by hand with `kubectl apply` and kept them out
of any shared storage, including git repositories. However, in my quest to follow the
gitops way, I wanted a better option with much less manual work. My goal is to build a
kubernetes deployment that could be redeployed from the git repository at a moment's
notice with the least amount of work required.

[secrets]: https://kubernetes.io/docs/concepts/configuration/secret/
[ConfigMaps]: https://kubernetes.io/docs/concepts/configuration/configmap/

## Secrets in git

Everyone knows that one should never store secrets in git. GitHub even has a special bot
that roams around repositories to find accidentally committed keys and tokens. The bot
notifies you about these problems within moments of your `git push` and it even takes
steps to disable certain API or SSH keys if they're attached to your repository
somewhere.

What about a private GitHub repository? Sure, that's one way to keep secrets away from
prying eyes, but if you ever want to open up the repository later, you have some secrets
in your history that must be cleaned. You also need deploy keys so that your cluster can
access the code in your private repository. It's a hassle.

What about encrypting the secrets before uploading? On the plus side, you can use a
public repository and share your code with someone else. No secrets appear in your git
history, either. However, your kubernetes cluster must have a way to decrypt these
secrets on the fly so it can reconcile any changes you make in the git repository.

## Decrypting secrets with flux

After lots of reading and poking through git repositories, I settled on [flux] as my
gitops tool for kubernetes. It has an easy bootstrap process and it takes care of
configuring git repositories for you. It supports various decryption tools, including
the very popular [SOPS] from Mozilla.

SOPS takes a kubernetes secret and encrypts it while maintaining the original structure
of the secrets file itself. This is handy because it encrypts the secret _value_ but
leaves the _keys_ as plain text. Troubleshooting gets easier when you know an
environment variable is present even if you can't see the value.

Flux provides great documentation for [using SOPS to manage secrets].

But wait, SOPS supports PGP, age, Google Cloud's KMS, Azure's Key Vault, Hashicorp
Vault, and others. How do we decide?

[flux]: https://fluxcd.io/
[SOPS]: https://github.com/mozilla/sops
[using SOPS to manage secrets]: https://fluxcd.io/docs/guides/mozilla-sops/

## Secrets backend bonanza

I want to keep my kubernetes deployment as lean and simple as possible, so that
eliminated the SOPS backends that require additional services, such as the Google Cloud,
Azure, or Hashicorp Vault options.

That leaves me with PGP and age. I've used PGP a million times and it seemed like the
obvious choice. But then I thought: **what the heck is age?**

A friend told me that [age] _(pronounced AHH-gey_) saved him plenty of headaches because
it's so much simpler than dealing with gnupg keyrings and PGP keys. It has smaller keys
that alleviate copy/paste issues and it's designed for encrypting files. Sensible
defaults also eliminate the need for complex configuration.

Let's combine SOPS with an age backend for storing our secrets in GitHub with flux
decrypting those secrets on the fly!

[age]: https://github.com/FiloSottile/age

## Generating a key

Start by installing SOPS and age using their documentation:

* [Install SOPS](https://github.com/mozilla/sops#download)
* [Install age](https://github.com/FiloSottile/age#installation)

Enjoy the hilariously brief `age-keygen` help text:

```console
$ age-keygen --help
Usage:
    age-keygen [-o OUTPUT]
    age-keygen -y [-o OUTPUT] [INPUT]

Options:
    -o, --output OUTPUT       Write the result to the file at path OUTPUT.
    -y                        Convert an identity file to a recipients file.
```

Let's make a key!

```console
$ age-keygen -o sops-key.txt
Public key: age1wnvnq64tpze4zjdmq2n44eh7jzkxf5ra7mxjvjld6cjwtaddffqqc54w23

$ cat sops-key.txt
# created: 2022-04-19T14:41:19-05:00
# public key: age1wnvnq64tpze4zjdmq2n44eh7jzkxf5ra7mxjvjld6cjwtaddffqqc54w23
AGE-SECRET-KEY-13T0N7N0W9NZKDXEFYYPWU7GN65W3UPV6LRERXUZ3ZGED8SUAAQ4SK6SMDL
```

As you might expect with any other encryption scheme, the public key is the one we use
to encrypt (and it's okay to share), while the secret key decrypts data (and must be
kept private).

Next, make encryption easier by creating a small configuration file for SOPS. This
allows you to encrypt quickly without telling SOPS which key you want to use. Create a
`.sops.yaml` file like this one in the root directory of your flux repository:

```yaml
creation_rules:
  - encrypted_regex: '^(data|stringData)$'
    age: age1wnvnq64tpze4zjdmq2n44eh7jzkxf5ra7mxjvjld6cjwtaddffqqc54w23
```

Add your _public key_ to the `age` key above in the YAML file.

Let's test it to ensure SOPS and age are working together:

```console
$ kubectl create secret generic sopstest --from-literal=foo=bar -o yaml \
    --dry-run=client | tee sops-test-secret.yaml
apiVersion: v1
data:
  foo: YmFy
kind: Secret
metadata:
  creationTimestamp: null
  name: sopstest

$ sops -e sops-test-secret.yaml | tee sops-test-secret-encrypted.yaml
apiVersion: v1
data:
    foo: ENC[AES256_GCM,data:UZY1VQ==,iv:54ce6xcRc28sjBQU4OjvbBUkvFhs4UKxaM8lOQtsbI4=,tag:Ms906PUkzSgNVpV2A2oG9Q==,type:str]
kind: Secret
metadata:
    creationTimestamp: null
    name: sopstest
sops:
    kms: []
    gcp_kms: []
    azure_kv: []
    hc_vault: []
    age:
        - recipient: age1w8dts3ptgqsqac60z8v2asney6akyktad43k5reguj5suj6y83rstgyh8v
          enc: |
            -----BEGIN AGE ENCRYPTED FILE-----
            YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBCM2prVitpS09wY3Q4NFpZ
            eVlEc0xnOHRxT0poSk0wSWwrMDM2QVRJbjJRCjBMTjhiU1BwYWYwbVo5bWZlTjVF
            c3Z6QXdNekM4Y0wrcGVNZ052VUR3MDgKLS0tIFo5dGNyM2Nxb2NVNm5odzkwNVJs
            T1BXK0JhN3lKK0VaZTZTWUhyTHF0aWMKZtB5/fOeyjTy4FCkmlfn15OPabe0VKeZ
            rJMdx3MyF+RDQZHjs9nk9drb2bnAZ2ew1uwx31DkayhGDGF3rpk+oA==
            -----END AGE ENCRYPTED FILE-----
    lastmodified: "2022-04-19T19:50:20Z"
    mac: ENC[AES256_GCM,data:Hhu+4TxpI5Vpi4ZSXI79Lw+wEaZ6HxwfCTyRg6kExCBLHLJbULEfug11VTMrbMz6hpLnaRqBkq/FqLWqcxphzwTJ37p7OMeEtm7c7fN//t1sGjF96TP3MyqRypDbIFQCOPXEpnegASpis5HHLCLkvELXwyd/ucHlQs7gTUTzT4g=,iv:ssAD21AJ+wZr+XqrdZlRKmJeHbF5Sop5SGC8kAlQF+E=,tag:xZQvQltcb3wSnS5nQOjBFg==,type:str]
    pgp: []
    encrypted_regex: ^(data|stringData)$
    version: 3.7.2
```

So what did we just do?

* We created a generic secret containing `foo: bar` and dumped it into a file without
  sending it to kubernetes.
* You might notice that `bar` became `YmFy` there. This is because kubernetes uses
  base64 to **encode** _(not encrypt)_ secret values to avoid YAML parsing issues.
* Finally, we told SOPS to encrypt our secret to stdout, which we placed into a new
  file. SOPS knew which key to use because of our `.sops.yaml` configuration file.

> 💣 Use caution with raw, unencrypted secret files in your local repository. Ensure
> they cannot be committed to a repository accidentally via some sort of mechanism, such
> as listing them in your `.gitignore` or removing them as soon as you've finished
> encrypting them.

If we need to check or update our secret, we can always decrypt it using `sops -d`.

## Decryption in flux

In one of the earlier sections, I talked about that the system that reconciles the
deployment with the repository (flux in this case), must be able to decrypt secrets all
by itself. But wait, how do we give flux the key?

I have not found a good automated way to get this done (yet), so this step is manual for
now. Luckily, this is a once per cluster task.

Our original key generation step created a `sops-key.txt` file and we need to create a
secret from that file that only flux can see:

```shell
kubectl -n flux-system create secret generic sops-age \
  --from-file=age.agekey=sops-key.txt
```

This command creates a generic secret called `sops-age` with our key text stored in the
`age.ageKey` YAML key. The secret exists only inside the `flux-system` namespace so that
only the pods in that namespace have permission to read it.

Finally, we must tell flux that it needs to decrypt secrets and we must provide the
location of the decryption key. Flux is built heavily on [kustomize] manifests and
that's where our key configuration belongs.

Here's an example from my kustomization file for deploying [traefik]:

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: traefik
  namespace: flux-system
spec:
  interval: 10m0s
  path: ./apps/traefik
  prune: true
  dependsOn:
    - name: cert-manager-config
  sourceRef:
    kind: GitRepository
    name: flux-system
  # Decryption configuration starts here
  decryption:
    provider: sops
    secretRef:
      name: sops-age
```

The last four lines tell flux about our `sops-age` secret and that we're using the SOPS
backend for decryption. Commit this change and push it to your git repository.

So what happens when you commit and push an encrypted secrets file like the one we made
above for `foo: bar`?

* Flux sees the change in the git repository.
* When it reaches the encrypted secret, it digs up the decryption configuration.
* From there, it retrieves the `sops-age` secret, reads the key, and uses SOPS with age
  to decrypt the secret.
* Flux applies the secret resource in kubernetes.

At this point, if you retrieve the secret with `kubectl -n my_namespace get
secret/mysecret -o yaml`, you get the unencrypted secret. Flux decrypts the secret from
your git repository and adds it to kubernetes, but it remains unencrypted in the
kubernetes cluster. This allows pods in the namespace to read data from the secret
without any further decryption.

## Epilogue

You might be asking: _"How does this whole flux thing work? How do I set up flux and
fully embrace the gitops lifestyle?"_

Don't worry. You didn't miss anything. That's a post I have yet to write. 😉

[kustomize]: https://kustomize.io/
[traefik]: https://traefik.io/