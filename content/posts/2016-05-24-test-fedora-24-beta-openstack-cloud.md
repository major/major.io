---
title: Test Fedora 24 Beta in an OpenStack cloud
author: Major Hayden
type: post
date: 2016-05-25T03:17:35+00:00
url: /2016/05/24/test-fedora-24-beta-openstack-cloud/
dsq_thread_id:
  - 4855357724
categories:
  - Blog Posts
tags:
  - fedora
  - openstack
  - web

---
Although there are a few weeks remaining before [Fedora 24][1] is released, you can test out the Fedora 24 Beta release today! This is a great way to get a [sneak peek at new features][2] and help find bugs that still need a fix.

[<img src="/wp-content/uploads/2012/01/fedorainfinity.png" alt="Fedora Infinity Logo" width="105" height="102" class="alignright size-full wp-image-2712" />][3]

The [Fedora Cloud][4] image is available for download from your favorite [local mirror][5] or directly from [Fedora's servers][6]. In this post, I'll show you how to import this image into an OpenStack environment and begin testing Fedora 24 Beta.

One last thing: this is beta software. It has been reliable for me so far, but your experience may vary. I would recommend waiting for the final release before deploying any mission critical applications on it.

## Importing the image

The older glance client (version 1) allows you to import an image from a URL that is reachable from your OpenStack environment. This is helpful since my OpenStack cloud has a much faster connection to the internet (1 Gbps) than my home does (~ 20 mbps upload speed). However, the functionality to import from a URL was [removed in version 2 of the glance client][7]. The [OpenStackClient][8] doesn't offer the feature either.

There are two options here:

  * Install an older version of the glance client
  * Use Horizon (the web dashboard)

Getting an older version of glance client installed is challenging. The OpenStack requirements file for the liberty release leaves the version of glance client without a maximum version cap and it's difficult to get all of the dependencies in order to make the older glance client work.

Let's use Horizon instead so we can get back to the reason for the post.

## Adding an image in Horizon

Log into the Horizon panel and click **Compute > Images**. Click **+ Create Image** at the top right of the page and a new window should appear. Add this information in the window:

  * **Name:** Fedora 24 Cloud Beta
  * **Image Source:** Image Location
  * **Image Location:** See footnote[^1]
  * **Format:** QCOW2 - QEMU Emulator
  * **Copy Data:** _ensure the box is checked_

When you're finished, the window should look like this:

[<img src="/wp-content/uploads/2016/05/horizon_image.png" alt="Adding Fedora 24 Beta image in Horizon" width="555" height="617" class="aligncenter size-full wp-image-6249" srcset="/wp-content/uploads/2016/05/horizon_image.png 740w, /wp-content/uploads/2016/05/horizon_image-270x300.png 270w" sizes="(max-width: 555px) 100vw, 555px" />][10]

Click **Create Image** and the images listing should show **Saving** for a short period of time. Once it switches to **Active**, you're ready to build an instance.

## Building the instance

Since we're already in Horizon, we can finish out the build process there.

On the image listing page, find the row with the image we just uploaded and click **Launch Instance** on the right side. A new window will appear. The **Image Name** drop down should already have the Fedora 24 Beta image selected. From here, just choose an instance name, select a security group and keypair (on the _Access & Security_ tab), and a network (on the _Networking_ tab). Be sure to choose a flavor that has some available storage as well (_m1.tiny_ is not enough).

Click **Launch** and wait for the instance to boot.

Once the instance build has finished, you can connect to the instance over ssh as the _fedora_ user. If your [security group allows the connection][11] and your keypair was configured correctly, you should be inside your new Fedora 24 Beta instance!

Not sure what to do next? Here are some suggestions:

  * Update all packages and reboot _(to ensure that you are testing the latest updates)_
  * Install some familiar applications and verify that they work properly
  * Test out your existing automation or configuration management tools
  * Open bug tickets!

 [1]: https://fedoraproject.org/wiki/Releases/24/Schedule
 [2]: https://fedoraproject.org/wiki/Releases/24/ChangeSet
 [3]: /wp-content/uploads/2012/01/fedorainfinity.png
 [4]: https://getfedora.org/en/cloud/
 [5]: https://admin.fedoraproject.org/mirrormanager/mirrors/Fedora/24/x86_64
 [6]: https://getfedora.org/en/cloud/download/
 [7]: https://wiki.openstack.org/wiki/Glance-v2-v1-client-compatability
 [8]: http://docs.openstack.org/developer/python-openstackclient/
 [10]: /wp-content/uploads/2016/05/horizon_image.png
 [11]: /2016/05/16/troubleshooting-openstack-network-connectivity/

[^1]: Fedora 24 no longer exists on download mirrors.
