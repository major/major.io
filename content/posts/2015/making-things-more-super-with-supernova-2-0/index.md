---
aliases:
- /2015/07/18/making-things-more-super-with-supernova-2-0/
author: Major Hayden
date: 2015-07-18 17:42:29
tags:
- development
- openstack
- python
- supernova
title: Making things more super with supernova 2.0
---

[<img src="/wp-content/uploads/2011/08/OpenStackLogo_270x279.jpg" alt="OpenStackLogo supernova" width="270" height="279" class="alignright size-full wp-image-2399" />][1]I started supernova a little over [three years ago][2] with the idea of making it easier to use novaclient. Three years and a few downloads later, it manages multiple different OpenStack clients, like nova, glance, and trove along with some handy features for users who manage a large number of environments.

### What's new?

With some help from some friends who are much better at writing Python than I am (thanks Paul, Matt and Jason), I restructured supernova to make it more testable. The big, awkward SuperNova class was dropped and there are fewer circular imports. In addition, I migrated the cli management components to use the [click][3] module. It's now compatible with Python versions 2.6, 2.7, 3.3 and 3.4.

The overall functionality hasn't changed much, but there's a new option to specify a custom supernova configuration that sits in a non-standard location or with a filename other than `.supernova`. Simply use the `-c` flag:

```
supernova -c ~/work/.supernova dfw list
supernova -c ~/personal/supernova-config-v1 staging list
```


The testing is done with [Travis-CI][4] and code coverage is checked with [Codecov][5]. Pull requests will automatically be checked with unit tests and I'll do my best to urge committers to keep test coverage at 100%.

### Updating supernova

Version 2.0.0 is already in PyPi, so an upgrade using pip is quite easy:

```
pip install -U supernova
```


 [1]: /wp-content/uploads/2011/08/OpenStackLogo_270x279.jpg
 [2]: /2012/06/05/supernova-manage-multiple-openstack-nova-environments-with-ease/
 [3]: http://click.pocoo.org/4/
 [4]: https://travis-ci.org/major/supernova
 [5]: https://codecov.io/github/major/supernova