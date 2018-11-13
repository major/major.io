---
title: 'Talk Recap: Automated security hardening with OpenStack-Ansible'
author: Major Hayden
type: post
date: 2016-04-26T21:19:02+00:00
url: /2016/04/26/talk-recap-automated-security-hardening-openstack-ansible/
dsq_thread_id:
  - 4779343713
categories:
  - Blog Posts
tags:
  - ansible
  - openstack
  - security
  - ubuntu
  - virtualization

---
Today is the second day of the [OpenStack Summit in Austin][1] and I offered up a talk on host security hardening in OpenStack clouds. You can [download the slides][2] or watch the video here:

<span class="embed-youtube" style="text-align:center; display: block;"><iframe class='youtube-player' type='text/html' width='640' height='360' src='https://www.youtube.com/embed/q_uDtdpLmpg?version=3&#038;rel=1&#038;fs=1&#038;autohide=2&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;wmode=transparent' allowfullscreen='true' style='border:0;'></iframe></span>

Here's a quick recap of the talk and the conversations afterward:

## Security tug-of-war

Information security is a challenging task, mainly because it is more than just a technical problem. Technology is a big part of it, but communication, culture, and compromise are also critical. I flashed up this statement on the slides:

<blockquote class="twitter-tweet tw-align-center" data-width="500">
  <p lang="en" dir="ltr">
    "People should feel like security is something they are part of; not something that is done to them" <a href="https://twitter.com/majorhayden">@majorhayden</a> <a href="https://t.co/Blh9rZp0uL">pic.twitter.com/Blh9rZp0uL</a>
  </p>

  <p>
    &mdash; Rackspace (@Rackspace) <a href="https://twitter.com/Rackspace/status/724998210154979329">April 26, 2016</a>
  </p>
</blockquote>



In the end, the information security teams, the developers _and_ the auditors must be happy. This can be a challenging tightrope to walk, but automating some security allows everyone to get what they want in a scalable and repeatable way.

## Meeting halfway

The [openstack-ansible-security role][3] allows information security teams to meet developers or OpenStack deployers halfway. It can easily bolt onto existing Ansible playbooks and manage host security hardening for Ubuntu 14.04 systems. The role also works in non-OpenStack environments just as well. All of the documentation, configuration, and Ansible tasks are all included with the role.

The role itself applies security configurations to each host in an environment. Those configurations are based on the Security Technical Implementation Guide (STIG) from the Defense Information Systems Agency (DISA), which is part of the United States Department of Defense. The role takes the configurations from the STIG and makes small tweaks to fit an OpenStack environment. All of the tasks are carefully translated from the STIG for Red Hat Enterprise Linux 6 (there is no STIG for Ubuntu currently).

The role is available now as part of OpenStack-Ansible in the Liberty, Mitaka, and Newton releases. Simply adjust `apply_security_hardening` from `false` to `true` and deploy. For other users, the role can easily be used in any Ansible playbook. _(Be sure to review the configuration to ensure its defaults meet your requirements.)_

## Getting involved

[<img src="/wp-content/uploads/2011/11/openstack-justheo.png" alt="OpenStack security" width="232" height="214" class="alignright size-full wp-image-2592" />][4]We need your help! Upcoming plans include Ubuntu 16.04 and CentOS support, a rebase onto the RHEL 7 STIG (which will be finalized soon), and better reporting.

Join us later this week for the OpenStack-Ansible design summit sessions or anytime on Freenode in #openstack-ansible. We're on the OpenStack development mailing list as well (be sure to use the `[openstack-ansible][security]` tags.

## Hallway conversations

Lots of people came by to chat afterwards and offered to join in the development. A few people were hoping it would have been the security "silver bullet", and I reset some expectations.

Some attendees has good ideas around making the role more generic and adding an "OpenStack switch" that would configure many variables to fit an OpenStack environment. That would allow people to use it easily with non-OpenStack environments.

Other comments were around hardening inside of Linux containers. These users had "heavy" containers where the entire OS is virtualized and multiple processes might be running at the same time. Some of the configuration changes (especially the kernel tunables) don't make sense inside a container like that, but many of the others could be useful. For more information on securing Linux containers, watch the video from [Thomas Cameron's talk][5] here at the summit.

## Thank you

I'd like to thank everyone for coming to the talk today and sharing their feedback. It's immensely useful and I pile all of that feedback into future talks. Also, I'd like to thank all of the people at Rackspace who helped me review the slides and improve them.

<iframe src='https://www.slideshare.net/slideshow/embed_code/61387839' width='425' height='348' allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>

 [1]: https://www.openstack.org/summit/austin-2016/
 [2]: http://www.slideshare.net/MajorHayden/automated-security-hardening-with-openstackansible
 [3]: http://docs.openstack.org/developer/openstack-ansible-security
 [4]: /wp-content/uploads/2011/11/openstack-justheo.png
 [5]: https://www.openstack.org/summit/austin-2016/summit-schedule/events/8615
