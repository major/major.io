---
title: Testing grouped environment support for supernova
author: Major Hayden
type: post
date: 2014-05-05T02:43:04+00:00
url: /2014/05/04/testing-grouped-environment-support-for-supernova/
dsq_thread_id:
  - 3678887916
categories:
  - Blog Posts
tags:
  - openstack
  - python
  - supernova

---
I've added some grouped environment support for supernova tonight. This allows you to run the same action across a group of environments listed in your supernova configuration file. To give you an idea of how this works, I have two environments in my supernova file called _prodord_ and _prodiad_. Both of them are my production environments at Rackspace:

```ini
[prodord]
SUPERNOVA_GROUP=prodrax
OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/
OS_AUTH_SYSTEM=rackspace
OS_REGION_NAME=ORD
OS_TENANT_NAME=USE_KEYRING['prodcloudauthuser']
OS_PROJECT_ID=USE_KEYRING['prodcloudauthuser']
OS_PASSWORD=USE_KEYRING['prodcloudauthpass']
OS_PROJECT_ID=[my account number]

[prodiad]
SUPERNOVA_GROUP=prodrax
OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/
OS_AUTH_SYSTEM=rackspace
OS_REGION_NAME=IAD
OS_TENANT_NAME=USE_KEYRING['prodcloudauthuser']
OS_PROJECT_ID=USE_KEYRING['prodcloudauthuser']
OS_PASSWORD=USE_KEYRING['prodcloudauthpass']
OS_PROJECT_ID=[my account number]
```


You might notice the `SUPERNOVA_GROUP` configuration option there. That allows me to put these environments into a group called _prodrax_. I can make requests to them as if they were one environment:

```
$ supernova prodrax keypair-list
[SUPERNOVA] Running nova against prodord...
+------------------+-------------------------------------------------+
| Name             | Fingerprint                                     |
+------------------+-------------------------------------------------+
| personal_servers | 05:cd:ff:f1:c8:04:7d:74:d8:44:be:9b:a1:12:e0:b8 |
+------------------+-------------------------------------------------+
[SUPERNOVA] Running nova against prodiad...
+------------------+-------------------------------------------------+
| Name             | Fingerprint                                     |
+------------------+-------------------------------------------------+
| personal_servers | 05:cd:ff:f1:c8:04:7d:74:d8:44:be:9b:a1:12:e0:b8 |
+------------------+-------------------------------------------------+
```


This allows you to list instances across multiple environments or take actions against instances in multiple environments. To begin testing the functionality, simply add `SUPERNOVA_GROUP=<em>group_name</em>` to your commonly used environments and use the group name in place of the environment name when you use supernova.

The new functionality isn't in PyPi just yet, but you can get the changes directly from the [GitHub repo][1]:

```
git clone https://github.com/major/supernova.git
cd supernova
python setup.py install
```


 [1]: https://github.com/major/supernova
