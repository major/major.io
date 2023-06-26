---
aliases:
- /2016/06/28/talk-recap/
author: Major Hayden
date: 2016-06-29 03:43:21
tags:
- ansible
- fedora
- general advice
- openstack
- python
- rackspace
- red hat
title: 'Talk recap: The friendship of OpenStack and Ansible'
---

The 2016 Red Hat Summit is underway in San Francisco this week and I delivered a talk with [Robyn Bergeron][2] earlier today. Our talk, _[When flexibility met simplicity: The friendship of OpenStack and Ansible][3]_, explained how Ansible can reduce the complexity of OpenStack environments without sacrificing the flexibility that private clouds offer.

The talk started at the same time as lunch began and the Partner Pavilion first opened, so we had some stiff competition for attendees' attention. However, the live demo worked without issues and we had some good questions when the talk was finished.

This post will cover some of the main points from the talk and I'll share some links for the talk itself and some of the playbooks we ran during the live demo.

## IT is complex and difficult

Getting resources for projects at many companies is challenging. OpenStack makes this a little easier by delivering compute, network, and storage resources on demand. However, OpenStack's flexibility is a double-edged sword. It makes it very easy to obtain virtual machines, but it can be challenging to install and configure.

Ansible reduces some of that complexity without sacrificing flexibility. Ansible comes with plenty of pre-written modules that manage an OpenStack cloud at multiple levels for multiple types of users. Consumers, operators, and deployers can save time and reduce errors by using these modules and providing the parameters that fit their environment.

## Ansible and OpenStack

Ansible and OpenStack are both open source projects that are heavily based on Python. Many of the same dependencies needed for Ansible are needed for OpenStack, so there is very little additional software required. Ansible tasks are written in YAML and the user only needs to pass some simple parameters to an existing module to get something done.

Operators are in a unique position since they can use Ansible to perform typical IT tasks, like creating projects and users. They can also assign fine-grained permissions to users with roles via reusable and extensible playbooks. Deployers can use projects like [OpenStack-Ansible][4] to deploy a production-ready OpenStack cloud.

## Let's build something

In the talk, we went through a scenario for a live demo. In the scenario, the marketing team needed a new website for a new campaign. The IT department needed to create a project and user for them, and then the marketing team needed to build a server. This required some additional tasks, such as adding ssh keys, creating a security group (with rules) and adding a new private network.

The files from the live demo are up on GitHub:

  * [major/ansible-openstack-summit-demo][5]

In the `operator-prep.yml`, we created a project and added a user to the project. That user was given the admin role so that the marketing team could have full access to their own project.

From there, we went through the tasks as if we were a member of the marketing team. The `marketing.yml` playbook went through all of the tasks to prepare for building an instance, actually building the instance, and then adding that instance to the dynamic inventory in Ansible. That playbook also verified the instance was up and performed additional configuration of the virtual machine itself - all in the same playbook.

## What's next?

Robyn shared lots of ways to [get involved in the Ansible community][6]. [AnsibleFest 2016][7] is rapidly approaching and the [OpenStack Summit in Barcelona][8] is happening this October.

## Downloads

The presentation is available in a few formats:

  * [PDF][9]
  * [Slideshare][11]

 [2]: https://twitter.com/robynbergeron
 [3]: https://rh2016.smarteventscloud.com/connect/sessionDetail.ww?SESSION_ID=75675
 [4]: https://github.com/openstack/openstack-ansible
 [5]: https://github.com/major/ansible-openstack-summit-demo
 [6]: https://www.ansible.com/community
 [7]: https://www.ansible.com/ansiblefest
 [8]: https://www.openstack.org/summit/barcelona-2016/
 [9]: http://majorhayden.com/presentations/When%20flexibility%20met%20simplicity-%20The%20friendship%20of%20OpenStack%20and%20Ansible%20-%20Red%20Hat%20Summit%202016.pdf
 [11]: http://www.slideshare.net/MajorHayden/when-flexibility-met-simplicity-the-friendship-of-openstack-and-ansible