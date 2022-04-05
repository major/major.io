---
title: Preventing critical services from deploying on the same OpenStack host
author: Major Hayden
type: post
date: 2016-08-09T17:07:35+00:00
url: /2016/08/09/preventing-critical-services-from-deploying-on-the-same-openstack-host/
dsq_thread_id:
  - 5052783217
categories:
  - Blog Posts
tags:
  - database
  - fedora
  - general advice
  - openstack
  - python

---
![1]

OpenStack's compute service, nova, manages all of the virtual machines within a OpenStack cloud. When you ask nova to build an instance, or a group of instances, nova's scheduler system determines which hypervisors should run each instance. The scheduler uses [filters][2] to figure out where each instance belongs.

However, there are situations where the scheduler might put more than one of your instances on the same host, especially when resources are constrained. This can be a problem when you deploy certain highly available applications, like MariaDB and Galera. If more than one of your database instances landed on the same physical host, a failure of that physical host could take down more than one database instance.

## Filters to the rescue

The scheduler offers the [ServerGroupAntiAffinityFilter][3] filter for these deployments. This allows a user to create a server group, apply a policy to the group, and then begin adding servers to that group.

If the scheduler filter can't find a way to fulfill the anti-affinity request (which often happens if the hosts are low on resources), it will fail the entire build transaction with an error. In other words, unless the entire request can be fulfilled, it won't be deployed.

Let's see how this works in action on an OpenStack Mitaka cloud deployed with [OpenStack-Ansible][4].

## Creating a server group

We can use the [openstackclient][5] tool to create our server group:

```
$ openstack server group create --policy anti-affinity db-production
+----------+--------------------------------------+
| Field    | Value                                |
+----------+--------------------------------------+
| id       | cd234914-980a-42f2-b77c-602a7cc0080f |
| members  |                                      |
| name     | db-production                        |
| policies | anti-affinity                        |
+----------+--------------------------------------+
```


We've told nova that we want all of the instances in the `db-production` group to land on different OpenStack hosts. I'll copy the `id` to my clipboard since I'll need that UUID for the next step.

## Adding hosts to the group

My small OpenStack cloud has four hypervisors, so I can add four instances to this server group:

```
$ openstack server create \
  --flavor m1.small \
  --image "Fedora 24" \
  --nic net-id=bc8895ab-98f7-478f-a54a-36b121f7bb3f \
  --key-name personal_servers \
  --hint "group=cd234914-980a-42f2-b77c-602a7cc0080f" \
  --max 4
  prod-db
```


This `server create` command looks fairly standard, but I've added the `--hint` parameter to specify that we want these servers scheduled as part of the group we just created. Also, I've requested for four servers to be built at the same time. After a few moments, we should have four servers active:

```
$ openstack server list --name prod-db -c ID -c Name -c Status
+--------------------------------------+-----------+--------+
| ID                                   | Name      | Status |
+--------------------------------------+-----------+--------+
| 7e7a81f3-eb02-4751-93c1-a0de999b8423 | prod-db-4 | ACTIVE |
| b742fb58-8ea4-4e26-bfbf-645a698fbb26 | prod-db-3 | ACTIVE |
| 78c7a43c-4deb-40da-a419-e62db37ab41a | prod-db-2 | ACTIVE |
| 7b8af038-6441-40c0-87c8-0a1acced17a6 | prod-db-1 | ACTIVE |
+--------------------------------------+-----------+--------+
```


If we check the instances, they should be on different hosts:

```
$ for i in {1..4}; do openstack server show prod-db-${i} -c hostId -f shell; done
hostid="5fea4e5862f82f051e26caf926fe34bd3a9f1439b08a464f817b4c61"
hostid="65d87faf6d9baa110afa5f2e0308781dde4629142170b2c9af1f090b"
hostid="243f833055303efe838b3233f7ba6e1993fb28895ae11c724f10cc73"
hostid="54df76a1e66bd8585cc3c1f8f38e8f4937456394f2409daf2a8b4c2e"
```


Success!

If we try to build one more instance, it should fail since the scheduler cannot fulfill the anti-affinity policy applied to server group:

```
$ openstack server create \
  --flavor m1.small \
  --image "Fedora 24" \
  --nic net-id=bc8895ab-98f7-478f-a54a-36b121f7bb3f \
  --key-name personal_servers \
  --hint "group=cd234914-980a-42f2-b77c-602a7cc0080f" \
  --wait \
  prod-db-5
Error creating server: prod-db-5
Error creating server
$ openstack server show prod-db-5 -c fault -f shell
fault="{u'message': u'No valid host was found. There are not enough hosts available.', u'code': 500...
```


The scheduler couldn't find a valid host for a fifth server in the anti-affinity group.

_Photo credit: ["crowded houses" from jesuscm on Flickr][6]_

 [1]: /wp-content/uploads/2016/08/6312423035_2c53fe78e7_b-e1470762211193.jpg
 [2]: http://docs.openstack.org/mitaka/config-reference/compute/scheduler.html#filters
 [3]: http://docs.openstack.org/mitaka/config-reference/compute/scheduler.html#servergroupantiaffinityfilter
 [4]: http://docs.openstack.org/developer/openstack-ansible/
 [5]: http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html
 [6]: https://flic.kr/p/aBNPrV
