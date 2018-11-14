---
title: OpenStack instances come online with multiple network ports attached
author: Major Hayden
type: post
date: 2016-08-03T14:40:16+00:00
url: /2016/08/03/openstack-instances-come-online-with-multiple-network-ports-attached/
dsq_thread_id:
  - 5037029729
categories:
  - Blog Posts
tags:
  - kvm
  - network
  - networking
  - openstack
  - python
  - virtualization

---
![1]

I ran into an interesting problem recently in my production OpenStack deployment that runs the Mitaka release. On various occasions, instances were coming online with multiple network ports attached, even though I only asked for one network port.

## The problem

If I issued a build request for ten instances, I'd usually end up with this:

  * 6 instances with one network port attached
  * 2-3 instances with two network ports attached _(not what I want)_
  * 1-2 instances with three or four network ports attached _(**definitely** not what I want)_

When I examined the instances with multiple network ports attached, I found that one of the network ports would be marked as _up_ while the others would be marked as _down_. However, the IP addresses associated with those extra ports would still be associated with the instance in horizon and via the nova API. All of the network ports seemed to be fully configured on the neutron side.

## Digging into neutron

The neutron API logs are fairly chatty, especially while instances are building, but I found two interesting log lines for one of my instances:

```
172.29.236.41,172.29.236.21 - - [02/Aug/2016 14:03:11] "GET /v2.0/ports.json?tenant_id=a7b0519330ed481884431102a72dd04c&device_id=05eef1bb-5356-43d9-86c9-4d9854d4d46b HTTP/1.1" 200 2137 0.025282
172.29.236.11,172.29.236.21 - - [02/Aug/2016 14:03:15] "GET /v2.0/ports.json?tenant_id=a7b0519330ed481884431102a72dd04c&device_id=05eef1bb-5356-43d9-86c9-4d9854d4d46b HTTP/1.1" 200 3098 0.027803
```


There are two requests to create network ports for this instance and neutron is allocating ports to both requests. This would normally be just fine, but I only asked for one network port on this instance.

The IP addresses making the requests are unusual, though. `172.29.236.11` and `172.29.236.41` are two of the hypervisors within my cloud. Why are both of them asking neutron for network ports? Only one of those hypervisors should be building my instance, not both. After checking both hypervisors, I verified that the instance was only provisioned on one of the hosts and not both.

## Looking at nova-compute

The instance ended up on the `172.29.236.11` hypervisor once it finished building and the logs on that hypervisor looked fine:

```
nova.virt.libvirt.driver [-] [instance: 05eef1bb-5356-43d9-86c9-4d9854d4d46b] Instance spawned successfully.
```


I logged into the `172.29.236.41` hypervisor since it was the one that asked neutron for a port but it never built the instance. The logs there had a much different story:

```
[instance: 05eef1bb-5356-43d9-86c9-4d9854d4d46b] Instance failed to spawn
Traceback (most recent call last):
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/compute/manager.py", line 2218, in _build_resources
    yield resources
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/compute/manager.py", line 2064, in _build_and_run_instance
    block_device_info=block_device_info)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 2773, in spawn
    admin_pass=admin_password)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 3191, in _create_image
    instance, size, fallback_from_host)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 6765, in _try_fetch_image_cache
    size=size)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/imagebackend.py", line 251, in cache
    *args, **kwargs)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/imagebackend.py", line 591, in create_image
    prepare_template(target=base, max_size=size, *args, **kwargs)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/oslo_concurrency/lockutils.py", line 271, in inner
    return f(*args, **kwargs)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/imagebackend.py", line 241, in fetch_func_sync
    fetch_func(target=target, *args, **kwargs)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/libvirt/utils.py", line 429, in fetch_image
    max_size=max_size)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/images.py", line 120, in fetch_to_raw
    max_size=max_size)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/virt/images.py", line 110, in fetch
    IMAGE_API.download(context, image_href, dest_path=path)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/image/api.py", line 182, in download
    dst_path=dest_path)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/image/glance.py", line 383, in download
    _reraise_translated_image_exception(image_id)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/image/glance.py", line 682, in _reraise_translated_image_exception
    six.reraise(new_exc, None, exc_trace)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/image/glance.py", line 381, in download
    image_chunks = self._client.call(context, 1, 'data', image_id)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/nova/image/glance.py", line 250, in call
    result = getattr(client.images, method)(*args, **kwargs)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/glanceclient/v1/images.py", line 148, in data
    % urlparse.quote(str(image_id)))
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/glanceclient/common/http.py", line 275, in get
    return self._request('GET', url, **kwargs)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/glanceclient/common/http.py", line 267, in _request
    resp, body_iter = self._handle_response(resp)
  File "/openstack/venvs/nova-13.3.0/lib/python2.7/site-packages/glanceclient/common/http.py", line 83, in _handle_response
    raise exc.from_response(resp, resp.content)
ImageNotFound: Image 8feacda9-91fd-48ce-b983-54f7b6de6650 could not be found.
```


