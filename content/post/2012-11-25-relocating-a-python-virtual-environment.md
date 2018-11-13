---
title: Relocating a python virtual environment
author: Major Hayden
type: post
date: 2012-11-25T21:27:47+00:00
url: /2012/11/25/relocating-a-python-virtual-environment/
dsq_thread_id:
  - 3644199398
categories:
  - Blog Posts
tags:
  - development
  - openstack
  - python

---
Python's [virtual environment capability][1] is extremely handy for situations where you don't want the required modules for a particular python project to get mixed up with your system-wide installed modules. If you work on large python projects (like [OpenStack][2]), you'll find that the applications may require certain versions of python modules to operate properly. If these versions differ from the system-wide python modules you already have installed, you might get unexpected results when you try to run the unit tests.

If you build a virtual environment and inspect the files found within the _bin_ directory of the virtual environment, you'll find that the first line in the executable scripts is set to use the python version specific to that virtual environment. Here's an example from a virtual environment containing the OpenStack glance project:

```
#!/home/major/glance/.venv/bin/python
# EASY-INSTALL-SCRIPT: 'glance==2013.1','glance-api'
__requires__ = 'glance==2013.1'
import pkg_resources
pkg_resources.run_script('glance==2013.1', 'glance-api')
```


However, what if I wanted to take this virtual environment and place it somewhere else on the server where multiple people could use it? The path in the first line of the scripts in _bin_ will surely break.

The first option is to make the virtual environment relocatable. This can produce unexpected results for some software projects, so be sure to test it out before trying to use it in a production environment.

```


A quick check of the same python file now shows this:

```
#!/usr/bin/env python2.6

import os; activate_this=os.path.join(os.path.dirname(os.path.realpath(__file__)), 'activate_this.py'); execfile(activate_this, dict(__file__=activate_this)); del os, activate_this

# EASY-INSTALL-SCRIPT: 'glance==2013.1','glance-api'
```


This allows for the path to the activate_this.py script to be determined at runtime and allows you to move your virtual environment wherever you like.

In situations where one script within _bin_ would import another script within _bin_, things can get a little dicey. These are edge cases, of course, but you can get a similar effect by adjusting the path in the first line of each file within _bin_ to the new location of the virtual environment. If you move the virtual environment again, be sure to alter the paths again with `sed`.

 [1]: http://pypi.python.org/pypi/virtualenv
 [2]: http://openstack.org/
