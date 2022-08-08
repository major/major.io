---
title: 'supernova: Manage multiple OpenStack nova environments with ease'
author: Major Hayden
date: 2012-06-05T13:12:17+00:00
url: /2012/06/05/supernova-manage-multiple-openstack-nova-environments-with-ease/
dsq_thread_id:
  - 3642806988
tags:
  - development
  - nova
  - openstack
  - python
  - rackspace

---
[<img src="/wp-content/uploads/2012/06/firstworldproblems-multiplenovaenvironments-300x199.jpg" alt="" title="firstworldproblems-multiplenovaenvironments" width="300" height="199" class="alignright size-medium wp-image-3435" srcset="/wp-content/uploads/2012/06/firstworldproblems-multiplenovaenvironments-300x199.jpg 300w, /wp-content/uploads/2012/06/firstworldproblems-multiplenovaenvironments.jpg 551w" sizes="(max-width: 300px) 100vw, 300px" />][1]While working on multiple nova ([OpenStack Compute][2]) environments at Rackspace, I found myself thrashing between multiple terminal windows where I had exported environment variables for [python-novaclient][3] to use. I ended up requesting some image and instance deletions in a terminal window only to find that I'd done the deletions in the wrong nova environment. Once I realized what I'd done (and after a small bit of cursing), I knew there had to be a better way to work with multiple environments.

That's the purpose behind a small python project of mine: [supernova][4].

Using supernova gives you a nice set of benefits:

  * switch between environments quickly
  * no worrying about which environment variables are exported in which terminal
  * novarc files are a thing of the past
  * share your simple configuration file skeleton with your teams
  * credentials can be stored in your OS keyring/keychain
  * add novaclient debugging to particular requests without touching configuration files

Installation is very straightforward:

```
git clone git://github.com/major/supernova.git
cd supernova
python setup.py install
```


All of the [configuration instructions and usage examples are over in GitHub][4]. As with any of the code I write, if you find a problem or spot an idea for an improvement, submit an issue or pull request. I try to jump on those as soon as I can.

 [1]: http://major.io/wp-content/uploads/2012/06/firstworldproblems-multiplenovaenvironments.jpg
 [2]: http://openstack.org/projects/compute/
 [3]: https://github.com/openstack/python-novaclient
 [4]: http://major.github.com/supernova/