This is one of those occasions where I was glad to find an exception in the log. The image that couldn't be found is an image I've used regularly in the environment before, and I know it exists.

## Gandering at glance

First off, I asked glance what it knew about the image:

```
$ openstack image show 8feacda9-91fd-48ce-b983-54f7b6de6650
+------------------+------------------------------------------------------+
| Field            | Value                                                |
+------------------+------------------------------------------------------+
| checksum         | 8de08e3fe24ee788e50a6a508235aa64                     |
| container_format | bare                                                 |
| created_at       | 2016-08-03T01:25:34Z                                 |
| disk_format      | qcow2                                                |
| file             | /v2/images/8feacda9-91fd-48ce-b983-54f7b6de6650/file |
| id               | 8feacda9-91fd-48ce-b983-54f7b6de6650                 |
| min_disk         | 0                                                    |
| min_ram          | 0                                                    |
| name             | Fedora 24                                            |
| owner            | a7b0519330ed481884431102a72dd04c                     |
| properties       | description=''                                       |
| protected        | False                                                |
| schema           | /v2/schemas/image                                    |
| size             | 204590080                                            |
| status           | active                                               |
| tags             |                                                      |
| updated_at       | 2016-08-03T01:25:39Z                                 |
| virtual_size     | None                                                 |
| visibility       | public                                               |
+------------------+------------------------------------------------------+
```


If glance knows about the image, why can't that hypervisor build an instance with that image? While I was scratching my head, [Kevin Carter][2] walked by my desk and joined in the debugging.

He asked about how I had deployed glance and what storage backend I was using. I was using the regular file storage backend since I don't have swift deployed in the environment. He asked me how many glance nodes I had (I had two) and if I was doing anything to sync the images between the glance nodes.

Then it hit me.

[<img src="/wp-content/uploads/2016/08/stitch_frustrated.gif" alt="Frustrated Stitch" width="260" height="179" class="aligncenter size-full wp-image-6367" />][3]

Although both glance nodes knew about the image (since that data is in the database), **only one of the glance nodes had the actual image content (the actual qcow2 file) stored**. That means that if a hypervisor requests the image from a glance node that knows about the image but doesn't have it stored, the hypervisor won't be able to retrieve the image.

Unfortunately, the checks go in this order on the nova-compute side:

  1. Ask glance if this image exists and if this tenant can use it
  2. Configure the network
  3. Retrieve the image

If a hypervisor rolls through steps one and two without issues, but then fails on step 3, the network port will be provisioned but won't come up on the instance. There's nothing that cleans up that port in the Mitaka release, so it requires manual intervention.

## The fix

As a temporary workaround, I took one of the glance nodes offline so that only one glance node is being used. After hundreds of builds, all of the instances came up with only one network port attached!

There are a few options for long-term fixes.

I could deploy swift and put glance images into swift. That would allow me to use multiple glance nodes with the same swift backend. Another option would be to use an existing swift deployment, such as Rackspace's Cloud Files product.

Since I'm not eager to deploy swift in my environment for now, I decided to remove the second glance node and reconfigure nova to use only one glance node. That means I'm running with only one glance node and a failure there could be highly annoying. However, that trade-off is fine with me until I can get around to deploying swift.

**UPDATE:** I've opened [a bug][4] for nova so that the network ports are cleaned up if the instance fails to build.

_Photo credit: [Flickr: pascalcharest][5]_

 [1]: /wp-content/uploads/2016/08/308357541_222d1b2e2a_b-e1470234736818.jpg
 [2]: https://twitter.com/cloudnull
 [3]: /wp-content/uploads/2016/08/stitch_frustrated.gif
 [4]: https://bugs.launchpad.net/nova/+bug/1609526
 [5]: https://flic.kr/p/tfpXk
